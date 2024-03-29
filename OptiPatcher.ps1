
function main(){
    # Let user bail if wrong version is detected

    $OptifineJarCount = ((Get-ChildItem OptiFine*_MOD.jar) | Measure-Object).Count

    if ($OptifineJarCount -gt 1) { # greater than 1
        $OptifineJarList = (Get-ChildItem OptiFine*_MOD.jar).Name
        Write-Host "Multiple OptiFine JARs found. Please select one from the list below."
        for ($i = 0; $i -lt $OptifineJarList.Length; $i++)
        {
            Write-Host $i ")" $OptifineJarList[$i]
        }
        $OptifineJar = $OptifineJarList[(Read-Host -Prompt "Select a Jar (0,1,2,etc.) ")]
        if ([string]::IsNullOrEmpty($OptifineJar)) {
            Write-Host "--Invalid response to prompt."
            Start-Sleep -Seconds 3
            return
        }
    } elseif ($OptifineJarCount -eq 0) { # is zero
        Write-Host "-- No OptiFine JARs found in the current working directory."
        Write-Host "   Make sure you've extracted the mod from the OptiFine installer and put it in the same folder as this script."
        Start-Sleep -Seconds 3
        return
    } elseif ($OptifineJarCount -eq 1) {
        $OptifineJar = Split-Path (Get-ChildItem OptiFine*_MOD.jar) -leaf
    }

    if ([System.IO.File]::Exists($OptifineJar.Replace("_MOD.jar", "_MOD_PATCHED.jar"))) {
        Write-Host "!! "$OptifineJar.Replace("_MOD.jar", "_MOD_PATCHED.jar")" exists!"
        Write-Host "Please remove it before continuing."
        Start-Sleep -Seconds 5
        return
    }

    Write-Host -NoNewline "Patch this version of OptiFine:" $OptifineJar"? "
    $YN = Read-Host -Prompt "(Y/N)"
    $YN=$YN.ToLower()
    
    if ($YN -eq "y") {
        Write-Host "-- OK, Continuing."
    } elseif ($YN -eq "n") {
        Write-Host "-- OK, Exiting."
        Start-Sleep -Seconds 3
        return
    } else {
        Write-Host "-- Answer not understood, Try again."
        Start-Sleep -Seconds 3
        return
    }

    Copy-Item -Path $OptifineJar -Destination "work.zip"
    Expand-Archive -Path "work.zip" -DestinationPath "work"

    Copy-Item -Path "work\notch\*" -Destination "work" -Recurse -Force

    Compress-Archive -Path "work\*" -DestinationPath $OptifineJar.Replace("_MOD.jar", "_MOD_PATCHED.jar")
    Remove-Item -Path "work" -Recurse
    Remove-Item -Path "work.zip"

    Write-Host "-- Hopefully Done."

	pause

}

# Version check

if ($PSVersionTable.PSVersion.Major -lt "7") {
    Write-Host "This script doesn't run on the built in powershell version in windows."
    Write-Host "Please download the latest version of PowerShell from: https://aka.ms/powershell-release?tag=stable"
    pause
    return
}

main