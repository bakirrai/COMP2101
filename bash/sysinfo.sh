#!/bin/bash

echo -e "report for:\t\t"`hostname`
echo ===============
echo -e "fqdn:\t\t"`hostname --fqdn`
echo -e "System Main IP:\t\t"`hostname -I`
echo -e "dns name:\t\t"`hostname -d`
echo -e `hostnamectl | grep "Operating System"`
echo -e "Root Filesystem Free Space:\t\t" `df -h /root`
echo ===============

