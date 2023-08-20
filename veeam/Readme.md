# Icinga powershell script to monitor SureBackup-Jobs


INSTALLATION:

1. Copy the powershell-script in the Icinga directory

2. Add a basic command to execute powershell checks:

object CheckCommand "powershell_check" {
    import "plugin-check-command"
    command = [
        "C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\powershell.exe"
    ]
    timeout = 30s
    arguments += {
        "-command" = {
            description = "Path to the powershell script"
            order = -1
            required = true
            value = "$ps_command$"
        }
        "-crit" = "$ps_crit$"
        "-warn" = "$ps_warn$"
        ";exit" = "$$LastExitCode"
    }
}


Command Template:

& 'path\to\script\check_veeamsurebackup.ps1' 'SureBackupJobName' 'Numberofdayssincelastrun'
  
Command Example: 

& 'path\to\script\check_veeamsurebackup.ps1' 'TestJob' '2'