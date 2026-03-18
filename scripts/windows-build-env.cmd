@echo off
setlocal

set "VCPKG_ROOT_ARG=%~1"
if "%VCPKG_ROOT_ARG%"=="" set "VCPKG_ROOT_ARG=C:\vcpkg"
set "LLVM_ROOT_ARG=%~2"
if "%LLVM_ROOT_ARG%"=="" set "LLVM_ROOT_ARG=C:\Program Files\LLVM"

if not exist "%VCPKG_ROOT_ARG%" (
  echo [ERROR] Vcpkg root not found: %VCPKG_ROOT_ARG%
  echo         Usage: windows-build-env.cmd [VCPKG_ROOT] [LLVM_ROOT]
  exit /b 1
)

set "CLANG_DLL=%LLVM_ROOT_ARG%\bin\libclang.dll"
if not exist "%CLANG_DLL%" set "CLANG_DLL=C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\x64\bin\libclang.dll"
if not exist "%CLANG_DLL%" (
  echo [ERROR] libclang.dll not found.
  echo         Install LLVM: winget install --id LLVM.LLVM -e
  exit /b 1
)

set "VCPKG_ROOT=%VCPKG_ROOT_ARG%"
for %%I in ("%CLANG_DLL%") do set "LIBCLANG_PATH=%%~dpI"

echo [OK] VCPKG_ROOT=%VCPKG_ROOT%
echo [OK] LIBCLANG_PATH=%LIBCLANG_PATH%
echo.
echo Now run in the same CMD session:
echo   cargo build --release --target x86_64-pc-windows-msvc

endlocal & set "VCPKG_ROOT=%VCPKG_ROOT%" & set "LIBCLANG_PATH=%LIBCLANG_PATH%"
