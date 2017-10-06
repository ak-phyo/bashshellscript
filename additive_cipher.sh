#!/bin/bash

declare -A word
declare -A num
word=([a]=0 [b]=1 [c]=2 [d]=3 [e]=4 [f]=5 [g]=6 [h]=7 [i]=8 [j]=9 [k]=10 [l]=11 [m]=12 [n]=13 [o]=14 [p]=15 [q]=16 [r]=17 [s]=18 [t]=19 [u]=20 [v]=21 [w]=22 [x]=23 [y]=24 [z]=25 )
num=([0]=a [1]=b [2]=c [3]=d [4]=e [5]=f [6]=g [7]=h [8]=i [9]=j [10]=k [11]=l [12]=m [13]=n [14]=o [15]=p [16]=q [17]=r [18]=s [19]=t [20]=u [21]=v [22]=w [23]=x [24]=y [25]=z )

encrypt(){
#C=(P+k)%26
echo -ne "\e[32m  enter plain text \e[0m" && read plain
count=$(echo -n $plain | wc -c)

echo -ne "\e[31m enter key \e[0m" && read key

for i in $(seq 1 $count)
do
	char=$(echo $plain | cut -c $i)
	if [ -z $char ]
	then
		echo " " >> /tmp/.cipher_logs.tmp
	else
		no=$[(${word[$char]}+$key)%26]
		echo ${num[$no]} >> /tmp/.cipher_logs.tmp
	fi
done

	cat /tmp/.cipher_logs.tmp | tr -d "\n" | tr 'a-z' 'A-Z' && echo 
	rm -f /tmp/.cipher_logs.tmp
}
decrypt(){
#P=(C-k)%26
echo -ne "\e[32m  enter cipher text \e[0m" && read cipher
count=$(echo -n $cipher | wc -c)

echo -ne "\e[31m enter key \e[0m" && read key

for i in $(seq 1 $count)
do
	char=$(echo $cipher | cut -c $i)
	if [ -z $char ]
	then
		echo " " >> /tmp/.cipher_logs.tmp
	else
	no=$[(${word[$char]}-$key)%26]
	if [ $no -lt 0 ]
	then
		neg_no=$[$no+26]
		echo ${num[$neg_no]} >> /tmp/.cipher_logs.tmp
	fi
	echo ${num[$no]} >> /tmp/.cipher_logs.tmp
	fi
done

	cat /tmp/.cipher_logs.tmp | tr -d "\n" | tr 'a-z' 'A-Z' && echo 
	rm -f /tmp/.cipher_logs.tmp
}

echo -ne "\e[31m What do you want to do (encrypt or decrypt):\e[0m " && read selection 
case $selection in 
	"encrypt" | "Encrypt" | "ENCRYPT") encrypt
	;;
	"decrypt" | "Decrypt" | "DECRYPT") decrypt
	;;
	*) echo "Wrong input , try again"
		sleep 2
		./$0
	;;
esac
