<# 
    ����� ������� ������ � ��� ��������� ������ � ����� �� ���������� ��.

#>


$script_dir = $PSScriptRoot  <# ������� ����� ������ #>
$file_names = (get-childitem -Path "$script_dir").name | select-string -pattern "txt"  <# �������� �� ��� ����� � �����#>
$line_name = "�� ������� �������� ������� ������ ��� ��������" <# line to delete #> 


foreach ( $item in $file_names ) {
    $content= (get-content "$item") -notmatch "$line_name"
    Clear-Content $item
    $content | Out-File "$item"
}


