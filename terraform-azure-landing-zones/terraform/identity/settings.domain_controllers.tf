locals {
  backslash          = "$backslash = [char]0x05C"
  command01          = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  url                = "$url = 'https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'"
  file               = "$file = $env:temp + $backslash + 'ConfigureRemotingForAnsible.ps1'"
  command02          = "(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)"
  command03          = "powershell.exe -ExecutionPolicy ByPass -File $file"
  powershell_command = "${local.backslash}; ${local.command01}; ${local.url}; ${local.file}; ${local.command02}; ${local.command03}"
}