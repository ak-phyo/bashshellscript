#!/bin/bash
echo
echo -ne "\e[31mEnter first number for modulo value and second no for finding multiplcative inverse\e[0m: " && read r1 r2
t1=0;t2=1
a1=$r1
a2=$r2
until [ $r2 -le 0 ]
do
  q=$[$r1/$r2]
  r=$[$r1-$q*$r2]
  r1=$r2;r2=$r

  t=$[$t1-$q*$t2]
  t1=$t2;t2=$t

done
if [ $r1 -eq 1 ] 
then
	if [ $t1 -lt 0 ]
	then
		t1=$[$t1+$a1]
	fi
else
	echo "gcd value is not equal to 1. multiplicative value doesn't exist."
	exit 0
fi
echo "(b*t) mod n = 1
      the multiplicative inverse of $a2 is $t1"
