$param1=$args[0]
gcim Win32_ComputerSystem 
gwmi Win32_Processor 
gwmi win32_videocontroller 
gwmi win32_physicalmemory 
gcim win32_operatingSystem
$param2=$args[1]
$networkInformation=Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName .



