<# 
    Скріпт видаляє строку у всіх текстових файлах в папці та перезберігає їх.

#>


$script_dir = $PSScriptRoot  <# Домашня папка скріпта #>
$file_names = (get-childitem -Path "$script_dir").name | select-string -pattern "txt"  <# Виділяємо всі тхт файли з папки#>
$line_name = "Не удалось получить Учетную запись для отправки" <# line to delete #> 


foreach ( $item in $file_names ) {
    $content= (get-content "$item") -notmatch "$line_name"
    Clear-Content $item
    $content | Out-File "$item"
}


