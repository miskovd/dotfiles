#!/usr/bin/env bash
set -euo pipefail

MOUNT_DIR="$HOME/iPhone"
LOGFILE="$HOME/.local/share/iphone-mount.log"
PACKAGES=(ifuse libimobiledevice usbmuxd)

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"
}

install_pkgs() {
  log "Installing required packages..."
  sudo pacman -S --needed "${PACKAGES[@]}"
}

uninstall_pkgs() {
  log "Removing ifuse and usbmuxd (keeping libimobiledevice for KDE)..."
  sudo pacman -Rs ifuse usbmuxd || true
}

mount_iphone() {
  mkdir -p "$MOUNT_DIR"
  log "Mounting iPhone at $MOUNT_DIR..."
  ifuse "$MOUNT_DIR"
  log "Done! Open $MOUNT_DIR with your file manager."
}

unmount_iphone() {
  if mountpoint -q "$MOUNT_DIR"; then
    log "Unmounting $MOUNT_DIR..."
    fusermount3 -u "$MOUNT_DIR"
    log "Done!"
  else
    log "iPhone is not mounted."
  fi
}

debug_info() {
  log "Running diagnostics..."
  ideviceinfo | tee -a "$LOGFILE" || log "No iPhone detected."
}

show_help() {
  cat <<EOF
Usage: $(basename "$0") [command]

Commands:
  install     Install required packages (ifuse, libimobiledevice, usbmuxd)
  uninstall   Remove ifuse and usbmuxd (keep libimobiledevice)
  mount       Mount iPhone to ~/iPhone (default if no command is given)
  unmount     Unmount iPhone
  debug       Show iPhone diagnostic info
  log         Show log file ($LOGFILE)
  help        Show this help
EOF
}

show_log() {
  less "$LOGFILE"
}

cmd="${1:-mount}"
case "$cmd" in
install) install_pkgs ;;
uninstall) uninstall_pkgs ;;
mount) mount_iphone ;;
unmount) unmount_iphone ;;
debug) debug_info ;;
log) show_log ;;
help) show_help ;;
*)
  log "Unknown command: $cmd"
  show_help
  exit 1
  ;;
esac
