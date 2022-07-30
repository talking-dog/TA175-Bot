So the process is pretty simple and this is very much a WIP, the current folder structure is:

C:\Discord_Bots\TA175

in here place:

Shutdown.cmd
RunBot.cmd
TA175.PY
ScanningProtocol.ps1
.env (file with discord key) 
and create a new subfolder called "Files"

so it should look like this:

C:\Discord_Bots\TA175
C:\Discord_Bots\TA175\Files
C:\Discord_Bots\TA175\.env
C:\Discord_Bots\TA175\RunBot.cmd
C:\Discord_Bots\TA175\Scanning_Protocol.ps1
C:\Discord_Bots\TA175\Shutdown.cmd
C:\Discord_Bots\TA175\ta175.py

You also need to make sure the following file exists on the machine 
C:\Program Files (x86)\Microsoft.NET\Primary Interop Assemblies\Microsoft.mshtml.dll

You will also need to install:
in order
Python 3.10.4 or above
Visual Studio Code
Discord pip for Python
DotEnv for Python
PyWin32 for Python

How it works, so it needs a windows PC to run (and Internet explorer (yes I know)), 
1 - when someone puts in "//xwing-legacy.com/" into the Discord channel it checks the length and if it is over 90 characters it calls the PowerShell script Scanning_Protocol, it also outputs a Scanning message to
the Discord channel 

2 - Scanning_Protocol opens up the page in the background and gets the innerHtml saving the results down as Inner.txt in the C:\Discord_Bots\TA175\Files folder (this could be kept inside the script but
it is easier for development to see the output.

3 - Scanning_Protocol then goes through Inner.txt and digs out the data such as the Pilot, Ship, Stats and upgrades along with the points.

4 - It syncs these together and outputs the results to a new TXT file called Datetime.txt (this datetime value is passes in from the Python script), the PowerShell then finishes and TA175.PY continues

5 - TA175 then reads the Datetime.txt and outputs the results to Discord by updating the "Scanning Message" this also allows it to get the messageID which is added to the end of the output as part of the distruct message 

The two CMD files are just there incase you want to set the Windows machine to restart on a schedule and if you do restart the bot, so at the moment, the Windows machine runs C:\Discord_Bots\TA175\Shutdown.cmd every day and C:\Discord_Bots\TA175\RunBot.cmd on Windows startup.