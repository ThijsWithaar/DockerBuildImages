[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/gxebs0dxfl4e70ro/branch/main?svg=true)](https://ci.appveyor.com/project/ThijsWithaar/dockerbuildimages/branch/main)
[![Gitub actions](https://github.com/ThijsWithaar/DockerBuildImages/actions/workflows/docker.yml/badge.svg)](https://github.com/ThijsWithaar/DockerBuildImages/actions)

## Introduction

A set of docker files to set up C++ build environments.
The appveyor.yml is used to generate the linux images, github actions for the windows build.

Under windows, [Vcpkg](https://vcpkg.io) is used to get 3rd party libraries.
The build result cache is located at `%VCPKG_CACHE%`, this can be used to reduce vcpkg build times in CI.
The vcpkg commit id is set in `%VCPKG_REF%`.

For linux, the default package manager is used.

Pre-installed tools: c++ compiler, git, cmake, doxygen, ImageMagick

Pre-installed libraries (with headers): boost, qt, catch2, fmt, eigen3

### Github Actions

It [should be possible](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idcontainer) to use these container directly in Gtihub actions, for example using the following `.gitub\workflows\cmake.yml`:
```
env:
  BUILD_TYPE: MinSizeRel

jobs:
  build-windows:
    runs-on: windows-2019
    container: thijswithaar/windows:2019

    steps:
    - uses: actions/checkout@v2

    - name: Vcpkg cache
      uses: actions/cache@v2
      with:
        path: ${{ env.VCPKG_CACHE }}
        key: ${{ runner.os }}-${{ env.VCPKG_REF }}-${{ hashFiles('**/vcpkg.json') }}

    - name: Build
      run: |
        cmake -G "Visual Studio 16 2019" -A x64 -T v142 -DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -S${{github.workspace}} -B${{github.workspace}}/build
        cmake cmake --build ${{github.workspace}}/build -DCMAKE_BUILD_TYPE=${{env.BUILD_TYPE}} --target package
        ctest -B${{github.workspace}}/build -C${{env.BUILD_TYPE}}

    - name: Store artifacts
      uses: actions/upload-artifact@v2
      with:
        name: Windows installer
        path: ${{github.workspace}}/build/*.exe

  build-linux:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        container: ["thijswithaar/debian:sid", "thijswithaar/ubuntu:devel", "thijswithaar/arch:latest"]

    container: ${{ matrix.container }}

    steps:
    - uses: actions/checkout@v2

    - name: Build
      run: |
        cmake -B${{github.workspace}}/build -DCMAKE_BUILD_TYPE=${{env.BUILD_TYPE}}
        cmake -B${{github.workspace}}/build -- package
        ctest -B${{github.workspace}}/build -C${{env.BUILD_TYPE}}

    - name: Store artifacts
      uses: actions/upload-artifact@v2
      with:
        name: ${{ matrix.container }} package
        path: |
          ${{github.workspace}}/build/*.deb
          ${{github.workspace}}/build/*.pkg.tar.*
```


### Cirrus CI

For [Cirrus CI](https://cirrus-ci.org/), a minimal `.cirrus.yml` would look like:
```
task:
  container:
    matrix:
      - image: thijswithaar/debian:sid
      - image: thijswithaar/ubuntu:devel
      - image: thijswithaar/fedora:rawhide
      - image: thijswithaar/arch:latest
      - image: thijswithaar/suse:tumbleweed
  compile_script:
    - cmake -Bbuild -S. -DCMAKE_BUILD_TYPE=MinSizeRel
    - cmake --build build --target package
    - mkdir -p deploy; cp build/*.deb build/*.rpm build/*.pkg.tar.* deploy/ | true
  test_script: cmake --build ./build -- test
  binaries_artifacts:
    path: "deploy/*"
```
