
#System Information
$SysInfo=gcim Win32_ComputerSystem -ErrorAction Stop
$CPU=gcim Win32_Processor -ErrorAction Stop

$Props=[ordered]@{
Manufacturer=$SysInfo.Manufacturer
Model=$SysInfo.Model
HostName=$SysInfo.Name
Domain=$SysInfo.Domain
Processor=$CPU.Name
NumberOfCores="$($CPU.NumberOfCores) Cores, $($CPU.NumberOfLogicalProcessors) Threads"
L2CacheSize=$CPU.L2CacheSize
L3CacheSize=$CPU.L3CacheSize
}

$SystemInfo=[pscustomobject]$Props


$Memory=gwmi win32_physicalmemory | Select Manufacturer,Description,@{N="Size";E={$_.Capacity/1GB}},BankLabel,DeviceLocator

$MemoryinGB="$([Math]::Ceiling($SysInfo.TotalPhysicalMemory/1GB)) GB"

$OSInfo=gcim win32_operatingSystem -ErrorAction Stop
$BuildInfo=(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion") | Select DisplayVersion,CurrentBuildNumber,UBR

$OSInfo=$OSInfo | Select @{N="Edition";E={$_.Caption}},@{N="OS Version";E={$BuildInfo.DisplayVersion}}, @{N="Build";E={"$($BuildInfo.CurrentBuildNumber)`.$($BuildInfo.UBR)"}},@{N="Manufacturer";E={$_.Manufacturer}}

$DiskInfo=@()
$diskdrives = Get-CIMInstance CIM_diskdrive

foreach ($disk in $diskdrives) {
    $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
    foreach ($partition in $partitions) {
        $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk

        foreach ($logicaldisk in $logicaldisks) {
            $DiskInfo+=[PSCustomObject]$([ordered]@{Manufacturer=$disk.Manufacturer
            Location=$partition.deviceid
            Drive=$logicaldisk.deviceid
            "Size(GB)"=$logicaldisk.size / 1gb -as [int]
            "FreeSpace(GB)"=$logicaldisk.FreeSpace /1GB -as [int]
            })
        }
    }
}
$networkInformation=Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . 
$VideoCardInformation=gwmi win32_videocontroller | Select @{N='Vendor';E={$_.AdapterCompatibility}},Description,@{N='Resolution';E={"$($_.CurrentHorizontalResolution) x $($_.CurrentVerticalResolution)"}}

Write-Host @"
===================================================================================
                            Processor/HardwareInformation 
===================================================================================

$($SystemInfo | fl | Out-String)

===================================================================================
                             Physical Memory Information 
===================================================================================

$($Memory |ft -AutoSize | Out-String)

===================================================================================
                             Operating System Information 
===================================================================================

$($OSInfo | fl | Out-String)

===================================================================================
                              Disk Information 
===================================================================================

$($DiskInfo | ft -AutoSize | Out-String)

===================================================================================
                               Video Information 
===================================================================================

$($VideoCardInformation | fl | Out-String)

===================================================================================
                               Network Information
===================================================================================
$($networkInformation | ft -AutoSize | Out-String )
"@ 
