# Build-time embedded server config (Windows, normal `rustdesk.exe`)

This guide shows how to build a **regular Windows binary** (no filename rename trick) with embedded server settings.

---

## 1) Install dependencies on Windows

### 1.1 Required tools

Install the following:

- **Git**
- **Rust toolchain** (rustup + cargo)
- **Visual Studio 2022 Build Tools** with C++ workload:
  - `MSVC v143`
  - `Windows 10/11 SDK`
  - `C++ CMake tools`
- **CMake**
- **Ninja**
- **vcpkg**
- **LLVM/Clang** (for `libclang.dll`, required by `bindgen`)

Example with `winget` (PowerShell as Administrator):

```powershell
winget install --id Git.Git -e
winget install --id Rustlang.Rustup -e
winget install --id Kitware.CMake -e
winget install --id Ninja-build.Ninja -e
winget install --id Microsoft.VisualStudio.2022.BuildTools -e
winget install --id LLVM.LLVM -e
```

> During Visual Studio Build Tools installation, ensure C++ build components are selected.

### 1.2 Install vcpkg libraries used by RustDesk

```powershell
git clone https://github.com/microsoft/vcpkg C:\vcpkg
C:\vcpkg\bootstrap-vcpkg.bat
$env:VCPKG_ROOT = "C:\vcpkg"
C:\vcpkg\vcpkg install libvpx:x64-windows-static libyuv:x64-windows-static opus:x64-windows-static aom:x64-windows-static
```

### 1.3 (Sciter desktop UI) Download `sciter.dll`

If you build desktop sciter client, place `sciter.dll` near resulting `rustdesk.exe`:

- https://raw.githubusercontent.com/c-smile/sciter-sdk/master/bin.win/x64/sciter.dll

---

## 2) Get source code correctly

```powershell
git clone <YOUR_FORK_OR_REPO_URL> rustdesk-digiu
cd rustdesk-digiu
git submodule update --init --recursive
```

Submodules are required (for example `libs/hbb_common`).

---

## 3) Configure build environment (IMPORTANT)

The error `Unable to find libclang` means `LIBCLANG_PATH` is not set correctly.

Use helper script from this repo:

```powershell
.\scripts\windows-build-env.ps1 -VcpkgRoot "C:\vcpkg" -LlvmRoot "C:\Program Files\LLVM"
```

It sets:

- `VCPKG_ROOT`
- `LIBCLANG_PATH`

If you prefer manual setup:

```powershell
$env:VCPKG_ROOT = "C:\vcpkg"
$env:LIBCLANG_PATH = "C:\Program Files\LLVM\bin"
```

---

## 4) Embed your server values at build time

Set variables before `cargo build`:

- `RUSTDESK_EMBEDDED_HOST` (required)
- `RUSTDESK_EMBEDDED_KEY` (optional, recommended)
- `RUSTDESK_EMBEDDED_RELAY` (optional)
- `RUSTDESK_EMBEDDED_API` (optional)

### Your values

- Host: `46.161.48.167`
- Key: `Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8=`
- Relay: `46.161.48.167`

---

## 5) Build command (PowerShell)

```powershell
$env:RUSTDESK_EMBEDDED_HOST = "46.161.48.167"
$env:RUSTDESK_EMBEDDED_KEY = "Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8="
$env:RUSTDESK_EMBEDDED_RELAY = "46.161.48.167"
# optional:
# $env:RUSTDESK_EMBEDDED_API = "https://your-api-host"

cargo build --release --target x86_64-pc-windows-msvc
```

Result:

```text
target\x86_64-pc-windows-msvc\release\rustdesk.exe
```

This is a normal binary name; no rename is needed.

---

## 6) Install / deploy

- Copy `rustdesk.exe` to endpoint.
- If using sciter desktop build, copy `sciter.dll` next to `rustdesk.exe`.
- Run installer/runtime as usual.

At startup, embedded values are applied to:

- `custom-rendezvous-server`
- `key`
- `relay-server`
- `api-server`

---

## 7) Troubleshooting

### Error: `Unable to find libclang`

- Install LLVM: `winget install --id LLVM.LLVM -e`
- Set: `$env:LIBCLANG_PATH="C:\Program Files\LLVM\bin"`
- Verify file exists: `Test-Path "C:\Program Files\LLVM\bin\libclang.dll"`

### Error: missing `hbb_common` / submodule files

Run:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
```

### Error: opus/vcpkg include/link issues

- Ensure `VCPKG_ROOT` points to your vcpkg path.
- Ensure `vcpkg install ...:x64-windows-static` was completed.

---

## 8) Security notes

- This is safer operationally than filename-based config.
- But secrets can still be extracted from client binaries by a determined reverse engineer.
- For production, enforce server-side ACL/device authorization policies.
