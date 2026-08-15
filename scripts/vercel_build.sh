#!/bin/bash
set -e

echo "======================================================================"
echo " PVA Systems VPU-50 SCADA - Automatic Vercel WebAssembly Build"
echo "======================================================================"

# If prebuilt dist/ folder is present in repo, use it immediately
if [ -d "dist" ] && [ -f "dist/index.html" ]; then
    echo "Found prebuilt static assets in dist/ directory. Deploying directly..."
    exit 0
fi

# 1. Setup isolated Python environment for build tools
echo "[1/5] Setting up build environment..."
python3 -m venv /tmp/venv
source /tmp/venv/bin/activate
pip install --upgrade pip
pip install aqtinstall cmake ninja

# 2. Install Qt 6.8 WebAssembly Toolchain
echo "[2/5] Fetching Qt 6.8.0 WebAssembly toolchain..."
python3 -m aqt install-qt linux desktop 6.8.0 wasm_singlethread -O /tmp/qt

# 3. Setup matching Emscripten SDK (3.1.56)
echo "[3/5] Configuring Emscripten SDK..."
if [ ! -d "/tmp/emsdk" ]; then
    git clone --depth 1 https://github.com/emscripten-core/emsdk.git /tmp/emsdk
fi
/tmp/emsdk/emsdk install 3.1.56
/tmp/emsdk/emsdk activate 3.1.56
source /tmp/emsdk/emsdk_env.sh

# 4. Configure & Compile QML SCADA Project with CMake & Ninja
echo "[4/5] Compiling PVA Systems VPU 50 SCADA to WebAssembly (.wasm)..."
export PATH="/tmp/qt/6.8.0/wasm_singlethread/bin:$PATH"

if command -v qt-cmake >/dev/null 2>&1; then
    qt-cmake -B build_wasm -S . -DCMAKE_BUILD_TYPE=Release -G Ninja
else
    /tmp/qt/6.8.0/wasm_singlethread/bin/qt-cmake -B build_wasm -S . -DCMAKE_BUILD_TYPE=Release -G Ninja
fi

cmake --build build_wasm --parallel $(nproc)

# 5. Export static site to dist/
echo "[5/5] Packaging static WebAssembly deployment in dist/..."
mkdir -p dist
if [ -d "build_wasm/App" ]; then
    cp -r build_wasm/App/* dist/
else
    cp -r build_wasm/* dist/
fi
cp vercel.json dist/ 2>/dev/null || true

echo "======================================================================"
echo " WebAssembly Build Succeeded! Vercel will now serve dist/ at Edge CDN."
echo "======================================================================"
