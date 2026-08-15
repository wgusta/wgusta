#!/bin/sh
set -eu
if [ "$(id -u)" -ne 0 ]; then
  exec sudo sh "$0"
fi
key='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILa4Kn+HXeCHCFyq6T5r1VhAVBMATgbt/6HvSOy6O6IY t3code-sihlly'
install_key() {
  user="$1"
  entry="$(getent passwd "$user" || true)"
  [ -n "$entry" ] || return 0
  home_dir="$(printf '%s\n' "$entry" | cut -d: -f6)"
  group="$(id -gn "$user")"
  install -d -m 700 -o "$user" -g "$group" "$home_dir/.ssh"
  touch "$home_dir/.ssh/authorized_keys"
  grep -qxF "$key" "$home_dir/.ssh/authorized_keys" || printf '%s\n' "$key" >> "$home_dir/.ssh/authorized_keys"
  chown "$user:$group" "$home_dir/.ssh/authorized_keys"
  chmod 600 "$home_dir/.ssh/authorized_keys"
}
install_key ubuntu
install_key root
printf 'KEY_READY\n'
