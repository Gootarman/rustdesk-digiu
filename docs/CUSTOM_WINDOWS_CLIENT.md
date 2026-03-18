# Build-time embedded server config for a normal Windows binary

If you do not want filename-based config (rename `*.exe`), you can embed server values at **build time**.
The resulting file can stay a regular name like `rustdesk.exe`.

## What to use

Set these environment variables **before build**:

- `RUSTDESK_EMBEDDED_HOST` (required)
- `RUSTDESK_EMBEDDED_KEY` (optional, but recommended)
- `RUSTDESK_EMBEDDED_RELAY` (optional)
- `RUSTDESK_EMBEDDED_API` (optional)

When embedded values are present, app startup forces these options:

- `custom-rendezvous-server`
- `key`
- `relay-server`
- `api-server`

## Your values

- Host: `46.161.48.167`
- Key: `Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8=`
- Relay: `46.161.48.167`

## Windows build example (PowerShell)

```powershell
$env:RUSTDESK_EMBEDDED_HOST = "46.161.48.167"
$env:RUSTDESK_EMBEDDED_KEY = "Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8="
$env:RUSTDESK_EMBEDDED_RELAY = "46.161.48.167"
# optional:
# $env:RUSTDESK_EMBEDDED_API = "https://your-api-host"

cargo build --release --target x86_64-pc-windows-msvc
```

Output binary remains a normal filename (for example):

```text
target\x86_64-pc-windows-msvc\release\rustdesk.exe
```

No rename step is required.

## Notes

- If you change server values, rebuild the binary.
- This removes easy filename tampering, but secrets in client binaries are still extractable by a determined attacker.
- For highest security, keep server-side ACL/device authorization enabled.
