#!/bin/bash
# This script is designed to increment the build number monotonically

cd "$SRCROOT/$PRODUCT_NAME"

# Parse the 'Config.xcconfig' file to retrieve the previous build number
previous_build_number=$(awk -F "=" '/BUILD_NUMBER/ {print $2}' Config.xcconfig | tr -d ' ')

# If the previous build number is empty or not a number, set it to 0
if ! [[ "$previous_build_number" =~ ^[0-9]+$ ]]; then
    previous_build_number=0
fi

# Increment the previous build number
new_build_number=$((previous_build_number + 1))

# Replace with the new build number
sed -i -e "/BUILD_NUMBER =/ s/= .*/= $new_build_number/" Config.xcconfig

# Remove the backup file created by 'sed' command.
rm -f Config.xcconfig-e
