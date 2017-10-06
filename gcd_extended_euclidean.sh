#!/bin/bash
echo
echo -ne "\e[31m Enter two positive integers to find gcd(greatest common divisor)\e[0m: " && read r1 r2
s1=1;s2=0;t1=0;t2=1
until [ $r2 -le 0 ]
do
  q=$[$r1/$r2]
  r=$[$r1-$q*$r2]
  r1=$r2;r2=$r

  s=$[$s1-$q*$s2]
  s1=$s2;s2=$s

  t=$[$t1-$q*$t2]
  t1=$t2;t2=$t

done

echo "(s*a)+(t*b)=gcd(a,b)
      Greatest common divisor is : $r1 and the value of s is $s1 and the value of t is $t1"
