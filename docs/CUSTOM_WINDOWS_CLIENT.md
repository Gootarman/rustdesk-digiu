# Custom Windows client (.exe) with preconfigured ID/Relay server

This repository supports **auto-configuration from executable filename**.
On startup/install, the app parses `host=`, `key=`, `relay=` from the `.exe` name.

## Where to put your server data

You do **not** edit source code for this.
You put your values **inside the executable filename**:

```text
rustdesk-host=<HOST>,key=<KEY>,relay=<RELAY>.exe
```

For your case:

```text
rustdesk-host=46.161.48.167,key=Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8=,relay=46.161.48.167.exe
```

## Exact Windows steps (no coding)

1. Build/download your `rustdesk.exe`.
2. Put `rustdesk.exe` in any folder, for example `C:\build\`.
3. Open PowerShell in that folder.
4. Run:

```powershell
Rename-Item .\rustdesk.exe "rustdesk-host=46.161.48.167,key=Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8=,relay=46.161.48.167.exe"
```

5. Distribute/run this renamed `.exe` on client PCs.
6. During run/install, RustDesk reads values from the filename and applies:
   - `custom-rendezvous-server = 46.161.48.167`
   - `key = Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8=`
   - `relay-server = 46.161.48.167`

## If rename did not help

Most common reason: RustDesk was installed earlier and old settings are already saved.

Use one of these fixes:

1. **Clean reinstall** (recommended): uninstall RustDesk, install again from renamed `.exe`.
2. **Force apply config on installed client (Admin CMD/PowerShell):**

```powershell
"C:\Program Files\RustDesk\rustdesk.exe" --config "rustdesk-host=46.161.48.167,key=Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8=,relay=46.161.48.167.exe"
```

After that, restart RustDesk service/app.

## Optional: use the helper binary in this repo

If you want to generate the name from parameters instead of typing manually:

```bash
cargo run --release --bin naming -- \
  "Jdp+UM06CmQdA5MxgoUNadJFqjYMtLw48FFccZnTyJ8=" \
  "46.161.48.167" \
  "" \
  "46.161.48.167"
```

The command prints a custom `.exe` filename; rename your built client to that name.

## Notes

- Keep commas exactly as shown.
- `relay=` may be the same as `host=`.
- If host/key changes, rebuild/rename a new `.exe`.
