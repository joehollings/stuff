Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
cinst boxstarter -y

Set-BoxstarterConfig -LocalRepo "\\owscsafs01.file.core.windows.net\nas\BoxStarter"