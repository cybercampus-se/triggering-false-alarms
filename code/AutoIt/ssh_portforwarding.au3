#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author: Peter Daniel 2024-11-12

 Script Function:
	AutoIt script that simulates Sysadmin creating a secure connection between a
	remote server and a local machine using ssh remote portforwarding

 The syntax for setting up remote port forwarding is:
 ssh -R [remote_port]:[destination_address]:[local_port] [username]@[ssh_server]


#ce ----------------------------------------------------------------------------


$remotePort = "<REMOTE_PORT_NUMBER>"
$destinationAddress = "localhost"
$localPort = "<LOCAL_PORT_NUMBER>"
$remoteUsername = "<REMOTE_USERNAME>"
$remotePassword = "<REMOTE_PASSWORD>"
$remoteHost = "<IP_ADDRESS>"

$sshPath = "C:\Windows\Sysnative\OpenSSH\ssh.exe"
$sshPortForwarding = $sshPath & " -v -R " & $remotePort & ":" & $destinationAddress & ":" & $localPort & " " & $remoteUsername & "{Asc 64}" & $remoteHost ; {Asc 64} --> @


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
;       LotL Technique: SSH Portforwarding (remote)
;     Sigma Rule: proc_creation_win_ssh_port_forward
;              CommandLine | Contains:  ‘R’
; ╚═════════════════════════════════════════════════════╝


SendCommand($sshPortForwarding & "{ENTER}", 2000)
SendCommand($remotePassword  & "{ENTER}", 2000)

; sysadmin activites
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

