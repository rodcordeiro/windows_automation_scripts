@ECHO OFF

:START
cls
%homedrive%
cd %USERPROFILE%
cd..
set profiles=%cd%

for /f "tokens=* delims= " %%u in ('dir /b/ad') do (

cls
title Deletando %%u COOKIES. . .
echo. "Deletando %%u COOKIES. . ." 
if exist "%profiles%\%%u\cookies" cd "%profiles%\%%u\cookies" >null 2>&1
if exist "%profiles%\%%u\cookies" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
cls

title Deletando %%u Temp Files. . .
if exist "%profiles%\%%u\Local Settings\Temp" cd "%profiles%\%%u\Local Settings\Temp" >null 2>&1
if exist "%profiles%\%%u\Local Settings\Temp" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\Local Settings\Temp" rmdir /s /q "%profiles%\%%u\Local Settings\Temp" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u Temp Files. . .
if exist "%profiles%\%%u\AppData\Local\Temp" cd "%profiles%\%%u\AppData\Local\Temp" >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Temp" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Temp" rmdir /s /q "%profiles%\%%u\AppData\Local\Temp" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u Temporary Internet Files. . .
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" cd "%profiles%\%%u\Local Settings\Temporary Internet Files" >null 2>&1
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" rmdir /s /q "%profiles%\%%u\Local Settings\Temporary Internet Files" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u Temporary Internet Files. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %Systemroot%\Temp
if exist "%Systemroot%\Temp" cd "%Systemroot%\Temp" >null 2>&1
if exist "%Systemroot%\Temp" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%Systemroot%\Temp" rmdir /s /q "%Systemroot%\Temp" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %SYSTEMDRIVE%\Temp
if exist "%SYSTEMDRIVE%\Temp" cd "%SYSTEMDRIVE%\Temp" >null 2>&1
if exist "%SYSTEMDRIVE%\Temp" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%SYSTEMDRIVE%\Temp" rmdir /s /q "%Systemroot%\Temp" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u FIREFOX TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" cd "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" rmdir /s /q "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u CHROME TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" cd "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u EDGE TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u EDGE COOKIES. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 

cls
title Deletando %%u OPERA TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" cd "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Caches" del *.* /F /S /Q /A: R /A: H /A: A >null 2>&1
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" >null 2>&1
echo. "Deletando %%u COOKIES. . ." 
pause > nul 


)


goto END


:END
exit