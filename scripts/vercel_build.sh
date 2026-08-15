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

# 1. Install lightweight Qt installer (aqtinstall)
echo "Setting up Python aqtinstall..."
pip install aqtinstall

# 2. Install Qt 6.8 WebAssembly Toolchain
echo "Fetching Qt 6.8.0 WebAssembly..."
python3 -m aqt install-qt linux desktop 6.8.0 wasm_singlethread -O /tmp/qt

# 3. Setup matching Emscripten SDK (3.1.56)
echo "Configuring Emscripten SDK..."
if [ ! -d "/tmp/emsdk" ]; then
    git clone --depth 1 https://github.com/emscripten-core/emsdk.git /tmp/emsdk
fi
/tmp/emsdk/emsdk install 3.1.56
/tmp/emsdk/emsdk activate 3.1.56
source /tmp/emsdk/emsdk_env.sh

# 4. Configure & Compile QML SCADA Project with CMake
echo "Compiling PVA Systems VPU 50 SCADA to WebAssembly (.wasm)..."
export PATH="/tmp/qt/6.8.0/wasm_singlethread/bin:$PATH"
qt-cmake -B build_wasm -S . -DCMAKE_BUILD_TYPE=Release
cmake --build build_wasm --parallel $(nproc)

# 5. Export static site to dist/
mkdir -p dist
cp -r build_wasm/App/* dist/ 2>/dev/null || cp -r build_wasm/* dist/ 2>/dev/null
cp vercel.json dist/ 2>/dev/null || true

echo "======================================================================"
echo " WebAssembly Build Succeeded! Vercel will now serve dist/ at Edge CDN."
echo "======================================================================"
