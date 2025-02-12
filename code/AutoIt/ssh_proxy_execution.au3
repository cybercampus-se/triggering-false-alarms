#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author: Peter Daniel 2024-11-12

 Script Function:
	AutoIt script that simulates Sysadmin using SSH ProxyCommand to connect to a
	host via an intermediary

 The syntax for SSH Proxying is:
 ssh -o ProxyCommand="ssh -W %h:%p [username]@[proxy_server]" [username]@[remote_server]

#ce ----------------------------------------------------------------------------

; Define proxy credentials
$proxyUsername = "<PROXY_USERNAME>" 
$proxyHost = "<PROXY_HOST_IP>"     
$proxyPassword = "<PROXY_PASSWORD>" 

; Define target credentials
$targetUsername = "<TARGET_USERNAME>" 
$targetHost = "<TARGET_HOST_IP>"   
$targetPassword = "<TARGET_PASSWORD>" 

; Function to execute a command
Func RunCommand($command, $delay)
    Run($command)
    Sleep($delay)
EndFunc

Func SendCommand($command, $delay)
    Send($command)
    Sleep($delay)
EndFunc

RunCommand("cmd", 2000)


; ╔═════════════════════════════════════════════════════╗
;           LotL Technique: SSH as a Proxy
;      Sigma Rule: proc_creation_win_lolbin_ssh
;         CommandLine | Contains: 'ProxyCommand='
; ╚═════════════════════════════════════════════════════╝

; Execute SSH ProxyCommand connection
SendCommand('C:\Windows\Sysnative\OpenSSH\ssh.exe -o ProxyCommand="ssh -W %h:%p ' & $proxyUsername & '{Asc 64}' & $proxyHost & '" ' & $targetUsername & '{Asc 64}' & $targetHost & '{ENTER}', 2000)
SendCommand($proxyPassword  & "{ENTER}", 2000)
SendCommand($targetPassword  & "{ENTER}", 2000)

; Simulated sysadmin activities
SendCommand("whoami && uname -r {ENTER}", 2000)
SendCommand("netstat -an | grep '5901' {ENTER}", 2000) ; network stat
SendCommand("systemctl list-units --type=service | less {ENTER}", 4000)
SendCommand("q {ENTER}", 2000)
SendCommand("sudo apt update {ENTER}", 2000)
SendCommand($remotePassword  & "{ENTER}", 4000)
SendCommand("sudo apt list --upgradable {ENTER}", 2000) ; list upgradable
SendCommand("cat /etc/passwd {ENTER}", 2000) ; list user accounts

SendCommand("exit {ENTER}", 2000)
SendCommand("exit {ENTER}", 2000)