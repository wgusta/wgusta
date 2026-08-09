#!/bin/sh
set -eu
user=ubuntu
home_dir="$(getent passwd "$user" | cut -d: -f6)"
[ -n "$home_dir" ]
install -d -m 700 -o "$user" -g "$user" "$home_dir/.ssh"
touch "$home_dir/.ssh/authorized_keys"
key='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILa4Kn+HXeCHCFyq6T5r1VhAVBMATgbt/6HvSOy6O6IY t3code-sihlly'
grep -qxF "$key" "$home_dir/.ssh/authorized_keys" || printf '%s\n' "$key" >> "$home_dir/.ssh/authorized_keys"
chown "$user:$user" "$home_dir/.ssh/authorized_keys"
chmod 600 "$home_dir/.ssh/authorized_keys"
