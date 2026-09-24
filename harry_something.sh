#DO NOT USE UNTIL I HAVE SHOWED YOU HOW TO  


#!/bin/bash
# Manage_Admin_Groups.sh
# Comprehensive Linux group management tool
# Must be run as root or with sudo privileges.

GROUP_FILE="/etc/group"

# ===== Function Definitions =====

list_groups_and_users() {
    echo "----------------------------------------"
    echo "Groups with assigned users:"
    echo "----------------------------------------"
    awk -F: '{ if ($4 != "") print $1 ": " $4; }' "$GROUP_FILE"
    echo "----------------------------------------"
}

view_users_in_group() {
    read -p "Enter the group name: " groupname
    echo "----------------------------------------"
    if grep -q "^$groupname:" "$GROUP_FILE"; then
        grep "^$groupname:" "$GROUP_FILE" | awk -F: '{print "Users: " ($4 != "" ? $4 : "(none)")}'
    else
        echo "Group '$groupname' not found."
    fi
    echo "----------------------------------------"
}

view_groups_for_user() {
    read -p "Enter the username: " username
    echo "----------------------------------------"
    if id "$username" &>/dev/null; then
        echo "Groups for user '$username':"
        id -nG "$username"
    else
        echo "User '$username' not found."
    fi
    echo "----------------------------------------"
}

mass_add_users_to_group() {
    read -p "Enter the group name to add users to: " groupname
    if ! getent group "$groupname" > /dev/null; then
        echo "Group '$groupname' does not exist."
        read -p "Would you like to create it? (y/n): " create_group
        if [[ "$create_group" =~ ^[Yy]$ ]]; then
            groupadd "$groupname" && echo "Group '$groupname' created."
        else
            echo "Operation cancelled."
            return
        fi
    fi

    read -p "Enter usernames separated by spaces: " -a userlist
    for user in "${userlist[@]}"; do
        if id "$user" &>/dev/null; then
            usermod -aG "$groupname" "$user"
            echo "Added $user to $groupname"
            sleep 0.2
        else
            echo "User $user does not exist — skipping."
        fi
    done
    echo "----------------------------------------"
}

# ==================== NEW USER CREATION FUNCTION =====================

create_new_user() {
    echo "----------------------------------------"
    read -p "Enter the NEW username: " newuser

    # Check if user already exists
    if id "$newuser" &>/dev/null; then
        echo "User '$newuser' already exists!"
        echo "----------------------------------------"
        return
    fi

    # Create the user
    echo "Creating user '$newuser'..."
    sudo useradd -m "$newuser"

    if [[ $? -ne 0 ]]; then
        echo "Failed to create user. Check permissions."
        echo "----------------------------------------"
        return
    fi

    echo "User '$newuser' created successfully."

    # Set password
    echo "----------------------------------------"
    echo "Set a password for $newuser:"
    sudo passwd "$newuser"

    # Ask to add to groups
    echo "----------------------------------------"
    read -p "Do you want to add this user to any groups? (y/n): " addgroups

    if [[ "$addgroups" =~ ^[Yy]$ ]]; then
        read -p "Enter groups (space-separated): " -a groups
        for group in "${groups[@]}"; do
            if getent group "$group" >/dev/null; then
                sudo usermod -aG "$group" "$newuser"
                echo "Added $newuser to group $group"
            else
                echo "Group '$group' does not exist — skipping."
            fi
        done
    fi

    echo "----------------------------------------"
    echo "User creation complete."
    echo "----------------------------------------"
}

# ==================== CUSTOM GROUP CHECK FUNCTION =====================

check_custom_group() {
    echo "----------------------------------------"
    read -p "Enter the group you want to check: " target_group

    # Check if group exists
    if ! getent group "$target_group" > /dev/null; then
        echo "Group '$target_group' does not exist."
        echo "----------------------------------------"
        return
    fi

    echo "----------------------------------------"
    echo "Enter the list of authorized users for group '$target_group'."
    echo "Example: alice bob charlie"
    read -p "Authorized users (space-separated): " -a AUTHORIZED_USERS

    echo "----------------------------------------"
    echo "Checking group '$target_group' for unauthorized users..."
    echo "----------------------------------------"

    # Get current members
    CURRENT_MEMBERS=$(getent group "$target_group" | awk -F: '{print $4}' | tr ',' ' ')
    echo "Current members: $CURRENT_MEMBERS"
    echo "----------------------------------------"

    # Loop through members
    for user in $CURRENT_MEMBERS; do
        if [[ ! " ${AUTHORIZED_USERS[@]} " =~ " ${user} " ]]; then
            echo "Unauthorized user detected: $user"
            read -p "Remove $user from group $target_group? (y/n): " confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                if gpasswd -d "$user" "$target_group" >/dev/null 2>&1; then
                    echo "Removed $user from $target_group"
                else
                    echo "Failed to remove $user (maybe permissions issue?)"
                fi
            else
                echo "Skipped $user"
            fi
            echo "----------------------------------------"
        fi
    done

    echo "Group check complete."
    echo "----------------------------------------"
}

# ================== END OF FUNCTIONS ===========================

# ===== Main Menu Loop =====
while true; do
    echo "========================================"
    echo "   Linux Group & User Management Tool"
    echo "========================================"
    echo "1) List all groups that have users"
    echo "2) View users in a specific group"
    echo "3) View all groups a specific user belongs to"
    echo "4) Mass add users to a group"
    echo "5) Create a new user"
    echo "6) Check & clean a custom group"
    echo "7) Exit"
    echo "----------------------------------------"
    read -p "Enter your choice [1-7]: " choice

    case "$choice" in
        1) list_groups_and_users ;;
        2) view_users_in_group ;;
        3) view_groups_for_user ;;
        4) mass_add_users_to_group ;;
        5) create_new_user ;;
        6) check_custom_group ;;
        7) echo "Exiting."; exit 0 ;;
        *) echo "Invalid choice. Please enter a valid number." ;;
    esac
done


