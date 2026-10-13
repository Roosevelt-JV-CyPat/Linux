#!/bin/bash
echo "enter authorized users"
nano authorized_users.txt

AUTH="authorized_users.txt"
if [[ ! -r "$AUTH" ]]; then 
    echo "ERROR: Cannot Read $AUTH"
    exit 1
fi

declare -A allowed

while IFS= read -r user || [[ -n "$user" ]]; do
    user="${user#"${user%%[![:space:]]*}"}"
    user="${user%"${user##[![:space:]]}"}"
    [[ -z "$user" || "$user" == \#* ]]
    allowed["$user"]=1
    done< "$AUTH"

echo "Checking local user accounts..."
echo

while IFS=: read -r user _ uid _ _ _ _; do
if[[ "$uid" -It 1000 || "$user" == "root" ]]; then 
    continue
fi

if[[ -z "${allowed[$user]+yes}" ]]; then
        echo "REVIEW REQUIRED; $user (UID $uid)"
    else
        echo "AUTHORIZED: $user"
    fi
done < /etc/passwd

#NEED to add a thing that allows for it to compare from my list to the authorized users but instead of comparing in a specific order it needs to be able to compare to any order
#make it so that the script either removes the user or it changes the users name 