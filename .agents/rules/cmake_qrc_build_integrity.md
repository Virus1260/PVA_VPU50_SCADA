# CMake (qds.cmake) & Qt Resource (PVA_VPU50_SCADA.qrc) Synchronization Rule

## Mandatory Protocol for Every Code Change
Whenever ANY file is created, moved, renamed, deleted, or updated in the project:

1. **Verify `qds.cmake` and `PVA_VPU50_SCADA.qrc`**:
   - Both files define the source tree and assets packaged for WebAssembly (Emscripten) and desktop builds.
   - Every file declared in `qds.cmake` (under `qt6_add_resources`) and `PVA_VPU50_SCADA.qrc` MUST physically exist in Git-tracked project directories.

2. **Strict Prohibition of Ephemeral/Scratch Files**:
   - **NEVER** include paths containing `scratch/`, `tmp/`, `.temp/`, `output_frames/`, or uncommitted local experiment files in `qds.cmake`, `PVA_VPU50_SCADA.qrc`, or `CMakeLists.txt`.
   - Any reference to untracked scratch files will cause CMake on GitHub Actions (`deploy_vercel.yml`) to terminate with a fatal error (`Cannot find source file`).

3. **Checklist for New/Modified QML or Asset Files**:
   - When adding a new `.qml`, `.ui.qml`, `.json`, `.svg`, `.png`, or `.conf` file:
     - Register the relative path in `PVA_VPU50_SCADA.qrc` under `<qresource prefix="/">`.
     - Register the relative path in `qds.cmake` under `qt6_add_resources`.
     - Confirm the file is committed to Git.

4. **Automated Verification Before Completing Any Task**:
   - Check that all files listed in `qds.cmake` and `PVA_VPU50_SCADA.qrc` exist on disk.
   - Run `python -m unittest discover tests` to ensure all tests pass.
