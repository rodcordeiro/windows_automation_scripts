::**************************************************************************************************************************************************					
::NOME       : Preventiva					
::AUTOR      : Rodrigo Cordeiro					
::VERSION    : 4.0
::Release Note: 
::	- Incluido CCleaner para iniciar durante a preventiva;
::	- Configurado caminho para pasta no servidor do cliente Globo Master.
::	- Removido Eventvwr e inserido o 'Console.msc', para visualização de eventos (com atalho ara os erros configurado em 'Exibição personalizada') e visualização dos usuários;
::
::PENDENTE: Atualização dos caminhos das pastas no servidor dos clientes.					
::**************************************************************************************************************************************************					

:: Configurações de tela.					
::/==================================================================================================================					
:mode					
echo	off				
title	BELTIS SUPORTE - OUTSOURCING - INFRAESTRUTURA				
COLOR	0C				
::/==================================================================================================================					
cls					
echo: 	%date%	 %time%		
echo.					
echo.					
echo.					
echo.					
echo.	*************************************************************			
echo.		NAO SE ESQUECA DE EXECUTAR COMO ADMINISTRADOR 		
echo.	*************************************************************			
echo.					
echo.					
echo.					
TIMEOUT /T 2					
::/==================================================================================================================					
:prev
title BELTIS - Preventiva
color 0F

call :print
echo.	*************************************************************
echo.
echo.	       	  INICIANDO A PREVENTIVA 	
echo.	     
echo.	*************************************************************
echo.

timeout /t 1
goto :belarc

::/==================================================================================================================
:belarc
call :print
set /p option=Executar o Belarc? ([S]Sim/[N]Nao)
echo.
echo.

if %option% EQU S (
	call :bel
	) else if %option% EQU s (
	call :bel
	) else (
	call :Prev
	)
::/==================================================================================================================
:bel
call :print Belarc
echo. Iniciando belarc...
if exist "%programfiles(x86)%" (
	if exist "C:\Program Files (x86)\Belarc\BelarcAdvisor\" (
		cd "C:\Program Files (x86)\Belarc\BelarcAdvisor\"
		start BelarcAdvisor.exe
		call :Prev
		) else (
		cd "C:\Preventiva\"
		start advisorinstaller.exe
		timeout /t 15
		call :Prev
		)
		) else (
		if exist "C:\Program Files\Belarc\BelarcAdvisor\" (
			cd "C:\Program Files\Belarc\BelarcAdvisor\"
			start BelarcAdvisor.exe
			call :Prev
			) else (
			cd "C:\Preventiva\"
			start advisorinstaller.exe
			timeout /t 15
			call :Prev
			)
			)

::/==================================================================================================================
:Prev
echo.Efetuando Limpeza


call :print Limpeza
defrag -c -v >C:\Preventiva\result_defrag.txt
del /s /f /q c:\windows\temp\*.*
rd /s /q c:\windows\temp
md c:\windows\temp
del /s /f /q C:\WINDOWS\Prefetch
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
rd /s /q c:\windows\tempor~1
rd /s /q c:\windows\temp
rd /s /q c:\windows\tmp
rd /s /q c:\ff*.tmp
rd /s /q %windir%\history
rd /s /q c:\windows\cookies
rd /s /q c:\windows\recent
rd /s /q c:\windows\spool\printers
rd /s /q %temp%
rd /s /q c:\windows\repair
rd /s /q c:\windows\system32\dllcache
rd /s /q c:\windows\Downloaded Installations
rd /s /q c:\MSOCache
rd /s /q c:\windows\Installer
rd /s /q c:\windows\system32\ReinstallBackups
del c:\WIN386.SWP
if not exist "C:\WINDOWS\Users\*.*" goto skip
if exist "C:\WINDOWS\Users\*.zip" del "C:\WINDOWS\Users\*.zip" /f /q
if exist "C:\WINDOWS\Users\*.exe" del "C:\WINDOWS\Users\*.exe" /f /q
if exist "C:\WINDOWS\Users\*.gif" del "C:\WINDOWS\Users\*.gif" /f /q
if exist "C:\WINDOWS\Users\*.jpg" del "C:\WINDOWS\Users\*.jpg" /f /q
if exist "C:\WINDOWS\Users\*.png" del "C:\WINDOWS\Users\*.png" /f /q
if exist "C:\WINDOWS\Users\*.bmp" del "C:\WINDOWS\Users\*.bmp" /f /q
if exist "C:\WINDOWS\Users\*.avi" del "C:\WINDOWS\Users\*.avi" /f /q
if exist "C:\WINDOWS\Users\*.mpg" del "C:\WINDOWS\Users\*.mpg" /f /q
if exist "C:\WINDOWS\Users\*.mpeg" del "C:\WINDOWS\Users\*.mpeg" /f /q
if exist "C:\WINDOWS\Users\*.ra" del "C:\WINDOWS\Users\*.ra" /f /q
if exist "C:\WINDOWS\Users\*.ram" del "C:\WINDOWS\Users\*.ram"/f /q
if exist "C:\WINDOWS\Users\*.mp3" del "C:\WINDOWS\Users\*.mp3" /f /q
if exist "C:\WINDOWS\Users\*.mov" del "C:\WINDOWS\Users\*.mov" /f /q
if exist "C:\WINDOWS\Users\*.qt" del "C:\WINDOWS\Users\*.qt" /f /q
if exist "C:\WINDOWS\Users\*.asf" del "C:\WINDOWS\Users\*.asf" /f /q
:skip
if not exist C:\WINDOWS\Users\Users\*.* goto skippy /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.zip del C:\WINDOWS\Users\Users\*.zip /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.exe del C:\WINDOWS\Users\Users\*.exe /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.gif del C:\WINDOWS\Users\Users\*.gif /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.jpg del C:\WINDOWS\Users\Users\*.jpg /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.png del C:\WINDOWS\Users\Users\*.png /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.bmp del C:\WINDOWS\Users\Users\*.bmp /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.avi del C:\WINDOWS\Users\Users\*.avi /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mpg del C:\WINDOWS\Users\Users\*.mpg /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mpeg del C:\WINDOWS\Users\Users\*.mpeg /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.ra del C:\WINDOWS\Users\Users\*.ra /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.ram del C:\WINDOWS\Users\Users\*.ram /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mp3 del C:\WINDOWS\Users\Users\*.mp3 /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.asf del C:\WINDOWS\Users\Users\*.asf /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.qt del C:\WINDOWS\Users\Users\*.qt /f /q
if exist C:\WINDOWS\Users\AppData\Temp\*.mov del C:\WINDOWS\Users\Users\*.mov /f /q
:skippy
if exist "C:\WINDOWS\ff*.tmp" del C:\WINDOWS\ff*.tmp /f /q
if exist C:\WINDOWS\ShellIconCache del /f /q "C:\WINDOWS\ShellI~1\*.*"
rd /s c:\$Recycle.Bin
%windir%\system32\rundll32.exe advapi32.dll,ProcessIdleTasks
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.	************************************************
echo.
echo.	       LIMPEZA EFETUADA COM SUCESSO.
echo.
echo.	************************************************


::/==================================================================================================================
call :print Softwares
echo.Iniciando Softwares
ping localhost>nul

start eventvwr.msc
start appwiz.cpl
start Inetcpl.cpl
start wuapp.exe
start msconfig
start C:\Preventiva\diskinfo.exe
start C:\Preventiva\CCLeaner.exe
start C:\Preventiva\BlueScreenView.exe


::/==================================================================================================================
call :print Usuario local Beltis

echo.
set /p option= Atualizar usuario local Beltis? ([S]Sim/[N]Nao)
echo.
echo.

if %option% EQU S (
	call :user
	) else if %option% EQU s (
	call :user
	) else (
	call :TeamViewer
	)
	:user
	call :pd
	echo. *ATUALIZANDO USUARIO
	timeout /t 1
	net user beltis %passwd%
	net user beltis %passwd% /add /comment:"Usuario local administrativo utilizado para suporte"
	net localgroup administradores beltis /add
	net localgroup administrators beltis /add
	CLS
	echo.
	echo.
	echo.	************************************************
	echo.
	echo.	       USUARIO ATUALIZADO COM SUCESSO!
	echo.
	echo.	************************************************
	ping localhost>nul
::/==================================================================================================================
:TeamViewer

call :print TeamViewer
if exist "%programfiles(x86)%" (
	cd "C:\Program Files (x86)\TeamViewer\"
	if not exist "TeamViewer12_Logfile.log" (
		net stop TeamViewer 
		"%programfiles(x86)%\TeamViewer\uninstall.exe" /S
		timeout /t 10
		start C:\Preventiva\TeamViewer_Setup.exe
		schtasks /create /sc onlogon /tn TeamViewer /tr "%programfiles(x86)%\TeamViewer\TeamViewer.exe" /f /rl highest
		exit
		) else if not exist "C:\Program Files (x86)\TeamViewer\" (
		start C:\Preventiva\TeamViewer_Setup.exe
		schtasks /create /sc onlogon /tn TeamViewer /tr "%programfiles(x86)%\TeamViewer\TeamViewer.exe" /f /rl highest
		exit
		) else (
		echo.	************************************************
		echo.
		echo.	       TEAMVIEWER CORRETO INSTALADO!
		echo.
		echo.	************************************************
		timeout /t 1
		exit	
		)
		) else (
		cd "C:\Program Files\TeamViewer\"
		if not exist "TeamViewer12_Logfile.log" (
			net stop TeamViewer 
			"%programfiles%\TeamViewer\uninstall.exe" /S
			timeout /t 10
			start C:\Preventiva\TeamViewer_Setup.exe
			schtasks /create /sc onlogon /tn TeamViewer /tr "%programfiles%\TeamViewer\TeamViewer.exe" /f /rl highest
			exit
			) else if not exist "C:\Program Files (x86)\TeamViewer\" (
			start C:\Preventiva\TeamViewer_Setup.exe
			exit
			) else (
			echo.	************************************************
			echo.
			echo.	       TEAMVIEWER CORRETO INSTALADO!
			echo.
			echo.	************************************************
			timeout /t 1
			exit	
			)
			)

::/==================================================================================================================
:print

cls
echo: 	%date%	 %time%
echo: DOMINIO: %userdomain%    USUARIO: %username%      COMPUTADOR: %computername%
echo: 
echo: 
echo: 
echo:%*
echo:

goto :eof

:pd
set passwd=suporte@2018
set passwd=suporte@2019