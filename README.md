# ORBIT Jellyfin

Jellyfin player for the PlayStation 2, styled like the ORBIT launcher (to be published).
Jellyfin transcodes to MPEG-2 + MP2 at SD resolution; the PS2 decodes the video on the IPU (libmpeg) and the audio
with libmad + audsrv.

## Build

```
wsl bash build.sh          # jfplay.elf (ps2dev v2.0.0)
wsl bash build.sh test     # host selftests; JF_CHECK="http://server:8096 user password" adds the live checks
```

## Install

Copy `jfplay.elf` and `title.cfg` to `mass0:/APPS/Jellyfin/`: the launcher lists it under APPS. It also runs on its
own from uLaunchELF.

Settings are read from the launcher's `mass0:/orbit/config.ini`:

```
[red]
ip = dhcp

[jellyfin]
servidor = http://<server IP>:8096    ; an IP: the PS2 does not resolve .local names
usuario = <user>
clave = <password>
subtitulos = spa                      ; languages in order (spa, eng); no = off
```

The log goes to `mass0:/jfplay.txt`; an answer from the server that does not parse is saved to `mass0:/jf_bad.txt`.

## Controls

| Button | Browse | Playing |
|---|---|---|
| X | play / episodes | pause, resume |
| △ | continue where you left off | show the bar |
| □ | | next subtitle track, then off |
| L1 / R1 | library | -10 s / +30 s (also left / right) |
| O | close the episode panel | back to the list |
| SELECT | | debug numbers |

## Code shared with the launcher

These files are copies from the ORBIT launcher sources. A fix in one repo has to be copied to the other by hand:
`gfx.c/h`, `ui_data.c/h` (the launcher's `tools/ui_art.py`), `ini.c/h`, `net.c/h`, `iop.c/h`, `cover.c/h`, `build.sh`.

The fonts have diverged: `tools/font.py` here bakes all Latin-1 letters plus œ into the ui font (subtitles in French,
Portuguese, German...), and `gfx.c` draws the ASCII base letter when a font lacks one. Regenerate with
`python3 tools/font.py` (needs Pillow).

## Notes

- `docs/phase15-results.md`: what was measured in PCSX2 and on the console, and the bugs found.
- `tools/pcsx2/`: headless PCSX2 harness (Xvfb, virtual USB image, pad input, capture).
- On the console, some full-size Ethernet frames arrive with their last 42 bytes zeroed (ps2sdk netman's D-cache
  write-back); `net.c` lowers the MTU to 1400 so the server never sends frames that long.

## How it was made

Developed with [Claude Code](https://claude.com/claude-code) (Anthropic) as the coding assistant: it wrote and debugged
most of the code, drove PCSX2 for testing and read the logs from the real console to track down the hardware-only bugs.
Claude Code plugins and tools used along the way:

- **OpenSpec**: each phase planned as a change with proposal, design, specs and tasks (`openspec/`)
- **Ponytail**: a "do the simplest thing that works" mode, to keep the code small
- **CodeGraph** (MCP server): a code index for finding symbols, callers and impact

## License

GPL-3.0 (see `LICENSE`). `jfplay.elf` statically links wolfSSL 5.8.2 (GPL-3.0-or-later) and libmad (GPL-2.0-or-later)
from the ps2sdk ports, and ps2sdk itself (AFL-2.0). The fonts in `tools/fonts` are under the SIL Open Font License 1.1.
