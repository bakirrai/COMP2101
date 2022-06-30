#!/bin/bash
#hostname 
echo -e "Hostname:\t\t"`hostname`
echo -e "System Main IP:\t\t"`hostname -I`
echo -e "dns name:\t\t"`hostname -d`
echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-` / `uname -r`
echo -e "Root Filesystem Status:\t\t" `df`
