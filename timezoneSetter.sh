#!/bin/bash
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi
normal=`echo "\033[m"`
menu=`echo "\033[36m"` #Blue
number=`echo "\033[33m"` #yellow
bgred=`echo "\033[41m"`
fgred=`echo "\033[31m"`

function Continents(){
printf "\n${menu}*************Список континентов**************${normal}\n"
TIMEZONES=$(timedatectl list-timezones);
array=(${TIMEZONES// / });
m="${#array[@]}";
cont=();
for (( i=0; i<m; i=i+1))
do
    IFS='/' read -ra my_array <<< "${array[i]}"
    if [[ ! " ${cont[@]} " =~ " ${my_array[0]} " ]]; then
        cont+=("${my_array[0]}")
    fi
done
n="${#cont[@]}";
for ((j=0;j<n-4;j=j+4))
do
    let "a=$j+1"
    let "b=$j+2"
    let "c=$j+3"
    printf "${number} %-3s)${menu} %-18s | ${number} %-3s)${menu} %-18s | ${number} %-3s)${menu} %-18s | ${number} %-3s)${menu} %-18s${normal}\n" "$j" "${cont[j]}" "$a" "${cont[j+1]}" "$b" "${cont[j+2]}" "$c" "${cont[j+3]}"
done
printf "Введите номер континента для отображения временных зон или  ${fgred}q чтобы выйти. ${normal}"
read tz
while [ $tz != '' ]
do
    if [ $tz = '' ]; then
        return 0;
    else
        case $tz in
            q)return 0;
            ;;
            \n)return 0;
            ;;
            *)clear;
            tmzns "${cont[tz]}";
            return 0;
            ;;
        esac
    fi
done
}

function tmzns(){
printf "\n${menu}*************Список врепменных зон**************${normal}\n"
TIMEZONES=$(timedatectl list-timezones | egrep $1);
array=(${TIMEZONES// / });
m="${#array[@]}";
cont=();
for (( j=0; j<m-4; j=j+4))
do
    let "a=$j+1"
    let "b=$j+2"
    let "c=$j+3"
    printf "${number} %-3s)${menu} %-22s | ${number} %-3s)${menu} %-22s | ${number} %-3s)${menu} %-22s | ${number} %-3s)${menu} %-18s${normal}\n" "$j" "${array[j]}" "$a" "${array[j+1]}" "$b" "${array[j+2]}" "$c" "${array[j+3]}"
done
printf "Введите номер зоны для присвоения или ${fgred}q чтобы вернутся к списку континентов. ${normal}"
read tza
while [ $tza != '' ]
do
    if [ $tza = '' ]; then
        return '';
    else
        case $tza in
            q)Continents;
            return 0;
            ;;
            \n)Continents;
            return 0;
            ;;
            *)clear;
            printf "timedatectl set-timezone ${array[$tza]}\n";
            timedatectl set-timezone "${array[$tza]}"
            return 0;
            ;;
        esac
    fi
done
}

printf "\n${menu}************Выбор временной зоны*************${normal}\n"
printf "\n${menu}*********************************************${normal}\n"
Continents

