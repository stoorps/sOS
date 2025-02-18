#!/bin/bash
set -oue pipefail


# ======== Zed Editor =========
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


# ======== Rust =========
echo "Installing rust via rustup..."
mkdir /var/rust
chmod 777 /var/rust #IMPORTANT!!!! Temporary for installation

useradd -m cargoInstaller
su cargoInstaller -c 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | CARGO_HOME=/var/rust RUSTUP_HOME=/var/rust sh -s -- --default-toolchain stable --profile default -y'

chmod -R 750 /var/rust #IMPORTANT!!!! Undo temporary for installation.

userdel -r cargoInstaller
ls /home | cat 
# Add to global path.
cp /tmp/build/etc/cargo.sh /etc/profile.d/cargo.sh


# ======== VS Code =========
echo "installing vscode"

rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf5 -y install code


# ======== Starship =========
mkdir /var/starship
curl -sS https://starship.rs/install.sh | sh -s -- --force --bin-dir /var/starship
