# Stage: build
FROM ghcr.io/ublue-os/cosmic-nvidia:41 AS build
LABEL maintainer='stoorps'
RUN mkdir -p /var/lib/alternatives

# Begin Module build - includes

# Begin Module enable-coprs - ostree-pkg
RUN dnf5 -y copr enable  che/nerd-fonts
# End Module enable-coprs - ostree-pkg


# Begin Module install-vscode-repo - shell
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null
# End Module install-vscode-repo - shell


# Begin Module install-packages - ostree-pkg
RUN dnf install -y  zsh gnome-themes-extra nerd-fonts code cmake gcc
# End Module install-packages - ostree-pkg


# Begin Module install-zed - shell
RUN curl -Lo /tmp/zed.tar.gz \ && https://zed.dev/api/releases/stable/latest/zed-linux-x86_64.tar.gz && mkdir -p /usr/lib/zed.app/ && tar -xvf /tmp/zed.tar.gz -C /usr/lib/zed.app/ --strip-components=1 && chown 0:0 -R /usr/lib/zed.app && ln -s /usr/lib/zed.app/bin/zed /usr/bin/zed-cli && cp /usr/lib/zed.app/share/applications/zed.desktop /usr/share/applications/dev.zed.Zed.desktop && mkdir -p /usr/share/icons/hicolor/1024x1024/apps && cp {/usr/lib/zed.app,/usr}/share/icons/hicolor/512x512/apps/zed.png && cp {/usr/lib/zed.app,/usr}/share/icons/hicolor/1024x1024/apps/zed.png && sed -i "s@Exec=zed@Exec=/usr/lib/zed.app/libexec/zed-editor@g" /usr/share/applications/dev.zed.Zed.desktop
# End Module install-zed - shell


# Begin Module fonts-install - shell
RUN curl -Lo /tmp/firamono.zip \ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraMono.zip && mkdir /usr/share/fonts/fira-mono-nerd-font && unzip /tmp/firamono.zip -d /usr/share/fonts/fira-mono-nerd-font && curl -Lo /tmp/adwaita.tar.xz \ https://download.gnome.org/sources/adwaita-fonts/48/adwaita-fonts-48.0.tar.xz && mkdir /usr/share/fonts/adwaita-fonts-48.0 && tar -xvf /tmp/adwaita.tar.xz  -C /usr/share/fonts/adwaita-fonts-48.0 --strip-components=1
# End Module fonts-install - shell


# Begin Module flathub-repo - ostree-pkg
RUN systemctl enable --system silverblue-packages-setup.service
# End Module flathub-repo - ostree-pkg


# Begin Module install-flatpaks - ostree-pkg
RUN systemctl enable --system silverblue-packages-setup.service
# End Module install-flatpaks - ostree-pkg


# Begin Module install-flatpaks - ostree-pkg
RUN systemctl enable --system silverblue-packages-setup.service
# End Module install-flatpaks - ostree-pkg


# Begin Module zsh-setup - shell
RUN mkdir /etc/rust && chmod 777 /etc/rust && useradd -m cargoInstaller && su cargoInstaller -c 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | CARGO_HOME=/etc/rust RUSTUP_HOME=/etc/rust sh -s -- --default-toolchain stable --profile default -y' && chmod -R 750 /etc/rust && userdel -r cargoInstaller
# End Module zsh-setup - shell


# Begin Module starship-install - shell
RUN mkdir /etc/starship && curl -sS https://starship.rs/install.sh | sh -s -- --force --bin-dir /etc/starship
# End Module starship-install - shell


# Begin Module rustup-install - shell
RUN mkdir /etc/rust && chmod 777 /etc/rust && useradd -m cargoInstaller && su cargoInstaller -c 'curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | CARGO_HOME=/etc/rust RUSTUP_HOME=/etc/rust sh -s -- --default-toolchain stable --profile default -y' && chmod -R 750 /etc/rust && userdel -r cargoInstaller
# End Module rustup-install - shell


# Begin Module vib-install - shell
RUN mkdir /etc/vib && curl -Lo /etc/vib/vib \ https://github.com/Vanilla-OS/Vib/releases/latest/download/vib && chmod +x /etc/vib/vib && curl -Lo /tmp/plugins.tar.xz \ https://github.com/Vanilla-OS/Vib/releases/latest/download/plugins.tar.xz && tar -xvf /tmp/plugins.tar.xz -C /etc/vib --strip-components=1
# End Module vib-install - shell

# End Module build - includes


# Begin Module commit - shell
RUN ostree container commit
# End Module commit - shell

