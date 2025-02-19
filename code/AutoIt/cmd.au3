#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author: Peter Daniel 2024-11-11

 Script Function:
	AutoIt script that simulates sysadmin cmd usage

#ce ----------------------------------------------------------------------------

$path= "\Downloads\temp" ; directory path containing files to be deleted

Func RunCommand($command, $delay)
    Run($command)
    Sleep($delay)
EndFunc

Func SendCommand($command, $delay)
    Send($command)
    Sleep($delay)
EndFunc

RunCommand("cmd", 2000)

SendCommand("cd " & @UserProfileDir & $path & "{ENTER}", 2000)

; ╔═════════════════════════════════════════════════════╗
;   LotL Technique: Files & Subdirectories Listing (dir)
;     Sigma Rule: proc_creation_win_cmd_dir_execution
;         CommandLine | Contains: 'dir ' & '/s'
; ╚═════════════════════════════════════════════════════╝

SendCommand("dir /S {ENTER}", 2000)

SendCommand("whoami && hostname {ENTER}", 2000)


; ╔═════════════════════════════════════════════════════╗
;     LotL Technique: File deletion (using wildcard)
;  Sigma Rule: proc_creation_win_cmd_del_greedy_deletion
;   Cmdline | Contains: 'del'/'erase' | *.exe (dll, js)
; ╚═════════════════════════════════════════════════════╝


SendCommand("erase *.exe {ENTER}", 2000)
SendCommand("dir /S {ENTER}", 2000)

; ╔═════════════════════════════════════════════════════╗
;        LotL Technique: Execution of Systeminfo
;   Sigma Rule: proc_creation_win_systeminfo_execution
;          CommandLine | Contains: 'systeminfo'
; ╚═════════════════════════════════════════════════════╝

SendCommand("systeminfo | findstr Boot {ENTER}", 2000)

; sysadmin activities
SendCommand("chkdsk {ENTER}", 9000)

SendCommand("ipconfig {ENTER}", 2000)
SendCommand("getmac {ENTER}", 2000)
SendCommand("tasklist {ENTER}", 2000)

SendCommand("exit {ENTER}", 2000)

