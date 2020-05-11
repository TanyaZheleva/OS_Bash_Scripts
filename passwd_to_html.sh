#!/bin/bash
#display first col
cat << _EOF_
<table>
  <tr>
    <th>Username</th>
    <th>group</th>
    <th>login shell</th>
    <th>GECKO</th>
  </tr>
_EOF_

#change IFS to : to read from /etc/passwd
OLD_IFS="$IFS"
IFS=":"

#add contents to table
while read uname gid gecko lshell; do
	group=$(egrep ":$gid:$" /etc/group | cut -d ":" -f 1)
cat << _EOF_
  <tr>
    <th>${uname}</th>
    <th>${group}</th>
    <th>${lshell}</th>
    <th>${gecko}</th>
  </tr>
_EOF_
done< <(cut -d ":" -f1,4,5,7 /etc/passwd)

#change back IFS
IFS="$OLD_IFS"

#dislay end of table
echo "</table>"
