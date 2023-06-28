#!/bin/bash

# Function for creating Operating System report.
function osreport {

	osname=$(grep 'NAME' /etc/os-release | sed 's/NAME=//' | sed -n 2p )

	os_ver=$(grep 'VERSION_ID' /etc/os-release | sed 's/VERSION_ID=//' | sed -n 1p)

	hostname=$(uname -a | awk '{print  $2}')

cat <<EOF

  =========== 
 | OS Report |    # Template Display for Human readable form
  ===========

System Name: $osname

OS Version: $os_ver

Hostname: $hostname

Current Uer: "$USER" 

EOF
}

# Function for Computer Report

function  computerreport {

	comp_desc=$(lshw | grep 'product:' | sed 's/product://' | sed -n 1p)

	comp_vendor=$(lshw | grep 'vendor:' | sed 's/vendor://' | sed -n 1p)

	comp_serial=$(lshw | grep 'serial:' | sed 's/serial://' |  sed -n 1p)

cat <<EOF

  =================
 | Computer Report | 
  =================

Computer Description: $comp_desc

Computer Manufacturer: $comp_vendor

Computer Serial: $comp_serial

EOF
} 

# Function for CPU/ Processor Report; using lscpu for info.

function cpureport {

	proc_model=$(lscpu | grep 'Model name' | awk '{print $3, $4, $5, $6, $7, $8}')

	proc_arch=$(lscpu | grep 'Architecture' | awk '{print $2}')

	proc_speed=$(echo "$proc_model" | awk '{print $6}')

	proc_cap=$(lshw | grep 'capacity:' | sed 's/capacity://' | sed -n 1p | awk '{print (($0/1024)) "GHz" }')
	
	cpu_l1=$(lscpu | grep 'L1'| sed -n 1p | awk '{print $3 "Kb"}') 

	cpu_l2=$(lscpu | grep 'L2'| sed -n p | awk '{print $3 "Mb"}')

	cpu_l3=$(lscpu | grep 'L3'| sed -n p | awk '{print $3 "Mb"}')

cat <<EOF

  ============
 | CPU Report | 
  ============

Model: $proc_model

Architechture: $proc_arch

Current Speed: $proc_speed

Maximum Speed: $proc_cap

CPU Cache Sizes: 
  L1:  $cpu_l1     L2: $cpu_l2     L3: $cpu_l3

EOF

}

# Function for RAM / Memory Report; using the 'free' command

function ramreport {

	memory=$(free -h)

cat <<EOF

  ============
 | RAM Report | 
  ============ 

$memory

EOF

}

# Function for Disk/Storage Report; using 'df' command

function diskreport { 

	storage=$(df -h | grep -v 'tmpfs')

cat <<EOF

  =============
 | Disk Report | 
  =============

$storage

EOF

}

# Function for Video and Graphics report; using 'lshw' command

function videoreport {

	video_manf=$(lshw -C display | grep 'vendor' | sed 's/vendor://')

	video_desc=$(lshw -C display | grep 'description' | sed 's/description://')

	video_model=$(lshw -C display | grep 'product' | sed 's/product://')

cat <<EOF

  ===================
 | Video Card Report | 
  ===================

Product: $video_model

Desciption: $video_desc

Manufacturer: $video_manf

EOF

}

# Function for Network Interfaces report; using 'ip -a' and 'lshw' command

function networkreport {

	net_desc=$(lshw -C network | grep 'description' | sed 's/description://')

	net_product=$(lshw -C network | grep 'product' | sed 's/product://')

	net_manf=$(lshw -C network | grep 'vendor' | sed 's/vendor://')

	net_speed=$(lshw -C network | grep 'clock' | sed 's/clock://')

	net_name=$(lshw -C network | grep 'logical name' | sed 's/logical name://' | tr -s ' ')

	net_addr=$(ip a | grep "$net_name" | grep 'inet' | awk '{print $2}' )

cat <<EOF

  ================
 | Network Report | 
  ================

Product Name: $net_product

Description: $net_desc

Manufacturer: $net_manf

Network Name: $net_name

Speed: $net_speed

Address Assigned: $net_addr

EOF


}

# Display Help Function in case of user help needed.

function displayhelp {

cat <<EOF

	This is a help section for the System Information Script: 

	use [-h] or [--help] for help display.
	use [-v] for Verbose mode. 
	use [-system] for displaying basic System Configs.
	use [-disk] for Disk/Storage Report.
	use [-network] for Network Information.

EOF
}
