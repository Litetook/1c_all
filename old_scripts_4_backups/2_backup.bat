rem выгрузка ИБ Адлер

forfiles /p D:\Arxiv\adler /m *.dt /d -5 /c "cmd /c del @path /q"
forfiles /p D:\Arxiv\adler /m *.bak /d -5 /c "cmd /c del @path /q"


taskkill /im 1cv8* /f /t 


"C:\Program Files (x86)\1cv8\8.3.12.1616\bin\1cv8s.exe" CONFIG /S"Server1C\adler-work" /N"admin" /P"1402" /DumpIB"D:\Arxiv\adler-work_%date:~-10%.dt"

timeout /t 240 /nobreak

rem выгрузка ИБ Компания

forfiles /p D:\Arxiv\company /m *.dt /d -5 /c "cmd /c del @path /q"
forfiles /p D:\Arxiv\company /m *.bak /d -5 /c "cmd /c del @path /q"


taskkill /im 1cv8* /f /t 


"C:\Program Files (x86)\1cv8\8.3.12.1616\bin\1cv8s.exe" CONFIG /S"Server1C\company" /N"dmitriy" /P"1402" /DumpIB"D:\Arxiv\company_%date:~-10%.dt"

timeout /t 240 /nobreak

rem Создание архивов файловый баз

"c:\Program Files\7-Zip\7z.exe" a D:\Arxiv\7.7\1c77_%date:~-10%.7z c:\1c77_bases

rem "c:\Program Files\7-Zip\7z.exe" a D:\Arxiv\adler\!_Adler_%date:~-10%.7z c:\1sBaseAdler-work

rem "c:\Program Files\7-Zip\7z.exe" a D:\Arxiv\company\!_company_%date:~-10%.7z c:\1cbasecomp

timeout /t 30 /nobreak



rem Adler - перемещене в папки хранения

forfiles /p D:\Arxiv\adler /m *.bak /s /d -5 /c "cmd /c del @path /q"
forfiles /p D:\Arxiv\adler /m *.dt /s /d -5 /c "cmd /c del @path /q"
rem forfiles /p D:\Arxiv\adler /m *.7z /s /d -5 /c "cmd /c del @path /q"

move D:\Arxiv\adler-work.bak 			D:\Arxiv\adler\adler-work_%date:~-10%.bak
move D:\Arxiv\adler-work_%date:~-10%.dt 	D:\Arxiv\adler\adler-work_%date:~-10%.dt 

rem Company - Перемещение в папки хранения

forfiles /p D:\Arxiv\company /m *.bak /s /d -5 /c "cmd /c del @path /q"
forfiles /p D:\Arxiv\company /m *.dt /s /d -5 /c "cmd /c del @path /q"
rem forfiles /p D:\Arxiv\company /m *.7z /s /d -5 /c "cmd /c del @path /q"

move D:\Arxiv\company.bak		 	D:\Arxiv\company\company_%date:~-10%.bak
move D:\Arxiv\company_%date:~-10%.dt		D:\Arxiv\company\company_%date:~-10%.dt 

rem Adler_77 - перемещене в папки хранения

forfiles /p D:\Arxiv\7.7 /m *.7z /s /d -5 /c "cmd /c del @path /q"

timeout /t 30 /nobreak

rem Копирование архивов на резервный сервер

net use B: \\192.168.1.227\Backup_1c /user:Dmitriy 1402mda@

rem forfiles /p C:\!_backup\adler /m *.dt /d -5 /c "cmd /c del @path /q"
forfiles /p B:\7.7 /m *.7z /d -5 /c "cmd /c del @path /q"
forfiles /p B:\adler /m *.dt /d -5 /c "cmd /c del @path /q"
forfiles /p B:\adler /m *.bak /d -5 /c "cmd /c del @path /q"
forfiles /p B:\company /m *.dt /d -5 /c "cmd /c del @path /q"
forfiles /p B:\company /m *.bak /d -5 /c "cmd /c del @path /q"
forfiles /p B:\medoc /m *.zbk /d -5 /c "cmd /c del @path /q"

xcopy D:\Arxiv b: /s /e /d /y

net use B: /del 

