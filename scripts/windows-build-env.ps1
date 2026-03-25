param(
    [string]$VcpkgRoot = "C:\vcpkg",
    [string]$LlvmRoot = "C:\Program Files\LLVM"
)

$ErrorActionPreference = "Stop"

function Test-Command($name) {
    return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

if (-not (Test-Command git)) {
    Write-Host "[ERROR] git is not installed or not in PATH" -ForegroundColor Red
    exit 1
}
if (-not (Test-Command cargo)) {
    Write-Host "[ERROR] cargo is not installed or not in PATH" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $VcpkgRoot)) {
    Write-Host "[ERROR] Vcpkg root not found: $VcpkgRoot" -ForegroundColor Red
    Write-Host "        Install vcpkg and pass -VcpkgRoot <path>" -ForegroundColor Yellow
    exit 1
}

$clangDllCandidates = @(
    (Join-Path $LlvmRoot "bin\libclang.dll"),
    "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\x64\bin\libclang.dll"
)
$clangDll = $clangDllCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $clangDll) {
    Write-Host "[ERROR] libclang.dll not found." -ForegroundColor Red
    Write-Host "        Install LLVM (winget install LLVM.LLVM)" -ForegroundColor Yellow
    Write-Host "        or VS LLVM tools, then re-run this script." -ForegroundColor Yellow
    exit 1
}

$env:VCPKG_ROOT = $VcpkgRoot
$env:LIBCLANG_PATH = Split-Path -Parent $clangDll

Write-Host "[OK] VCPKG_ROOT=$env:VCPKG_ROOT" -ForegroundColor Green
Write-Host "[OK] LIBCLANG_PATH=$env:LIBCLANG_PATH" -ForegroundColor Green
Write-Host ""
Write-Host "Now you can run:" -ForegroundColor Cyan
Write-Host "  cargo build --release --target x86_64-pc-windows-msvc" -ForegroundColor Cyan
