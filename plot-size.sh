#!/bin/bash

printf "\e[36mSubspace Plot Size Calculator v0.1\e[0m\n"
printf "\e[33mThis calculation should only be used if the intention is to utilize the entire drive for the plot.\e[0m\n\n"

# Function to calculate plot_size
calculate_plot_size() {
    printf "%s" "$1"
}

# Main script
if [[ -z $1 ]]; then
    printf "Enter the path of the disk (e.g., /dev/sdb): " >&2 # Print prompt on stderr to keep it on the same line
    read disk_path
else
    disk_path=$1
fi

if [[ ! -e $disk_path ]]; then
    printf "\nError: Invalid disk path. Please enter a valid path.\n"
    exit 1
fi

# Retrieve total disk space in GiB
total_size_blocks=$(df -B 1G --output=size "$disk_path" | tail -n 1 | tr -s ' ' | cut -d ' ' -f2)

if [[ ! $total_size_blocks =~ ^[0-9]+$ ]]; then
    printf "\nError: Failed to retrieve total disk space. Please check the disk path and try again.\n"
    exit 1
fi

total_size_gib=$((total_size_blocks))

# Determine file system type
filesystem=$(lsblk -no FSTYPE $disk_path)

if [[ $filesystem == "ext4" ]]; then
    printf "\nThe drive is formatted with the \e[97m\e[1mext4\e[0m file system.\n"
    total_size_gib=$((total_size_gib - 1))
elif [[ $filesystem == "xfs" ]]; then
    printf "\nThe drive is formatted with the \e[97m\e[1mXFS\e[0m file system.\n"
    total_size_gib=$(echo "scale=0; $total_size_gib * 0.9935 / 1" | bc)
else
    printf "Error: This calculation cannot be performed on the drive because it is not formatted with ext4 or XFS file system.\n"
    exit 1
fi

plot_size=$(calculate_plot_size $total_size_gib)
printf "The correct plot size for the drive should be \e[97m\e[1m%sGiB\e[0m\n\n" "$plot_size"
printf "\e[36mFor comments or to report an issue, contact vexr on Discord.\e[0m\n"