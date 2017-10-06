#!/bin/bash
PS3=$(echo -e "\e[36mchoose 1 or 2:\e[0m")

function ip_obfus {
IFS="."
echo -ne "Enter ip address: " && read ip

read -r a b c d <<< "$ip"
ip_ob=$[a*256**3+b*256**2+c*256+d]

echo -e "\e[31mYour IP address decimal value is :\e[0m $ip_ob"
echo -e "\e[32mYour IP address hexadecimal value is :\e[0m $(echo obase=16\;ibase=10\;$ip_ob | bc)"
echo -e "\e[33mYour IP address binary value is :\e[0m $(echo obase=2\;ibase=10\;$ip_ob | bc)"
echo -e "\e[34mYour IP address octal value is :\e[0m $(echo obase=8\;ibase=10\;$ip_ob | bc)"
}

function ip_input {
echo 
echo -ne "Enter Your obfuscated IP address:" && read ip
}

function ip_calc {
IFS=" "
read -r a b c d <<< $(echo "obase=256;$ip_ob" | bc)
a=$(echo $a | sed 's/^0\{,2\}//')
b=$(echo $b | sed 's/^0\{,2\}//')
c=$(echo $c | sed 's/^0\{,2\}//')
d=$(echo $d | sed 's/^0\{,2\}//')
echo -e "\e[31m Your IP address is $a.$b.$c.$d\e[0m"

}
function ip_deobfus {
PS3=$(echo -e "\e[36mchoose 1,2,3 or 4:\e[0m")	
	echo 
	select enter in "binary" "hexadecimal" "decimal" "octal"
	do
		case $enter in 
		"binary") ip_input
					ip_ob=$(echo obase=10\;ibase=2\;$ip | bc)
					ip_calc
					exit
		;;
		"hexadecimal") ip_input
						ip_ob=$(echo obase=10\;ibase=16\;$ip | bc)
						ip_calc
						exit
		;;
		"decimal") ip_input
						ip_ob=$ip
						ip_calc
						exit
		;;
		"octal") ip_input 
						ip_ob=$(echo obase=10\;ibase=8\;$ip | bc)
						ip_calc
						exit
		;;
		esac
	done
}
select enter in "IP obfuscation" "IP deobfuscation"
do
	case $enter in
	"IP obfuscation") ip_obfus
						exit
	;;
	"IP deobfuscation") ip_deobfus
						exit
	;;
	esac
done
