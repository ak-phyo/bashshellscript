#!/bin/bash

##########################################
#   Provided by UbuntuMyanmarLocoTeam    #
##########################################

writing_code(){
cat << EOF > /tmp/.postalcode
post_office                   township                          postal_code
ahlone                        ahlone                            11121
aung_san                      insein                            11012
bahan                         bahan                             11201
bayintnaung_market_(thamine)  mayangone                         11062
bogyoke_market                pabedan                           11143
botahtaung                    botahtaung                        11162
botahtaung                    botahtaung                        11161
dagon                         dagon                             11191
dagon_myothit_(north)         dagon_myothit_(north)             11421
dagon_myothit_(south)         dagon_myothit_(south)             11431
dawbon                        dawbon                            11241
hlaing                        hlaing                            11051
hlaing_thar_yar               hlaing_thar_yar                   11401
insein                        insein                            11011
kaba_aye                      mayangone                         11061
kamayut                       kamayut                           11041
kyauk_tan                     kyauk_tan                         11301
kyauktada                     kyauktada                         11182
kyeemyindaing                 kyimyindaing                      11101
lanmadaw                      lanmadaw                          11131
mingalar_taung_nyunt          mingalar_taung_nyunt              11221
mingalardon                   mingalardon                       11021
okkalapa_(north)              okkalapa_(north)                  11031
okkalapa_(south)              okkalapa_(south)                  11091
pabedan                       pabedan                           11141
pazundaung                    pazundaung                        11171
pyi_thar_yar                  yankin                            11082
sanchaung                     sanchaung                         11111
shwe_pyi_thar                 shwe_pyi_thar                     11411
shwepaukan                    okkalapa_(north)                  11032
tamwe                         tamwe                             11211
tanyin                        tanyin                            11291
thamine_college               hlaing                            11052
tharkayta                     tharkayta                         11231
theingyi_market               pabedan                           11142
thingangyun                   thingangyun                       11071
thuwunna                      thingangyun                       11072
yangon                        yangon                            11181
yangon_station                mingalar_taung_nyunt              11222
yankin                        yankin                            11081
EOF
file=/tmp/.postalcode
}

main(){
select no in "postal_code_to_township_name" "township_name_to_postal_code" "exit" "info"
do
case $no in
 "postal_code_to_township_name") echo -n "Enter Postal code and get township name:" && read code
  code_to_name
  exit
;;
 "township_name_to_postal_code") echo -n "Enter Township name and get postal code:" && read name
  name_to_code
  exit
;;
"info") echo "Get yangon postalcode information from http://ohnthar.blogspot.com/2013/12/myanmar-postal-codes-yangon-post-code.html"
        echo "and customized as bash script that can be used easily"
        echo
        /bin/bash $0
;;
"exit") echo "exiting.."
        sleep 1
        exit 0
;;
        
*) echo "Wrong Input,Try Again!"
   sleep 1
   /bin/bash $0
;;

esac
done
}

code_to_name(){
writing_code
echo -e "\e[32mTownship: $(grep $code $file| awk '{print $2}')\e[0m"
rm -f /tmp/.postalcode
exit 0
}

name_to_code(){
writing_code
  printf "%s%18s%18s\n" "Township" "postoffice" "postalcode"
  cat $file | grep -F "$name" | awk '{printf "%s %10s %10s\n",$2,$1,$3}' | column -t
  rm -rf /tmp/.postalcode
  exit
}

while : 
do
main
done
