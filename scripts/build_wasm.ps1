# ==============================================================================
# PVA Systems VPU 50 SCADA - Qt WebAssembly Build Script
# ==============================================================================

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host " Building PVA Systems VPU-50 SCADA for WebAssembly (Vercel Ready)" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan

$BUILD_DIR = "build_wasm"
$DIST_DIR = "dist"

# Check if emcmake is available
if (-not (Get-Command "emcmake" -ErrorAction SilentlyContinue)) {
    Write-Warning "Emscripten SDK (emcmake) was not detected in PATH."
    Write-Host "Please activate emsdk environment first (e.g. emsdk_env.bat) or install Qt 6 WebAssembly." -ForegroundColor Yellow
}

# Configure CMake with Qt WebAssembly
Write-Host "`n[1/3] Configuring WebAssembly Project with CMake..." -ForegroundColor Green
if (Get-Command "qt-cmake" -ErrorAction SilentlyContinue) {
    qt-cmake -B $BUILD_DIR -S . -DCMAKE_BUILD_TYPE=Release
} else {
    cmake -B $BUILD_DIR -S . -DCMAKE_BUILD_TYPE=Release
}

# Build WebAssembly artifacts
Write-Host "`n[2/3] Compiling QML and C++ to WebAssembly (.wasm)..." -ForegroundColor Green
cmake --build $BUILD_DIR --config Release --parallel

# Prepare distribution folder for Vercel
Write-Host "`n[3/3] Preparing static output in $DIST_DIR/ folder..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path $DIST_DIR | Out-Null
Copy-Item "$BUILD_DIR\App\*" -Destination $DIST_DIR -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "vercel.json" -Destination $DIST_DIR -Force

Write-Host "`n======================================================================" -ForegroundColor Cyan
Write-Host " Build Complete! Ready for Vercel Deployment:" -ForegroundColor Green
Write-Host " Run: npx vercel deploy --prod $DIST_DIR" -ForegroundColor Yellow
Write-Host "======================================================================" -ForegroundColor Cyan
