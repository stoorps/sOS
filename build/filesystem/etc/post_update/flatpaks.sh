#!/bin/bash
set -oue pipefail

# Check if the input file exists
# if [ -f "/etc/post_update/flatpaks.remove.txt" ]; then
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
#     done < "/etc/post_update/flatpaks.remove.txt"
# fi

# Check if the input file exists
if [ -f "/etc/post_update/flatpaks.install.txt" ]; then
    # Read each line from the file
    while IFS= read -r app_name; do
    # Remove leading/trailing whitespace from the app name
    app_name=$(echo "$app_name" | xargs)

    # Check if the app name is not empty
    if [ -n "$app_name" ]; then
        echo "Installing: $app_name"
          set +e  # Disable -e (errexit)
          flatpak install --system --noninteractive "$app_name"
          set -e  # Re-enable -e (errexit)
        

    fi
    done < "/etc/post_update/flatpaks.install.txt"
fi

exit 0