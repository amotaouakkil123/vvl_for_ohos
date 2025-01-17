#!/bin/bash

export OHOS_SDK="path/to/Sdk/native"
export VVL_DIR="path/to/third_party_vulkan-validationlayers"
export BUILD_THREADS=8
export buildDir="${VVL_DIR}/build-ohos/intermediate"
export libDir="{$VVL_DIR}/build-ohos/libs"
export PATH="${OHOS_SDK}/build-tools/cmake/bin;${PATH}"

cd ${VVL_DIR}
python scripts/update_deps.py --dir ${buildDir} --known_good_dir scripts --no-build

cd ${VVL_DIR}/build-ohos/intermediate/SPIRV-Tools
git apply ../../../scripts/ohos-patches/SPIRV-Tools.patch
cd ${VVL_DIR}/build-ohos/intermediate/Vulkan-Headers
git apply ../../../scripts/ohos-patches/Vulkan-Headers.patch
cd ${VVL_DIR}/build-ohos/intermediate/Vulkan-Utility-Libraries
git apply ../../../scripts/ohos-patches/Vulkan-Utility-Libraries.patch

cd ${VVL_DIR}

cmake \
    -S . \
    -B ${buildDir} \
    -G Ninja \
    -D OHOS_STL=c++_static \
    -D CMAKE_INSTALL_LIBDIR=${libDir} \
    -D CMAKE_TOOLCHAIN_FILE=${OHOS_SDK}/build/cmake/ohos.toolchain.cmake \
    -D CMAKE_BUILD_TYPE=Release \
    -D VVL_CODEGEN=OFF \
    -D UPDATE_DEPS=ON \
    -D UPDATE_DEPS_DIR=${buildDir}
cmake \
    --build ${buildDir} \
    --parallel ${BUILD_THREADS}


if [ -d "${libDir}" ]; then
    mkdir "${libDir}"
fi
