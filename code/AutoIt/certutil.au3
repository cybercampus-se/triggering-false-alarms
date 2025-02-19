#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author: Peter Daniel 2024-11-15

 Script Function:
	AutoIt script that simulates sysadmin encoding and decoding with certutil

#ce ----------------------------------------------------------------------------

$filePath = @UserProfileDir & "\Downloads"

Func RunCommand($command, $delay)
    Run($command)
    Sleep($delay)
EndFunc

Func SendCommand($command, $delay)
    Send($command)
    Sleep($delay)
EndFunc

Func SendDown($count)
    For $i = 1 To $count
        Send("{DOWN}")
        Sleep(1000)
    Next
EndFunc

RunCommand("powershell", 2000)

SendCommand("cd " & $filePath & "{ENTER}", 2000)
SendCommand("Add-Content file.txt 'This is a certutil procedure example' {ENTER}", 2000)
SendCommand("Get-Content file.txt {ENTER}", 2000)

; ╔═════════════════════════════════════════════════════╗
;          LotL Technique: Encoding with Certutil
;      Sigma Rule: proc_creation_win_certutil_encode
;      CommandLine | Contains: ‘-encode’ | ‘/encode’
; ╚═════════════════════════════════════════════════════╝

SendCommand("certutil -encode file.txt encoded-b64.txt {ENTER}", 2000)
SendCommand("Get-Content encoded-b64.txt {ENTER}", 2000)

; ╔═════════════════════════════════════════════════════╗
;           LotL Technique: Decoding with Certutil
;      Sigma Rule: proc_creation_win_certutil_decode
;      CommandLine | Contains: '-decode' | '/decode'
;   CommandLine | Contains: '-decodehex' | '/decodehex'
; ╚═════════════════════════════════════════════════════╝

SendCommand("certutil -decode encoded-b64.txt decoded-file.txt {ENTER}", 2000)
SendCommand("Get-Content decoded-file.txt {ENTER}", 2000)
SendCommand("certutil -hashfile decoded-file.txt SHA1 {ENTER}", 2000)


; ╔═════════════════════════════════════════════════════╗
;    Encoding and Decoding certificates with Certutil
; ╚═════════════════════════════════════════════════════╝


; Create a Self-Signed Certificate; export to a file; encode & decode the certificat; add to 'Trusted Publishers' store; verify
SendCommand("New-SelfSignedCertificate -DnsName demo.com -CertStoreLocation Cert:\\CurrentUser\\My -NotAfter (Get-Date).AddYears(1) -KeyExportPolicy Exportable -FriendlyName DemoCert{ENTER}", 5000)


; Export the certificate to a file (DER encoded)
SendCommand("{Asc 36}Cert = Get-ChildItem -Path Cert:\\CurrentUser\\My | Where-Object {ASC 123} {ASC 36}_.FriendlyName -eq 'DemoCert' {ASC 125} | Select-Object -First 1 {ENTER}", 2000) ; {Asc 36} --> $; {ASC 123} --> {; {ASC 125} --> }

SendCommand("Export-Certificate -Cert {Asc 36}Cert -FilePath .\\DemoCert.cer{ENTER}", 3000)

SendCommand("certutil -encode DemoCert.cer encoded-cert.b64 {ENTER}", 2000)

SendCommand("certutil -decode encoded-cert.b64 decoded-cert.cer {ENTER}", 2000)

SendCommand("certutil -addstore TrustedPublisher decoded-cert.cer {ENTER}", 3000)

SendCommand("certutil -store TrustedPublisher {ENTER}", 2000)

SendCommand("#r", 500)
SendCommand("certmgr.msc {ENTER}", 2000)

; navigate to TrustedPublishers > Certificates > Demo.com
SendDown(6)

SendCommand("{RIGHT}", 1000)
SendCommand("{TAB}", 1000)
SendCommand("{ENTER}", 1000)
SendDown(1)

SendCommand("{ENTER}", 1000)

Send("OK")
SendCommand("{ENTER}", 1000)

SendCommand("!{F4}", 2000)

SendCommand("exit {ENTER}", 2000)