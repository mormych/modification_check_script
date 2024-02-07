# Skrypt sprawdza czy plik uległ modyfikacji
function Setup-Config () {
    If( -Not ((Get-Content -Path .\config.cfg -ReadCount 1) -eq "[modification_check_script]"))
    {
        exit 1
    }

    Get-Content -Path .\config.cfg | ForEach-Object -Begin {$config = @{}} -Process {$data = [regex]::Split($_, "="); If(($data[0].StartsWith("[") -ne $True) -and ($data[0].CompareTo("") -ne 0)) {$config.Add($data[0], $data[1])}}
    #General
    $global:daysToCheck = $config.Get_Item("daysToCheck") -split ",";
    $global:dirsToCheck = $config.Get_Item("dirsToCheck") -split ",";
    $global:noModifyTime = $config.Get_Item("noModifyTime");
    $global:excludedFormats = $config.Get_Item("excludedFormats") -split ",";
    $global:CurrentDate = $(Get-Date -Format("dd.MM.yyyy HH:mm:ss"));
    #Sending
    $global:port = $config.Get_Item("port");
    $global:smtp = $config.Get_Item("smtp");
    $global:user = $config.Get_Item("user");
    $global:pass = $config.Get_Item("pass");
    $global:destination = $config.Get_Item("destination") -split ",";

}

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

    $password = ConvertTo-SecureString $pass -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential ($user, $password)

    $MailMessage = @{
        To = $destination
        From = $user
        Subject = "RCP skrypt"
        Body = "<h1>Wykryto problem z plikiem</h1><p>Plik: <strong>$FileName</strong></p> <p>Nie został zaktualizowany w żądanym okresie czasowym</p><p>Jego ostatnia aktualizacja była <strong>$LastTimeEdit</strong> minut temu (limit: <strong>$noModifyTime</strong>)"
        Smtpserver = $smtp
        BodyAsHtml = $true
        Encoding = "UTF8"
        Credential = $Cred
        UseSsl = $true
    }
    Send-MailMessage @MailMessage
}

Setup-Config

If (-Not ($dirsToCheck | Test-Path)) {
    Throw "Path -> '$dirsToCheck' Not exist"
}

if(-Not ($daysToCheck -contains (Get-Date).DayOfWeek.value__))
{
    exit 2
}

foreach($dirToCheck in $dirsToCheck)
{
    Get-ChildItem -Path $dirToCheck -Recurse -Exclude $excludedFormats
    $Files = Get-ChildItem -Path $dirToCheck -Recurse -Exclude $excludedFormats

    foreach ($File in $Files) {
        $FileDate = $File.LastWriteTime
        $FileLastTimeEditInMinutes = [Int32](NEW-TIMESPAN –Start $FileDate –End $CurrentDate).TotalMinutes
        If ([Int32](NEW-TIMESPAN –Start $FileDate –End $CurrentDate).TotalMinutes -gt $noModifyTime) {
            Send-Email -FileName $File.FullName -LastTimeEdit $FileLastTimeEditInMinutes
        }
    }
}