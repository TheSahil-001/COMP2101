#!/bin/bash

echo -----------------------------------
echo 	     SYSTEM INFORMATION
echo -----------------------------------
uname -a | awk '{print "OS Type: " $1}'
uname -a | awk '{print "HostName: " $2}'
echo "UserName: $USER"
lscpu | grep 'Model name' | awk '{print "Processor: " $3, $4, $5, $6, $7, $8}'
lscpu | grep 'Architecture' | awk '{print "CPU Arch.: "$2}'
cat /proc/meminfo | grep 'MemTotal' | awk '{print "Total Memory: " (($2/1024/1024)) "GB"}'
lsblk | grep 'disk' | awk '{print "Total Storage: " $4}'
