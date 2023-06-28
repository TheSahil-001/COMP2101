#!/bin/bash


#sourcing the function library file for report pruposes.
source reportfunctions.sh

#check if the user is or has root privilidges.
if [ "$USER" == "root" ]

then


	if  [ "$1" != ""  ] #this is ot match the options for the report functions

	then
	  
		while [ $# -gt 0 ]; do
  	  	case "$1" in
    			-h|--help)
      			displayhelp  #help display for report
      			exit 1
      			;;

    			-v) #for verbose mode
			set -x
			computerreport 2> >(logger -t $(basename "$0") -i -p user.error)
			osreport 2> >(logger -t $(basename "$0") -i -p user.error)
			cpureport 2> >(logger -t $(basename "$0") -i -p user.error)
			ramreport 2> >(logger -t $(basename "$0") -i -p user.error)
			videoreport 2> >(logger -t $(basename "$0") -i -p user.error)
			networkreport 2> >(logger -t $(basename "$0") -i -p user.error)
			set +x 
      			;;

			#other specific reports

    			-system)
      			computerreport
			osreport
			cpureport
			ramreport
			videoreport
      			;;

    			-disk)
      			diskreport
      			;;

    			-network)
      			networkreport
			;;

    			*)
			echo "Invalid Option, check -h or --help for more information"
      			exit 1
 	  	  esac
		  shift
		done 

	else 
		#this is running the whole report in case of no options assigned.
		echo "Getting Your System Information now...."

		echo "Information Fetched by $USER at " date

		osreport

		computerreport

		cpureport

		ramreport

		diskreport

		networkreport
	fi

else
	# Message for user to run the script with ROOT privilidges.
	echo "Please Run the Script as ROOT user !"

fi

