# **CyberPatriots 18 Round 1 Answers and Vulnerabilities LINUX** 

Includes how-tos and commands to use to resolve issues and gain points 

## **User Accounts and Administrative Privileges** 

- ➢ Removed unauthorized user ttanner 

- ➢ Removed unauthorized user cdennis 

- ➢ User kbennett is not an administrator 

- ➢ Created user account mross 

List usernames using: “cut -d: -f1 /etc/passwd” Show regular accounts & UIDs: “awk -F: '$3 >= 1000 && $3 < 65534 {print $1, $3}' /etc/passwd” Check who has sudo privileges: “getent group sudo” Inspect a specific account: “id username” Remove an unauthorized account: “sudo deluser username” Remove administrator privileges: “sudo deluser username sudo” Create user account: “sudo adduser username” Lock account: “sudo passwd -l username” 

## **Password Requirements** 

- ➢ User mross must change password at next login 

- ➢ A default minimum password age is set 

View password aging information: “sudo chage -l username” 

Set a minimum password age of 1 day: “sudo chage -m 1 username” Require password change @ next login: “sudo chage -d 0 username” 

## **Firewall** 

➢ Uncomplicated Firewall (UFW) protection has been enabled 

Check firewall status: “sudo ufw status verbose” Enable the firewall: “sudo ufw enable” List configured rules: “sudo ufw status numbered” 

Show available application profiles: “sudo ufw app list” 

## **Disabling unnecessary services** 

- ➢ Apache2 service has been disabled or removed 

Check app’s status: “systemctl status application_name” Check if enabled at startup: “systemctl is-enabled application_name” 

If prohibited, to prevent it from starting automatically: “sudo systemctl disable --now application_name” 

## **System Updates and Automatic Security Updates** 

- ➢ The system refreshes the list of updates automatically 

- ➢ Install updates from important security updates 

Refresh available package lists: “sudo apt update” Upgrade installed packages: “sudo apt upgrade” Check for automatic update service: “systemctl status unattended-upgrades” 

Check if automatic updates are enabled: “systemctl is-enabled unattended-upgrades” 

## **Installed Software** 

- ➢ Chromium has been updated 

- ➢ OpenSSH has been updated 

- ➢ Prohibited MP3 files are removed 

- ➢ Prohibited software aisleriot removed 

- ➢ Prohibited software ophcrack removed 

Search installed packages: “dpkg -l | grep -Ei ‘chromium|openssh|aisleriot|ophcrack’” 

Check whether a package is installed: “dpkg -s package_name” 

## **SSH Root Login** 

- ➢ SSH root login has been disabled 

Check the effective root-login setting: “sudo sshd -T | grep permitrootlogin” 

Inspect the SSH configuration: “sudo nano /etc/ssh/sshd_config” 

**Look for PermitRootLogin no** 

After the change, validate the SSH configuration before reloading the service: “sudo sshd -t” 

