#!/bin/bash
set -ouex pipefail

# Zed Editor
echo "Installing zed..."
curl -Lo /tmp/zed.tar.gz \
    https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz
mkdir -p /usr/lib/zed.app/
tar -xvf /tmp/zed.tar.gz -C /usr/lib/zed.app/ --strip-components=1
chown 0:0 -R /usr/lib/zed.app
ln -s /usr/lib/zed.app/bin/zed /usr/bin/zed-cli
cp /usr/lib/zed.app/share/applications/zed.desktop /usr/share/applications/dev.zed.Zed.desktop
mkdir -p /usr/share/icons/hicolor/1024x1024/apps
cp {/usr/lib/zed.app,/usr}/share/icons/hicolor/512x512/apps/zed.png
cp {/usr/lib/zed.app,/usr}/share/icons/hicolor/1024x1024/apps/zed.png
sed -i "s@Exec=zed@Exec=/usr/lib/zed.app/libexec/zed-editor@g" /usr/share/applications/dev.zed.Zed.desktop


# Rust - Install in var to keep seperate from ostree
echo "Installing rust via rustup..."
mkdir /var/rust
chmod 777 /var/rust
CARGO_HOME=/var/rust RUSTUP_HOME=/var/rust bash -c 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable --profile default -y'
# Add to global path.
cp /tmp/build/etc/cargo.sh /etc/profile.d/cargo.sh


