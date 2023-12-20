# Skrypt sprawdza czy plik uległ modyfikacji

Param (
    $CurrentDate = $(Get-Date -Format("dd.MM.yyyy HH:mm:ss")),
    [Int32]$NoModifyTimeAllowed = 1, #In minutes 
    $DirToCheck = "",
    [string[]]$AllowedExtension = ('*.txt', '*.rtf', '*.doc', '*.csv')
)

function Read-File {
    param (
        $FileName
    )

    return Get-Content -Path $FileName
}

function Send-Email() {

    Param (
        [string]$FileName,
        [Int32]$LastTimeEdit
    )

    # Pobieram adresy dla ktorych wysle maila
    $addresses = Read-File -FileName $PSScriptRoot\addresses


    # Pobieram dane dla serwera smtp
    $config = Read-File -FileName $PSScriptRoot\config
    $username = $config[0]
    $password = ConvertTo-SecureString $config[1] -AsPlainText -Force
    $smtp = $config[2]

    $Cred = New-Object System.Management.Automation.PSCredential ($username, $password)

    $MailMessage = @{
        To = $addresses
        From = $username
        Subject = "RCP skrypt"
        Body = "<h1>Wykryto problem z plikiem</h1><p>Plik: <strong>$FileName</strong></p> <p>Nie został zaktualizowany w żądanym okresie czasowym</p><p>Jego ostatnia aktualizacja była <strong>$LastTimeEdit</strong> minut temu"
        Smtpserver = $smtp
        BodyAsHtml = $true
        Encoding = "UTF8"
        Credential = $Cred
        UseSsl = $true
    }
    Send-MailMessage @MailMessage
}

If (-Not (Test-Path $DirToCheck)) {
    Throw "Path -> '$DirToCheck' Not exist"
}

Write-Host "Current date is: $CurrentDate"
Write-Host
Write-Host

Write-Host "Getting list of files in DIR $DirToCheck"
Get-ChildItem -Path $DirToCheck -Recurse -Include $AllowedExtension
$Files = Get-ChildItem -Path $DirToCheck -Recurse -Include $AllowedExtension
Write-Host #Blank line

foreach ($File in $Files) {
    $FileDate = $File.LastWriteTime
    $FileLastTimeEditInMinutes = [Int32](NEW-TIMESPAN –Start $FileDate –End $CurrentDate).TotalMinutes
    If ([Int32](NEW-TIMESPAN –Start $FileDate –End $CurrentDate).TotalMinutes -gt $NoModifyTimeAllowed) {
        Write-Error "Warning! Plik: $($File.Name) nie został zmodyfikowany w żądanym okresie czasu"
        Write-Error "Ostatnio zmodyfikowany $FileLastTimeEditInMinutes minut temu"
        Send-Email -FileName $File.FullName -LastTimeEdit $FileLastTimeEditInMinutes
        Write-Host
    }
}

Write-Host "Script done"