function get-deviceinfo {

	$systemfamily=(Get-ComputerInfo | Select-Object -Property CsSystemFamily)

	Get-CIMInstance -ClassName win32_ComputerSystem | 
	Select-Object -Property Name, Manufacturer, Model,
	@{n="Device Family"; e={$systemfamily}} | 
	fl * 

}



function get-softwareinfo {
	#Operating System Information.

	'OS Information : '
	'--------------------------'

	Get-ComputerInfo | 
	Select-Object -Property @{n="OS Name"; e={$_.OsName}},
	@{n="OS Version"; e={$_.OsVersion} },
	@{n="Manufacturer"; e={$_.OsManufacturer} },
	@{n="Architecture"; e={$_.OsArchitecture} },
	@{n="Serial Number"; e={$_.OsSerialNumber} } | 
	fl *

	'BIOS Information : '
	'-----------------------------'

	Get-ComputerInfo | 
	Select-Object -Property @{n="Version"; e={$_.BiosBIOSVersion} },
	@{n="Firmware Type"; e={$_.BiosFirmwareType} },
	@{n="Manufacturer"; e={$_.BiosManufacturer} },
	@{n="Serial Number"; e={$_.BiosSerialNumber} } | 
	fl *

}


function get-processorinfo {
	
	Get-CIMInstance -ClassName Win32_Processor | 
	Select-Object -Property Name, Manufacturer,
	@{n='Description'; e={$_.Caption}},
	@{n='Max. Clock Speed (GHz)'; e={$_.MaxClockSpeed/1000 }},
	@{n='L2 Cache Size (KB)'; e={$_.L2CacheSize/1kb -as [int]}},
	@{n='L3 Cache Size (KB)'; e={$_.L3CacheSize/1kb -as [int]}} | 
	fl *


}


function get-diskinfo {
	#This function displays specific parts and sections of Disks in the system


	'Physical Drives : '
	'---------------------------'

	Get-PhysicalDisk | 
	Select-Object -Property @{n='Model'; e={$_.FriendlyName}}, 
	SerialNumber, MediaType, @{n="Status"; e={$_.OperationalStatus}}, 
	@{n="Size(GB)"; e={$_.Size/1gb -as [int]}} | 
	Ft *
	
	#Logical disk display


	'Logical Drives : '
	'--------------------------'

	Get-CIMInstance CIM_LogicalDisk | 
	Select-Object -Property @{n="Logical Name"; e={$_.DeviceID}},
	VolumeName,
	@{n="Total Size(GB)"; e={$_.Size/1gb -as [int]}},
	@{n="Availbale Space(GB)"; e={$_.FreeSpace/1gb -as [int]}} |
	ft *


}


function get-memoryinfo {
	Get-CimInstance -classname Win32_PhysicalMemory | 
	Select-Object -Property Name, Description, Manufacturer, PartNumber, 
	@{n='Size (GB)'; e={$_.Capacity/1gb -as [int]}} | 
	ft * | Select-Object -Unique 
}



function get-ipinfo {
	Get-NetIPConfiguration | 
			Select-Object -Property @{n="Adapter Name"; e={$_.InterfaceAlias}}, 
			InterfaceIndex, 
			@{n="Description"; e={$_.InterfaceDescription}}, 
			IPv4Address, 
			IPv6Address |  
			ft *


}

function get-videocardinfo {
	Get-CIMinstance -classname win32_videocontroller |
	Select-Object -Property Name, VideoProcessor,
	@{n="Manufacturer"; e={$_.AdapterCompatibility}},
	@{n="Model"; e={$_.VideoProcessor}},
	@{n="Installation Type"; e={$_.AdapterDACType}},
	Status,
	@{n="Resolution"; e={($_.CurrentHorizontalResolution, 'X' ,$_.CurrentVerticalResolution) -as [string]}}, 
	@{n="Video Memory(GB)"; e={$_.AdapterRAM/1gb -as [int]}} |
	fl *


}

# Display Formats..

'------------------------------------------------------------------------'
'                      DEVICE INFORMATION               '
'------------------------------------------------------------------------'

get-deviceinfo


'-------------------------------------------------------------------------'
'                      SOFTWARE INFORMATION              '
'--------------------------------------------------------------------------'


get-softwareinfo


'-----------------------------------------------------------------------'
'                      PROCESSOR INFORMATION           '
'-----------------------------------------------------------------------'

get-processorinfo


'-----------------------------------------------------------------------'
'                      DISK INFORMATION                  '
'-----------------------------------------------------------------------'

get-diskinfo


'------------------------------------------------------------------------'
'                      MEMORY INFO                            '
'------------------------------------------------------------------------'

get-memoryinfo


'-----------------------------------------------------------------------'
'                      NETWROK ADAPTER INFORMATION       '
'-----------------------------------------------------------------------'

get-ipinfo


'------------------------------------------------------------------------'
'                      VIDEO CARD INFORMATION                   '
'------------------------------------------------------------------------'

get-videocardinfo
