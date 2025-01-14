Clear-Host

$OHOS_SDK = "path\to\OpenHarmony\Sdk\12\native"
$VVL_DIR = "path\to\Vulkan-ValidationLayers"
$BUILD_THREADS = 8

#-----------------------------------------------------------------------------------------------------------------------

$buildDir = "${VVL_DIR}/build-ohos/intermediate"
$libDir = "${VVL_DIR}/build-ohos/libs"

# Using CMake from OHOS SDK...

$env:Path = "${OHOS_SDK}/build-tools/cmake/bin;" + $env:Path

# Making project files...

Set-Location "${VVL_DIR}"

cmake                                                                           `
    -S .                                                                        `
    -B "${buildDir}"                                                            `
    -G Ninja                                                                    `
    -D OHOS_STL=c++_static                                                      `
    -D CMAKE_INSTALL_LIBDIR="${libDir}"                                         `
    -D CMAKE_TOOLCHAIN_FILE="${OHOS_SDK}/build/cmake/ohos.toolchain.cmake"      `
    -D CMAKE_BUILD_TYPE=Release                                                 `
    -D VVL_CODEGEN=ON                                                           `
    -D UPDATE_DEPS=ON                                                           `
    -D UPDATE_DEPS_DIR="${buildDir}"

# Codegen boilerplate code from Vulkan registry (vk.xml from Vulkan-Headers)...

cmake                                                                           `
    --build "${buildDir}"                                                       `
    --target vvl_codegen

# Building projects...

cmake                                                                           `
    --build "${buildDir}"                                                       `
    --parallel "${BUILD_THREADS}"

# Stripping binaries and copying them into final directory...

if (!(Test-Path -Path "${libDir}")) {
    New-Item                                                                    `
        -Path "${libDir}"                                                       `
        -ItemType "Directory"
}

Set-Location "${OHOS_SDK}/llvm/bin"

./llvm-strip                                                                    `
    -d                                                                          `
    -s                                                                          `
    -o "${libDir}/libVkLayer_khronos_validation.so"                             `
    "${buildDir}/layers/libVkLayer_khronos_validation.so"

Write-Host "Done."
