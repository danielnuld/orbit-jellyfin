#!/bin/bash
# usage (from Windows): wsl bash /mnt/c/Users/dgsc/Documents/orbit-jellyfin/build.sh
export PS2DEV=/usr/local/ps2dev PS2SDK=/usr/local/ps2dev/ps2sdk
export PATH=$PATH:$PS2DEV/bin:$PS2DEV/ee/bin:$PS2DEV/iop/bin:$PS2SDK/bin
cd "$(dirname "$0")" && make "$@"
