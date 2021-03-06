#!/bin/bash

display_help() {
    echo "Usage: $0 USERNAME PASSWORD" >&2
    exit 1
}

if [ "$#" -ne 2 ];then
  display_help
fi 

username=$1
password=$2
temp_json=$(mktemp -t chef)
enc_pass=$(openssl passwd -1 "$2")

cat <<EOF > $temp_json
{
  "id": "$username",
  "password": "$enc_pass",
  "shell": "\/bin\/bash",
  "comment": "Test User"
}
EOF

knife data bag from file users $temp_json
rm $temp_json 
