#!/bin/bash


osname=$(uname -a | awk '{print $1}')

hostname=$(uname -a | awk '{print  $2}')

comp_desc=$(sudo lshw | grep 'product:' | sed 's/product://' | sed -n 1p)

comp_vendor=$(sudo lshw | grep 'vendor:' | sed 's/vendor://' | sed -n 1p)

comp_serial=$(sudo lshw | grep 'serial:' | sed 's/serial://' |  sed -n 1p)

proc_model=$(lscpu | grep 'Model name' | awk '{print $3, $4, $5, $6, $7, $8}')

proc_arch=$(lscpu | grep 'Architecture' | awk '{print $2}')

proc_speed=$(echo "$proc_model" | awk '{print $6}')

proc_cap=$(sudo lshw | grep 'capacity:' | sed 's/capacity://' | sed -n 1p | awk '{print (($0/1024)) "GHz" }')

memory=$(grep 'MemTotal' /proc/meminfo | awk '{print  (($2/1024/1024)) "GB"}')

storage=$(lsblk | grep 'disk' | awk '{print  $4}')

cpu_l1=$(lscpu | grep 'L1'| sed -n 1p | awk '{print $3 "Kb"}') 

cpu_l2=$(lscpu | grep 'L2'| sed -n p | awk '{print $3 "Mb"}')

cpu_l3=$(lscpu | grep 'L3'| sed -n p | awk '{print $3 "Mb"}')

time_now=$(date | awk '{print $5}')

cat <<EOF

-----------------------
  SYSTEM INFORMATION
-----------------------

Information Update fetched on $time_now

 | Computer Inforamtion | 

Description: $comp_desc

Manufacturer: $comp_vendor

Computer Serial: $comp_serial

 | Operating System | 

OS Name: $osname

Hostname: $hostname

Current User: $USER

 | Proccessor | 

Model Name: $proc_model
 
Architecture: $proc_arch

Processor Speed: $proc_speed

Processor Max. Capacity: $proc_cap

L1 Cache: $cpu_l1

L2 Cache: $cpu_l2

L3 Cache: $cpu_l3

 | Storage Info. | 

Total Memory: $memory

Total Storage: $storage

EOF
