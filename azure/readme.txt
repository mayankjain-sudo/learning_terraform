#Configuring Terraform in windows system.
Open the poweshell and run the below commands

To Enable Powershell with Set-ExecutionPolicy RemoteSigned -scope CurrentUser run the below command
  Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Installing Scoop now ( Scoop is the command line installer for windows for details please go to the URL https://scoop.sh/ )
  iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
This will install the terraform, vim, which and touch modules like Linux 
  scoop install terraform which vim touch
It will check the terraform installation folder or path
  which terraform
It will initializes various local settings and data that will be used by subsequent commands
  terraform init

Now install the azure-cli on your system. Below is the link of microsoft document how to install azure cli
  https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
