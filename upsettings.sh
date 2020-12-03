#!/bin/bash

# FNAME="aabc"
# CONTENT=$(sed -e 's/\r//' -e's/\t/\\t/g' -e 's/"/\\"/g' "${FNAME}" | awk '{ printf($0 "\\n") }')
KEY=$(cat token)

# echo $CONTENT

# curl \
#   -X POST \
#   -d '{
#     "public":false,
#     "files":{
#       "addgist.txt":{
#       "content": "${CONTENT}"
#         }
#       }
#     }' \
#   -u MyUser:$KEY \
#   https://api.github.com/gists

FNAME=aabc
TOKEN=$(cat token)
# 1. Somehow sanitize the file content
#    Remove \r (from Windows end-of-lines),
#    Replace tabs by \t
#    Replace " by \"
#    Replace EOL by \n
CONTENT=$(sed -e 's/\r//' -e's/\t/\\t/g' -e 's/"/\\"/g' "${FNAME}" | awk '{ printf($0 "\\n") }')

# 2. Build the JSON request
read -r -d '' DESC <<EOF
{
  "description": "some description",
  "public": false,
  "files": {
    "${FNAME}": {
      "content": "${CONTENT}"
    }
  }
}
EOF

# 3. Use curl to send a POST request
curl -u MyUser:${TOKEN} -X POST -d "${DESC}" "https://api.github.com/gists"
