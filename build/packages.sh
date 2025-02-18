#!/bin/bash
set -ouex pipefail

dnf5 -y copr enable che/nerd-fonts

# VS Code Repo
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
# installs in packages.install.txt

# Uninstall packages
if [ -f "/tmp/build/packages.remove.txt" ]; then
  packages_remove=$(cat "/tmp/build/packages.remove.txt" | xargs)  # Read all packages into a single string
  if [ -n "$packages_remove" ]; then # Check if there are packages to remove
    echo "Uninstalling packages: $packages_remove"
    dnf uninstall -y $packages_remove
    if [ $? -eq 0 ]; then
      echo "Successfully uninstalled packages: $packages_remove"
    else
      echo "Error uninstalling packages: $packages_remove"
    fi
  fi
fi

# Install packages
if [ -f "/tmp/build/packages.install.txt" ]; then
  packages_install=$(cat "/tmp/build/packages.install.txt" | xargs) # Read all packages into a single string
  if [ -n "$packages_install" ]; then # Check if there are packages to install
    echo "Installing packages: $packages_install"
    dnf install -y $packages_install
    if [ $? -eq 0 ]; then
      echo "Successfully installed packages: $packages_install"
    else
      echo "Error installing packages: $packages_install"
    fi
  fi
fi



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
mkdir /etc/rust
chmod 777 /etc/rust #IMPORTANT!!!! Temporary for installation
useradd -m cargoInstaller
su cargoInstaller -c 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | CARGO_HOME=/etc/rust RUSTUP_HOME=/etc/rust sh -s -- --default-toolchain stable --profile default -y'
chmod -R 750 /etc/rust #IMPORTANT!!!! Undo temporary for installation.
userdel -r cargoInstaller


# ======== Starship =========
mkdir /etc/starship
curl -sS https://starship.rs/install.sh | sh -s -- --force --bin-dir /etc/starship


# ======== Vib =========
mkdir /etc/vib
curl -Lo /etc/vib/vib \
     https://github.com/Vanilla-OS/Vib/releases/latest/download/vib
chmod +x /etc/vib/vib

curl -Lo /tmp/plugins.tar.xz \
     https://github.com/Vanilla-OS/Vib/releases/latest/download/plugins.tar.xz
tar -xvf /tmp/plugins.tar.xz -C /etc/vib --strip-components=1



#====== Fonts =========
curl -Lo /tmp/firamono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraMono.zip

mkdir /usr/share/fonts/fira-mono-nerd-font
unzip /tmp/firamono.zip -d /usr/share/fonts/fira-mono-nerd-font


curl -Lo /tmp/adwaita.tar.xz \
  https://download.gnome.org/sources/adwaita-fonts/48/adwaita-fonts-48.0.tar.xz

mkdir /usr/share/fonts/adwaita-fonts-48.0
tar -xvf /tmp/adwaita.tar.xz  -C /usr/share/fonts/adwaita-fonts-48.0 --strip-components=1



exit 0