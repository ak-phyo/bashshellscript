#!/bin/bash

for i in $(awk '{print $2}' port.txt | grep -nw "$1" | cut -d ":" -f1)
do
  for j in $(cat -n port.txt | grep -w " $i" | awk '{print $2}')
  do
    echo "PORT No $1 is : $j"
  done
done 

