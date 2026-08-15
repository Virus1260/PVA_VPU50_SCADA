# PVA Systems VPU-50 SCADA – WebAssembly & Vercel Deployment Troubleshooting Guide

> **Purpose**: A comprehensive guide documenting the architecture, design decisions, and solutions to all issues encountered when compiling Qt 6 / QML to WebAssembly and deploying to Vercel via GitHub Actions.

---

## 1. Architectural Foundation: Why GitHub Actions + Vercel?

```
┌───────────────────────────┐      ┌───────────────────────────────┐      ┌───────────────────────────┐
│     Local Development     │      │     GitHub Actions Runner     │      │      Vercel Global CDN    │
│                           │      │                               │      │                           │
│  • Qt Design Studio       │ ───> │  • Ubuntu 22.04 (Multi-Core)  │ ───> │  • Edge Serverless CDN    │
│  • QML / C++ Code         │ git  │  • Qt 6.8.2 Wasm Compiler     │ CLI  │  • 60 FPS Browser Canvas  │
│  • Local Testing          │ push │  • Emscripten SDK (3.1.56)    │ push │  • Global URL (HTTPS)     │
└───────────────────────────┘      └───────────────────────────────┘      └───────────────────────────┘
```

### Why Not Build Directly on Vercel?
- **Vercel Build Timeout Limit**: Vercel free tier limits build execution to **45 seconds**.
- **Heavy C++ Toolchain Size**: Qt 6 for WebAssembly is a full C++ GUI engine (~2.5 GB with its precompiled libraries, host cross-compilers, and Emscripten toolchain). Downloading and compiling this in an ephemeral container takes 1–2 minutes, exceeding Vercel's execution window.
- **GitHub Actions Advantages**:
  - Provides **free multi-core Linux runners** with a 6-hour execution timeout.
  - Features fast network connections to download Qt packages in ~20 seconds.
  - Automatically compiles the QML project to binary WebAssembly (`.wasm` + `.js`) and ships the static distribution directly to Vercel via the Vercel CLI.

---

## 2. Issues Encountered & Proven Solutions

### Issue 1: `externally-managed-environment` (PEP 668)
- **Symptom**: `pip install aqtinstall` fails on modern Linux distributions with `error: externally-managed-environment`.
- **Root Cause**: Python 3.12+ on modern Ubuntu/Debian protects system packages from direct `pip` modification.
- **Solution**:
  Use an isolated Python virtual environment or install in user space:
  ```bash
  python3 -m venv /tmp/venv
  source /tmp/venv/bin/activate
  pip install aqtinstall ninja cmake
  ```

---

### Issue 2: Regional Mirror Checksum Failures (`Updates.xml`)
- **Symptom**: `WARNING: Failed to download checksum for Updates.xml. This may happen on unofficial mirrors.`
- **Root Cause**: `aqtinstall` defaulted to out-of-sync regional mirrors that were missing package metadata.
- **Solution**:
  Explicitly force `aqtinstall` to fetch directly from the official Qt master repository:
  ```bash
  --base https://download.qt.io
  ```

---

### Issue 3: `ERROR: Failed to locate XML data for Qt version '6.8.0'` & `qtdeclarative not found`
- **Symptom**: `aqtinstall` reported `Failed to locate XML data` or `The packages ['qtdeclarative'] were not found`.
- **Root Cause**:
  1. In the Qt SDK repository, WebAssembly packages are classified under target `all_os wasm <version>`, not `linux desktop`.
  2. The active stable Qt 6.8 release on the servers is `6.8.2`.
  3. In Qt 6.8+, `qtdeclarative` (the QML engine) is built directly into the base package and must **not** be passed as an optional module flag `-m qtdeclarative`.
- **Solution**:
  Install the Linux host compiler tools and the WebAssembly target separately:
  ```bash
  # 1. Host compiler tools (moc, rcc, qsb, qmlimportscanner)
  python3 -m aqt install-qt linux desktop 6.8.2 linux_gcc_64 --base https://download.qt.io -O $HOME/Qt

  # 2. WebAssembly target libraries
  python3 -m aqt install-qt all_os wasm 6.8.2 wasm_singlethread --base https://download.qt.io -O $HOME/Qt
  ```

---

### Issue 4: `Permission Denied` (Exit Code 126) on `qt-cmake`
- **Symptom**: `/home/runner/Qt/6.8.2/wasm_singlethread/bin/qt-cmake: Permission denied`.
- **Root Cause**: Archives extracted via `py7zr`/`aqtinstall` on Linux do not preserve the executable permission bit (`+x`) on binary files.
- **Solution**:
  Explicitly grant execution permissions to all Qt binaries before executing CMake:
  ```bash
  chmod -R +x $HOME/Qt/6.8.2/gcc_64/bin || true
  chmod -R +x $HOME/Qt/6.8.2/gcc_64/libexec || true
  chmod -R +x $HOME/Qt/6.8.2/wasm_singlethread/bin || true
  chmod -R +x $HOME/Qt/6.8.2/wasm_singlethread/libexec || true
  ```

---

### Issue 5: Missing Vercel Addressing Secrets
- **Symptom**: The runner has a valid token but doesn't know which Vercel project to deploy to.
- **Root Cause**:
  - `VERCEL_TOKEN` is the **Security Key** (Authorization).
  - `VERCEL_ORG_ID` (`team_...`) and `VERCEL_PROJECT_ID` (`prj_...`) are the **Destination Address**.
- **Solution**:
  Configure all 3 secrets under GitHub Repository Settings (`Settings > Secrets and variables > Actions > Repository secrets`):
  1. `VERCEL_TOKEN`: Generated at `vercel.com/account/tokens`
  2. `VERCEL_ORG_ID`: Found under Vercel Account / Team Settings
  3. `VERCEL_PROJECT_ID`: Found under Vercel Project (`pva-vpu-50-scada`) > Settings > General

---

### Issue 6: WebAssembly Security Headers & 60 FPS Rendering
- **Symptom**: Browser throws SharedArrayBuffer errors or fails to load `.wasm` files.
- **Root Cause**: Modern web browsers require explicit MIME types and Cross-Origin isolation headers for high-performance WebAssembly canvas rendering.
- **Solution**:
  Configure `vercel.json` with required HTTP headers:
  ```json
  {
    "version": 2,
    "cleanUrls": true,
    "headers": [
      {
        "source": "/(.*).wasm",
        "headers": [
          { "key": "Content-Type", "value": "application/wasm" },
          { "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }
        ]
      },
      {
        "source": "/(.*)",
        "headers": [
          { "key": "Cross-Origin-Opener-Policy", "value": "same-origin" },
          { "key": "Cross-Origin-Embedder-Policy", "value": "require-corp" }
        ]
      }
    ]
  }
  ```

### Issue 7: `QT_HOST_PATH` Cross-Compilation Requirement
- **Symptom**: `CMake Error: To use a cross-compiled Qt, please set the QT_HOST_PATH cache variable to the location of your host Qt installation.`
- **Root Cause**: When cross-compiling QML and C++ to WebAssembly, CMake requires the path to the native host tools (`moc`, `rcc`, `qsb`) on Linux (`gcc_64`).
- **Solution**:
  Pass `-DQT_HOST_PATH=$HOME/Qt/6.8.2/gcc_64` to `qt-cmake`:
  ```bash
  $HOME/Qt/6.8.2/wasm_singlethread/bin/qt-cmake -B build_wasm -S . -DCMAKE_BUILD_TYPE=Release -G Ninja -DQT_HOST_PATH=$HOME/Qt/6.8.2/gcc_64
  ```

### Issue 8: Missing `QuickTimeline` Component
- **Symptom**: `CMake Error at CMakeLists.txt: Failed to find required Qt component "QuickTimeline".`
- **Root Cause**: `QuickTimeline` and `ShaderTools` were listed under `REQUIRED COMPONENTS` in `CMakeLists.txt` but are optional animation modules in some Qt WebAssembly distributions.
- **Solution**:
  1. Change `CMakeLists.txt` to mark them as `OPTIONAL_COMPONENTS`:
     ```cmake
     find_package(Qt6 6.8 REQUIRED COMPONENTS Core Gui Widgets Qml Quick OPTIONAL_COMPONENTS QuickTimeline ShaderTools)
     ```
  2. Request `-m qtquicktimeline qtshadertools` during CI installation.

### Issue 9: CMake Target Name Collision (`add_library cannot create target`)
- **Symptom**: `add_library cannot create target "PVA_VPU50_SCADA" because another target with the same name already exists. The existing target is an executable created in source directory.`
- **Root Cause**: The root project was named `project(PVA_VPU50_SCADA)` which created an executable target named `PVA_VPU50_SCADA`. When the subdirectory `PVA_VPU50_SCADA` tried to create its static QML library module target, CMake failed due to duplicate target names.
- **Solution**:
  Name the root executable project `project(PVA_VPU50_SCADAApp LANGUAGES CXX)` in root `CMakeLists.txt`.

### Issue 12: Vercel Cloud Build Attempt (`bash scripts/vercel_build.sh exited with 127`)
- **Symptom**: `Running build in Washington, D.C., USA... Error: Command "bash scripts/vercel_build.sh" exited with 127`.
- **Root Cause**: An old `"buildCommand": "bash scripts/vercel_build.sh"` was present in `vercel.json`. When deploying the prebuilt `dist/` directory, Vercel detected the build command and attempted to re-run the non-existent build script on Vercel servers.
- **Solution**:
  Set `"buildCommand": null`, `"installCommand": null`, `"framework": null` in `vercel.json` so Vercel immediately recognizes the upload as pre-compiled static WebAssembly assets:
  ```json
  {
    "version": 2,
    "buildCommand": null,
    "installCommand": null,
    "framework": null,
    "cleanUrls": true,
    ...
  }
  ```

---

## 3. Slint (Rust) vs. Qt 6 (C++) WebAssembly Build Comparison

| Metric | Slint SCADA (Rust) | Qt 6 SCADA (C++ / QML) |
| :--- | :--- | :--- |
| **Compiler Dependency** | `rustup` + `wasm32-unknown-unknown` + `trunk` | Linux Desktop GCC + Qt 6 Wasm + Emscripten SDK + CMake + Ninja |
| **Download Size** | **~15 MB** (Very Lightweight) | **~2.5 GB** (Heavy Industrial C++ Engine) |
| **Build Time** | **~15–20 seconds** | **~3–4 minutes** (577 C++ & QML Targets) |
| **Can Build inside Vercel?** |  **Yes** (Fits inside Vercel 45s limit) | ❌ **No** (Exceeds Vercel 45s limit → Handled by GitHub Actions) |
| **Browser Performance** | **60 FPS WebAssembly** | **60 FPS WebAssembly** |

---

## 4. Complete, Production-Ready GitHub Actions Workflow

File location: [`.github/workflows/deploy_vercel.yml`](file:///C:/Users/Shekhar/Desktop/QT%20DESIGNER%20PROJECTS/PVA_VPU50_SCADA/.github/workflows/deploy_vercel.yml)
