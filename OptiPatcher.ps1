
function main(){
    # Let user bail if wrong version is detected

    if (((Get-ChildItem OptiFine*_MOD.jar) | Measure-Object).Count -ne 1) {
        # TODO: eventually write a fix for this.
        Write-Host "TODO: handle this"
        return
    }

    $OptifineJar = Split-Path (Get-ChildItem OptiFine*_MOD.jar) -leaf

    Write-Host "Patch this version of OptiFine?"
    Write-Host $OptifineJar
    $YN = Read-Host -Prompt "(Y/N)"
    $YN=$YN.ToLower()
    
    if ($YN -eq "y") {
        Write-Host "-- OK, Continuing."
    } elseif ($YN -eq "n") {
        Write-Host "-- OK, Exiting."
        return
    } else {
        Write-Host "-- Answer not understood, Try again."
        Start-Sleep -Seconds 3
        return
    }

    Copy-Item -Path $OptifineJar -Destination "work.zip"
    Expand-Archive -Path "work.zip" -DestinationPath "work"

    Set-Location -Path "work"
    Move-Item -Path "notch\*" -Destination "."
    Set-Location -Path ".."

    Compress-Archive -Path "work\*" -DestinationPath $OptifineJar.Replace("_MOD.jar", "_MOD_PATCHED.jar")
    Remove-Item -Path "work" -Recurse
    Remove-Item -Path "work.zip"

    Write-Host "-- Hopefully Done."

}

main