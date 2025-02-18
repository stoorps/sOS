#!/bin/bash
set -oue pipefail

# Add flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# Check if the input file exists
# if [ -f "/tmp/build/flatpaks.remove.txt" ]; then
#     # Read each line from the file
#     while IFS= read -r app_name; do
#     # Remove leading/trailing whitespace from the app name
#     app_name=$(echo "$app_name" | xargs)

#     # Check if the app name is not empty
#     if [ -n "$app_name" ]; then
#         echo "Uninstalling: $app_name"
#         flatpak uninstall $app_name -y --delete-data
#         if [ $? -eq 0 ]; then
#             echo "Successfully uninstalled: $app_name"
#         else
#             echo "Error uninstalling: $app_name"
#         fi

#     fi
#     done < "/tmp/build/flatpaks.remove.txt"
# fi

# Check if the input file exists
if [ -f "/tmp/build/flatpaks.install.txt" ]; then
    # Read each line from the file
    while IFS= read -r app_name; do
    # Remove leading/trailing whitespace from the app name
    app_name=$(echo "$app_name" | xargs)

    # Check if the app name is not empty
    if [ -n "$app_name" ]; then
        echo "Installing: $app_name"
         flatpak install $app_name -y
        if [ $? -eq 0 ]; then
            echo "Successfully installed: $app_name"
        else
            echo "Error installing: $app_name"
        fi

    fi
    done < "/tmp/build/flatpaks.install.txt"
fi

exit 0