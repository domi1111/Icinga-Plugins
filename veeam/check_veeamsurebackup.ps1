# Global variables

$name = $args[0]
$period = $args[1]
$dateformat = "dd/MM/yyyy"

# Veeam SureBackup job status check

$job = Get-VBRSureBackupJob -Name $name
$name = "'" + $name + "'"


if ($job -eq $null){
	Write-Host "UNKNOWN! No such a job: $name."
	exit 3
}

#Check if Job is disabled

if ($job.ScheduleEnabled -ne $true){

    Write-Host "CRITICAL! The Following Job: $name is Disabled."
    exit 2

}

#Get last result f current SureBackup Job
$status = $job.LastResult


# Check if the last status is failed
if ($status -eq "Failed"){
	
    Write-Host "CRITICAL! SureBackup job $name failed during last runtime"
	exit 2

}

# Check if the last status is failed
if ($status -eq "Warning"){
	
    Write-Host "WARNING! SureBackup job $name failed during last runtime"
	exit 1

}

# Check if the last status is failed
if ($status -eq "Running"){
	
    Write-Host "OK! SureBackup job $name is currently running"
	exit 0

}
	
# Last run check

$now = (Get-Date).AddDays(-$period)
$now = $now.ToString("yyyy-MM-dd")
$last =  Get-VBRSureBackupSession -Name $job | Sort-Object EndTime | select -last 1
$lastrun = $last.EndTime


if((Get-Date $now) -gt (Get-Date $lastrun)){

	Write-Host "CRITICAL! Last run of job: $name more than $period days ago."
	exit 2

} else{
	
    $lastrun = $lastrun.tostring($dateformat)
	Write-Host "OK! Backup process of job $name completed successfully on $lastrun."
	exit 0

}
