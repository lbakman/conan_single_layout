#!/bin/bash

set -e
set -x

rm -rf LibA/cmake-build-release
rm -rf MyExe/cmake-build-release

conan editable add LibA/ LibA/0.1@user/channel

pushd LibA
conan install .
pushd cmake-build-release
cmake .. -DCMAKE_BUILD_TYPE=Release # -DCMAKE_TOOLCHAIN_FILE=conan/conan_toolchain.cmake
cmake --build .
popd
popd

mkdir MyExe/cmake-build-release
pushd MyExe/cmake-build-release
conan install ..
cmake .. -DCMAKE_BUILD_TYPE=Release # -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
cmake --build .
./myexe
popd

conan editable remove LibA/0.1@user/channel

