

taskkill /im 1cv8* /f /t 

net stop "1C:Enterprise 8.3 Server Agent"
timeout /t 15 /nobreak
net start "1C:Enterprise 8.3 Server Agent"   