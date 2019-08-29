# Dynamics365LoginShortcut
With a double click of a short cut, quickly login to your Dynamics instance.

## Prerequisites 
Powershell installed and the default application for opening .ps1 scripts.

## Step 1
Download the zip file and extract to somewhere on your computer. 

## Step 2
Open the folder 'CRM_Shortcuts' and edit 'ShortcutScript.ps1'.
> Replace the text inside the <> with your Dynamics instance values 

> e.g. replace "< URL >" with https://pretendinstance.crm6.dynamics.com/
Save and exit.
  
## Step 3
Right click on LoginToDynamics.ps1 and select properties. Click the 'Unblock' checkbox next to Security.
Do the same to 'SetupTools.ps1'.
  
## Step 4
Right click on the 'ShortcutScript.ps1' script and click 'Create Shortcut'.

## Step 5
Drag and drop new shortcut file to somewhere easy to access e.g. Desktop screen.

## Step 6
Double click on shortcut and the script should run and prompt you for your username and password.
These credentials will be encrypted and stored so you only need to enter them once.

## Note
This currently only works on Chrome.

Credit
--------------
See bottom of LoginToDynamics.ps1 and SetupTools.ps1 for credit
