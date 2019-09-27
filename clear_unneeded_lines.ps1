#This script remove $line_name from all txt files in current folder!

$script_dir = $PSScriptRoot  #Script launch folder
$file_names = (get-childitem -Path "$script_dir").name | select-string -pattern "txt"  #Highlight all txt files from $script_dir
$line_name = "Не удалось получить Учетную запись для отправки" #line to delete 


foreach ( $item in $file_names ) {
    $content= (get-content "$item") -notmatch "$line_name"
    Clear-Content $item
    $content | Out-File "$item"
}


