#!/bin/bash
set -ouex pipefail

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

exit 0