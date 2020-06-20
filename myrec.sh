#!/bin/bash

echo '----------MyRec-R4c50----------'
echo 'Running...'
mkdir ~/recondata/$1 && cd ~/recondata/$1
cd ~/recondata/$1 && host $1 | awk '/ / {print $4}' > IP.txt ; sed -i '/handled/d' IP.txt 
cd ~/recondata/$1 && nmap -A -T4 --script=vuln -iL IP.txt -vvv -oN $1.nmap.txt 
cd ~/recondata/$1 && assetfinder --subs-only $1 | sort -u -o domains && cat domains | httprobe | tee hosts ; meg -d 1000 -v /
echo 'Running Gobuster...' && cd ~/recondata/$1 && gobuster -m dns -t 100 -u $1 -w /usr/share/wordlists/dirb/common.txt -o $1.gobuster.txt
echo 'Running Dirsearch...' && cd ~/recondata/$1 && dirsearch -L hosts -e html,php,asp --plain-text-report=$1.dirsearch.txt && awk '/200 / {print $1,$2,$3}' $1.dirsearch.txt | sort -f -u -o response200.txt
cd ~/recondata/$1 && cat $1.dirsearch.txt && awk '/302 / {print $1,$2,$3}' $1.dirsearch.txt | sort -f -u -o response302.txt
cd ~/recondata/$1 && cat $1.dirsearch.txt && awk '/403 / {print $1,$2,$3}' $1.dirsearch.txt | sort -f -u -o response403.txt
cd ~/recondata/$1 && cat $1.dirsearch.txt && awk '/401 / {print $1,$2,$3}' $1.dirsearch.txt | sort -f -u -o response401.txt
nikto -h $1 -o nikto.$1.txt
wpscan --url $1 -o wpscan.$1.txt
grep -Hnri php * | awk '/ / {print $3}' > allphp.txt
grep -Hnri xml * | awk '/ / {print $3}' > allxml.txt
