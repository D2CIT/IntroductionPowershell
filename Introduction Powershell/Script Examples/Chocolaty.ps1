#############################################################################################################
#
#   POWERSHELL THE BASICS 
#____________________________________________________________________________________________________________
#
#   ####    ##    ###        # #####
#   #   #  #  #  #           #   #
#   #   #    #   #    ####   #   #
#   #   #   #    #           #   #
#   ####   ####   ###        #   #
#____________________________________________________________________________________________________________
#
#    Course by D2C-IT ( www.d2c-it.nl)
#
#    Author : Mark van de Waarsenburg
#    Date   : May 2020
#    Part   : install apps via chocolaty
#
#############################################################################################################


#Install Chocolatey 9windows packagemanager)
# - https://chocolatey.org/docs/installation#installing-chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install applications
choco install git
choco install poshgit 
choco install vscode
choco install powershell 
choco install vmware-powercli-psmodule 
 
# Clone Course files with GIT
mkdir c:\PowerShell
set-location c:\PowerShell
git clone https://github.com/D2CIT/IntroductionPowershell.git