#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author: Peter Daniel 2024-11-15

 Script Function:
	Simulates Sysadmin quitely installing Wireshark and web installing PuTTY
	using Msiexec as well as launching both apllications

#ce ----------------------------------------------------------------------------


Local $installerUrl = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.81-installer.msi" ; http://1.1.1.17/pub/chocolatey/#browse/browse:download:peters_files%2Fputty-64bit-0.81-installer.msi
Local $installerPath = @UserProfileDir & "\Downloads\Wireshark-4.4.1-x64.msi"
Local $wiresharkLogPath = @UserProfileDir & "\Downloads\wireshark_install.log"
Local $PuttyLogPath = @UserProfileDir & "\Downloads\putty_install.log"

$remoteServer = <IP_ADDRESS>
$remoteUsername = <USERNAME>
$remotePassword = <PASSWORD>


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
;      LotL Technique: Install the target .MSI file
;   Sigma Rule: proc_creation_win_msiexec_install_quiet
;    CommandLine | Contains: '/i' | '/q' | '/package'
; ╚═════════════════════════════════════════════════════╝

SendCommand('msiexec /i ' & $installerPath &  " /qb /norestart /l*v " & $wiresharkLogPath & "{ENTER}", 4000) ; install Wireshark


; Opens Wireshark, captures traffic and saves the capture

RunCommand(@ProgramFilesDir & "\Wireshark\Wireshark.exe -i 1 -k", 60000)
SendCommand("^e", 2000) ; Ctrl+E --> to stop capturing
SendCommand("^s", 2000)
SendCommand("capture_log.pcap{ENTER}", 2000)

SendCommand("!{F4}", 2000)



; ╔═════════════════════════════════════════════════════╗
;   LotL Technique: Install .MSI file from a remote URL
;    Sigma Rule: proc_creation_win_msiexec_web_install
;       CommandLine | Contains: ‘msiexec’ & ‘://’
; ╚═════════════════════════════════════════════════════╝


SendCommand('msiexec /i ' & $installerUrl & " /qb /norestart /l*v " & $PuttyLogPath & "{ENTER}", 10000) ; web install PuTTY


; Launchs PuTTY to connect to remote server over SSH
RunCommand(@ProgramFilesDir & "\PuTTY\putty.exe", 2000)


SendCommand($remoteServer, 500)

SendCommand("{TAB}{TAB}{TAB}{TAB}", 500) ; navigate to 'Open' button
SendCommand("{ENTER}", 1000)

SendCommand($remoteUsername & "{ENTER}", 1000)
SendCommand($remotePassword & "{ENTER}", 2000)


SendCommand("ls {ENTER}", 1000)

SendCommand("exit {ENTER}", 1000)
SendCommand("exit {ENTER}", 500)

