# CMake, QRC & QML Build Integrity Rules

## Mandatory Protocol for Every Single Code Change
Whenever ANY file is created, modified, moved, renamed, or deleted in the project, the agent MUST strictly enforce these 5 invariant gates:

---

### 1. Zero Duplicate Files Rule (Prevents C++ `redefinition of 'unit'` error)
- Every file in `PVA_VPU50_SCADAContent/CMakeLists.txt` (under `QML_FILES` and `RESOURCES`), `PVA_VPU50_SCADA.qrc`, and `qds.cmake` must appear **exactly once**.
- Duplicate entries cause Qt 6's QML compiler (`qmlcachegen`) to generate duplicate C++ bytecode structs during WebAssembly compilation, resulting in fatal build failure (`error: redefinition of 'unit'`).

---

### 2. Zero Ephemeral / Scratch Files Rule (Prevents CMake fatal missing file error)
- **NEVER** include paths containing `scratch/`, `tmp/`, `.temp/`, `output_frames/`, or uncommitted local experiment files in:
  * `PVA_VPU50_SCADAContent/CMakeLists.txt`
  * `PVA_VPU50_SCADA.qrc`
  * `qds.cmake`
- Every declared file MUST physically exist in Git-tracked directories.

---

### 3. Strict Qt Design Studio Declarative Rule (Prevents Error M222)
- In `.ui.qml` files, **arbitrary functions and constructor calls** (e.g., `String(...)`, `Math.random()`, or inline JS functions) are **strictly forbidden**.
- In `.ui.qml`, use pure declarative QML expressions (e.g., `(currentStepIndex + 1) + ""` for string coercion).
- All imperative logic, timers, and signal handling MUST live in corresponding `.qml` logic files.

---

### 4. No Alias-of-Alias Chaining (Prevents `Invalid alias target location`)
- Aliases in `.ui.qml` files must point directly to a local item `id` or direct property within the component, never chained through another component's alias.

---

### 5. Mandatory Verification Execution
- Before concluding any response, the agent MUST run:
  ```bash
  python -m unittest discover tests
  ```
- This test suite automatically scans `CMakeLists.txt`, `PVA_VPU50_SCADA.qrc`, and `qds.cmake` for duplicates, scratch paths, and missing files.
