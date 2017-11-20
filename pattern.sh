#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Wrong usage, try again!"
  e\xit
fi

if [[ $1 == "-o" ]]
then  
  python -c "import pattern;print pattern.pattern_offset('$2')"
  e\xit
fi

if [[ $1 == "-c" ]]
then
  python -c "import pattern;print pattern.pattern_create($2)"
  e\xit
fi

if [[ $1 == "-b" ]]
then
  echo badchar=\( ;for i in {0..9} {A..F}; do echo -n \"; for j in {0..9} {A..F}; do echo -n '\x'$i$j; done;echo \"; done; echo \)
  exit
fi
