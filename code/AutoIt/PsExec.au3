#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author: Peter Daniel (2024-11-14)

 Script Function:
	AutoIt script that simulates Sysadmin creating a domain account on a remote
	machine and opening regedit as SYSTEM to inspect registry keys (SAM hive)
	using PsExec

#ce ----------------------------------------------------------------------------

$PsExecPath = "C:\Tools\PsTools\PsExec.exe" ; change to actual path
$remoteMachine = <IP_ADDRESS>
$username = <USERNAME>
$password = <PASSWORD>


Func RunCommand($command, $delay)
	Run($command)
	Sleep($delay)
EndFunc

Func SendCommand($command, $delay)
	Send($command)
	Sleep($delay)
EndFunc


RunCommand("cmd", 2000)


; ╔════════════════════════════════════════════════════════════════════╗
;                   LotL Technique: Remote execution
;   Sigma Rule: proc_creation_win_sysinternals_psexec_remote_execution
;   	CommandLine | Contains: 'accepteula' | '\\\\' | '-u' | '-p'
; ╚════════════════════════════════════════════════════════════════════╝

; creating domain account on remote workstation
SendCommand($PsExecPath & " \\" & $remoteMachine & " -siu " & $username & " -p " & $password & " cmd {ENTER}", 2000)
SendCommand("net user TestUser Password123 /add {ENTER}", 2000)
SendCommand("net user {ENTER}", 2000)
SendCommand("net localgroup {ENTER}", 2000)
SendCommand("net localgroup Guests {ENTER}", 2000)
SendCommand("net localgroup Guests  DemoUser /add {ENTER}", 2000)
SendCommand("net user TestUser {ENTER}", 2000)
SendCommand("exit {ENTER}", 2000)



; ╔════════════════════════════════════════════════════════════════════╗
;              LotL Technique: Escalation to Local System
;   Sigma Rule: proc_creation_win_sysinternals_psexec_paexec_escalate
;   CommandLine | Contains: 'accepteula' | '\\\\' | '-s -i' | '/s /i'
; ╚════════════════════════════════════════════════════════════════════╝


SendCommand($PsExecPath & " -s -i regedit.exe {ENTER}", 3000)

SendCommand("^l", 500) ; Ctrl+L --> to focus the address bar
SendCommand("HKEY_LOCAL_MACHINE\SAM{ENTER}", 1000) ; navigate to SAM hive

SendCommand("{RIGHT}", 1000) ; RIGHT --> Expand
SendCommand("{DOWN}", 1000)
SendCommand("{RIGHT}", 1000)
SendCommand("{DOWN}", 1000)
SendCommand("{RIGHT}", 1000)

SendCommand("{TAB}", 1000)

SendCommand("!{F4}", 1000)

SendCommand("exit{ENTER}", 1000)