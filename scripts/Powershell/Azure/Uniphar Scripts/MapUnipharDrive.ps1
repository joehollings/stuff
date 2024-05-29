$connectTestResult = Test-NetConnection -ComputerName 10107afs01.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"10107afs01.file.core.windows.net`" /user:`"localhost\10107afs01`" /pass:`"eTYBy7jARtMTfvU40G+8sQ1gxcO6K9pItvCPHkYmEln55BaOzL81/pGtITqJPXxlrW+BnbNB7Ufy+AStKl+q5A==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\10107afs01.file.core.windows.net\shared" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}