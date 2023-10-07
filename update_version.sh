#!/bin/bash

# Function to update the Android Gradle file
update_gradle_file() {
    local versionCode="$1"
    local versionName="$2"
    sed -i "s/versionCode [0-9]\+/versionCode $versionCode/" build.gradle
    sed -i "s/versionName \".*\"/versionName \"$versionName\"/" build.gradle
}

# Get the versionCode and versionName from command-line arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <versionCode> <versionName>"
    exit 1
fi

versionCode="$1"
versionName="$2"

# Fetch the latest changes from the main branch
git checkout main
git pull

# Create a new branch
new_branch_name="update_version_${versionCode}_${versionName}"
git checkout -b "$new_branch_name"

# Update the Android Gradle file with new versionCode and versionName
update_gradle_file "$versionCode" "$versionName"

# Commit the changes
git add build.gradle
git commit -m "Update versionCode to $versionCode and versionName to $versionName"

# Merge the changes back to the main branch
git checkout main
git merge "$new_branch_name"

# Delete the temporary branch
git branch -d "$new_branch_name"

# Return to the main branch
git checkout main

echo "VersionCode and VersionName updated and merged to main."
