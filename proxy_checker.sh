#!/bin/bash
set -u

#SOCKS 4/5 proxy checker
#Input format: <IP>:<Port>#socks<4,5>
#Output format: socks<4,5> <IP> <Port>


# proxy_url="https://list.didsoft.com/get?email=emmet8brown@protonmail.com&pass=c9wik2&pid=socks1500&showcountry=no&showversion=yes"

function proxy_check
{
    proxy=${1}
    proxy_ver=${2}
    proxy_response=$(curl --socks${proxy_ver} "${proxy}" -s --max-time 5 "http://checkip.dyndns.com/")
    proxy_addr=$(echo ${proxy} | cut -d':' -f1)
    proxy_port=$(echo ${proxy} | cut -d':' -f2)
    echo ${proxy_response} | grep --silent ${proxy_addr}
    proxy_ok=$?                                                                                                  
    if [ ${proxy_ok} -ne 0 ]                                                                                     
    then                                                                                                         
        echo "[-] ${proxy}" 
    else
        echo "[+] ${proxy}"
        echo "socks${proxy_ver} ${proxy_addr} ${proxy_port}" >> proxies.txt
    fi
    sleep 1
}

function proxy_list_check
{
    proxy_file=${1}
    _IFS=$IFS; IFS=$'\n' 
    for proxy_line in $(cat ${1})
    do
        old_ifs=$IFS;IFS=' '
        proxy=$(echo ${proxy_line} | cut -d'#' -f1)
        proxy_ver=$(echo ${proxy_line} | cut -d'#' -f2 | sed 's/socks//;s/SOCKS//')
        proxy_check ${proxy} ${proxy_ver}
        IFS=${old_ifs}
    done
    IFS=${_IFS}
    rm ${1}
}

# curl -s "${proxy_url}" > proxy_list
python3 get_proxy_list.py > proxy_list 
split -d --lines 10 proxy_list pl_
rm proxy_list
rm proxies.txt
for proxy_file in pl_*
do
    time proxy_list_check ${proxy_file} &
done

sleep 3

while ls pl_* 1> /dev/null 2>&1
do
    sleep 1
done
cat proxies.txt | grep socks5 | cut -d' ' -f2-3 | sed 's/ /:/' > p
printf "Total proxies: "
wc -l proxies.txt
printf "For autoreg: "
wc -l p
# echo "Copying p to autoreg..."
# scp p tega@192.168.1.50:/home/tega/autoreg/proxy_list
# scp p tega@192.168.1.51:/home/tega/autoreg/proxy_list
echo "DONE!"
