#!/bin/bash
echo -ne "enter URL: " && read target
#echo -ne "Enter your admin panel list file: " && read listfile

while read i
do
	echo -e " [ ] Finding ${target}/${i} ....\n "
	if [ $(curl -A "Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:51.0) Gecko/20100101 Firefox/51.0" $target/$i -I 2> /dev/null | grep "HTTP/1.1" | awk '{print $2}') -eq 200 ]
then
		echo -e " [x] ${target}/${i} found \n"
	fi
done < admin_links.txt
