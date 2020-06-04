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
#    Part   : install Vagrant and virtualbox via chocolaty
#
#############################################################################################################

# Install Chocolatey
  Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Vagrant 
  choco install vagrant
# Install Virtualbox
  choco install virtualbox
  choco install virtualbox.extensionpack