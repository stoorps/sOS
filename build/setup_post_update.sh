#!/bin/bash
set -oue pipefail

cp /tmp/build/flatpaks.install.txt /tmp/build/filesystem/etc/post_update/flatpaks.install.txt
cp -r /tmp/build/filesystem/* /


chmod +x /etc/post_update/post_update.sh
chmod +x /etc/post_update/flatpaks.sh

# Add flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


systemctl enable post_update_script.service 