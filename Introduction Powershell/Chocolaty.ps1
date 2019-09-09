#Install Chocolatey 9windows packagemanager)
# - https://chocolatey.org/docs/installation#installing-chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install git
choco install poshgit 
choco install vscode
choco install powershell 
choco install vmware-powercli-psmodule 

mkdir c:\powershell
cd c:\powershell
git clone https://github.com/D2CIT/IntroductionPowershell.git