#------------------------------------------------------VARIABLES--------------------------------------------------------------------------

##SCRIPT COPYING FROM BROOTDIR ALL TO NET FOLDER
##CLEARS IN ASKED FOLDERS BY DATE

################# 1c 7.7 block
        $1c77basedir="c:\1c77_bases"
        $1c77backupfolder="7.7"

    #### 7zip for 1c backups  
        $7zip="c:\Program Files\7-Zip\7z.exe"

################# 1c 8.3 sql block
    #### 1c8sql bases
        $8sqlbase=@('adler',
	    'adler-firm',
	    'adler-work',
        'adler-kondor',
	    'company',
	    'kondor') 

    #### 1c file path
        $1c8file='C:\Program Files (x86)\1cv8\8.3.12.1616\bin\1cv8s.exe'
    #### 1c dns serv name
        $1cservname="server1c"
    #### universal login to base
        $baselogin="admin"
    #### pass to login
        $basepass="1402"

#################backup folders block

    #### main backup dir
        $brootdir="D:\backup_1c\" 

    #uncomment and change block if you need backups files to net folder
    ### net backup dir
        $addnetdisk="net use B: \\192.168.1.227\share_test /user:Dmitriy 1402mda@"
        $deletenetdisk="net use B: /delete /y"
        $bnetdir="B:\"

############### clearing block
    ### LIST OF DIRS TO CLEARING BACKUPS.
        $alllist=($8sqlbase +  
        "$1c77backupfolder")

    #path WHERE LOCATED $alllist for clearing old backups
        $clearingpath=("$brootdir",
        "$bnetdir")

    #counter days for delete files
        $daycount="7"

##############custom variables block
    #### current date
        $date= Get-Date -format "dd-MM-yyyy"

#------------------------------------------------------FUNCTIONS--------------------------------------------------------------------------

function clearing_bases_backups 
{
        write-host "clearing_bases_backups"
        #clear empty path from script if net folder may be not set
        $clearingpath=($clearingpath | Where { $_ })
        foreach ($path in $clearingpath) 
        {
            foreach ($item in $alllist)    
            {
                #TESTED!
                Get-ChildItem "$path$item" -Recurse -File | Where CreationTime -lt  (Get-Date).AddDays(-$daycount)  | Remove-Item -Force
            }        
            write-host "clearing in folder ended"
        }
}

#------------------------------------------------------MAIN CODE--------------------------------------------------------------------------
#connect to net folder
Invoke-Expression $addnetdisk
#dir list in root backup folder
$bdirlist=(get-childitem -Directory -path "$brootdir").name
#download backups from 1c sql and check dir for existence
foreach ($base in $8sqlbase) 
{
	$basedirchecker=$bdirlist | select-string -pattern "$base"
	If ($basedirchecker -eq $null) 
        {

		    new-item -Name $base -ItemType directory -force -path $brootdir

		}
	#Tested!
    taskkill /im 1cv8* /f /t 
    write-output "outload $base backup"
    start-process $1c8file -argumentlist "CONFIG /S $1cservname\$base /N $baselogin /P $basepass /DumpIB $brootdir$base\$base-$date.dt" -wait
} 
	
#This block make 1c_7.7 bases backup, that named like "1c77_25.08.2019.7z"
$basedirchecker=$bdirlist | select-string -pattern "$1c77backupfolder"
	If ($basedirchecker -eq $null) 
        {

		    new-item -Name $1c77backupfolder -ItemType directory -force -path $brootdir

		}

taskkill /im 1cv7* /f /t 
start-process -filepath "$7zip" -argumentlist "a $brootdir$1c77backupfolder\$1c77backupfolder-$date.7z $1c77basedir" -wait

#ROBOCOPY TESTED
if ($bnetdir -ne $null) 

{
    robocopy  $brootdir $bnetdir /E /XC /XN /XO
}

clearing_bases_backups

Invoke-Expression $deletenetdisk
