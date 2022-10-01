cls


#1.0 Start of Script
Remove-Variable * -ErrorAction SilentlyContinue
write-host "Running Script"
Remove-Variable * -ErrorAction SilentlyContinue
Add-Type -path "C:\Program Files (x86)\Microsoft.NET\Primary Interop Assemblies\Microsoft.mshtml.dll"
# End of 1.0

#2.0 Set passed in Parameters
#$Date=get-date -Format('yyyyMMddHHmmss') #HC Value to test
#$url = "http://xwing-legacy.com/?f=Galactic%20Empire&d=v8ZsZ200Z187X116W138W98W311W350W166Y196XW114WWWY515XWWWWW449&sn=Random%20Squad&obs=" #HC Value to test
$url=$args[0]  #Passed in from external 
$date=$args[1] #Passed in from external 
$url.replace('"&"',"&")
# End of 2.0 


# 3.0 - Create IE Com Object to Query the Link,
$ie=""   #Set $IE to Blank
$ie = new-object -ComObject "InternetExplorer.Application" #Create Object
$ie.silent = $true #Open IE in the background
$ie.navigate($url) #Load the Webpage
while($ie.Busy) { Start-Sleep -Milliseconds 250 } #Keep checking the webpage until it is fully loaded
Start-Sleep 10
$InnerData= $ie.Document.documentElement.innerHTML  # Set the InnerHTML data 
$ie.Quit()  # Close IE
#End of 3.0

# 4.0 Create the internal parameters
Write-Output "Running script"
$Array = @()
$Output_Folder ="c:\Discord_Bots\ta175\files"
$InnerData |OUT-FILE $Output_Folder\INNER.TXT  #Output HTML data to txt for troubleshooting
$Source = $InnerData # Set Source to equal Innerdata
$Array += $Source -Split('pilot-header-text')  # Split source into multiple objects on pilot-header-text into array called $Array, this splits it down to each Pilot
$Shiplist = $array|select -skip 1 # create $Ship list this is $array without the first item (which is junk data)
$filecount =0    #Set the Filecounter to 0
$Global:FinalArray=@() #Declare FinalArray as a Global Variable 
[int]$runningtotal=0  #Set the Runningtotal to 0
[int]$Global:Listcost # declare Listcost as a Global Variable 
# End of 4.0 


#Function 5.0 (Is run via 6.0)

     Function SplitPilot
     (
     $ITEM,
     $filecount,
     $Global:FinalArray,
     $Date,
     $Global:Listcost 
     )
     {

     # foreach ($item in $Shiplist)
      #  {
      # 5.1.1 Get Ship Details      
        $Splitter = $item -split('"fancy-ship-type"') -split ('inner-circle pilot-points') -split('info-data info-skill')
        #   $Pilot
        $s=$Splitter[0] -split('<') -split('>') #Pilot
            $Pilot = $s[1].Trim()
        #  $Ship
        $s=$Splitter[1] -split('<') -split('>')#Ship
            $Ship = $s[1].Trim()
        #  $BasePoints
        $s=$Splitter[2] -split('<') -split('>')#BasePoints
            $BasePoints = $s[1].Trim()
        # Pilot Skill 
        $s=$Splitter[3] -split('<') -split('>')#init
            $init = $s[1].Trim() -replace("INI","")
      #  $init
      
      # 5.1.2 Attack Stat (section on its own as you can have multiple values
      #Pilot Stats - Attack
      $Splitter  =  $item  -split ("info-data info-attack")
      $s=$Splitter[1] -split('<') -split('>')#Attack
      $Attack = $s[1].Trim()
       $s=$Splitter[2] -split('<') -split('>')
       if($s)
       {
       $Attack =     $Attack +"/"+ $s[1]
       }
       $s=$Splitter[3] -split('<') -split('>')
       if($s)
       {
       $Attack =     $Attack +"/"+ $s[1]
       }
       $s=$Splitter[4] -split('<') -split('>')
       if($s)
       {
       $Attack =     $Attack +"/"+ $s[1]
       }
       $s=$Splitter[5] -split('<') -split('>')
       if($s)
       {
       $Attack =     $Attack +"/"+ $s[1]
       }
       $s=$Splitter[6] -split('<') -split('>')
       if($s)
       {
       $Attack =     $Attack +"/"+ $s[1]
       }

      # 5.1.3 All other Pilot Stats 
      $Splitter  = $item -split ("info-data info-Agility") -split ("info-data info-Hull") -split ("info-data info-Shield") -split("info-data info-force") -split("info-data info-charge")
     # Agility
        $s=$Splitter[1] -split('<') -split('>')#Agility
            $Agility = $s[1].Trim()
     # Hull
        $s=$Splitter[2] -split('<') -split('>')#Hull
            $Hull = $s[1].Trim()
     # Shields

        $s=$Splitter[3] -split('<') -split('>')#Shields
        $Shields = $s[1].Trim()     
     # Force (If force is 0 then is it set to Blank)
        $s=$Splitter[4] -split('<') -split('>')#Force
        if ($s[1])
        {
        $Force = $s[1].Trim()
        if ($Force -eq 0 -or !$force)
        {$ForceHidden=""}
        else 
        {$ForceHidden = " Force:"+$Force }
        } 
     # Charges (If charges is 0 then is it set to Blank)     
        $s=$Splitter[5] -split('<') -split('>')#Charges
        if($s[1])
        {
        $Charge = $s[1].Trim()        
        if ($Charge -eq 0)
        {$ChargeHidden =""}
        else 
        {$ChargeHidden = " Charges:"+$Charge } 
        }
        else
        {
        $ChargeHidden =""
        }
    #*******************
    #5.2 Upgrades***********
    #*******************

    #5.2.1 Load Upgrades data into Array and build $Pilotdetails output line
     $UpgradeArray=@()
     $UpgradeArray += $item -split('<div class="upgrade-name"><i class="xwing-miniatures-font xwing-miniatures-font-')
     $PilotDetails=$Title = "Pilot: "+$Pilot+" Ship: "+$Ship+" Base Points: "+$BasePoints+" Init: "+$init+"xzx"+"Attack:"+$Attack.Replace("////","")+" Agility:"+$Agility+" Hull:"+$Hull+" Shields:"+$Shields+$ForceHidden+$ChargeHidden  
     $ValueArray=@()

    #5.2.2 For each Upgrade in the Upgrade Array (skipping the first one (junk data)
        foreach ($Upgrade in $UpgradeArray |select -skip 1)
            {
            #$Upgrade 
            $CurrentShip =@() # create Current ship Array
            $CurrentShip += $Upgrade -split('"></i>') -split('</div>') -split('"inner-circle upgrade-points">')# Add details to the Array
            #$type = $CurrentShip[0]   #Upgrade type (eg cannon)
            $Upgradecard=$CurrentShip[1] # Upgrade card eg Crackshot
            $cost = $CurrentShip[3]  #Upgrade cost
            [int]$Totalcost =[int]$Totalcost+[int]$cost # Add Upgrade cost to ship cost
            #$ValueArray += "Upgrade: "+$Upgradecard+" Type: "+$type+" Points: "+$cost # create output line into Array
            $ValueArray += $Upgradecard+" ("+$cost+")" # create output line into Array
            }
    #*******************
    #5.3 Output file***
    #*******************
        [int]$Totalcost = [int]$Totalcost+[int]$BasePoints # Add the Upgrade cost to the Base cost
        $FinalArray += $PilotDetails -split("xzx") # add the $PilotDetails line into the Final array (split on XZX)
        If ($ValueArray.length -ge 1)
        {
        $FinalArray +=[string]$ValueArray # add the Upgrades to the Array
        }
        $FinalArray +="Ship Cost: $Totalcost" # Add the total ship cost to the Array 
        $FinalArray += " "# add a blank line into the Array 
        $FinalArray |out-file "$Output_Folder\$Date.txt" -Append ascii # Output as an Ascii txt file (for now)
        #(Get-Content "$Output_Folder\$Date.txt") | Where-Object {$_.trim() -ne "" } | Set-Content "$Output_Folder\$Date.txt"
        #$FinalArray
        $Global:Listcost=[int]$Totalcost # add the total cost to the List cost (the list cost is summed up in 6.0
        
        } 
        

#6.0 Run Function for each item in $ShipList
$filecount =0
foreach ($item in $Shiplist)
      {
  
      SplitPilot -ITEM $item -filecount $filecount -FinalArray $FinalArray -date $Date -Listcost $Listcost
      #$Global:FinalArray # Output FinalArray to the Screen
      $runningtotal=$runningtotal+$Global:Listcost # Add each ship cost to the running total
      #$runningtotal
      }
#Add the final cost to the output file        
Write-Output "ListCost: $runningtotal" |out-file "$Output_Folder\$Date.txt" -Append ascii
 #End of 6.0



#Attack 
  #xwing-miniatures-font-bullseyearc BE
  #xwing-miniatures-font-fullfrontarc  FFA
  #xwing-miniatures-font-frontarc      FA
  #xwing-miniatures-font-doubleturretarc DT
  #xwing-miniatures-font-frontarc 
  #xwing-miniatures-font-reararc      RA