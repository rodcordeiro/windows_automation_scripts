'wscript.echo "Come�ou"

on error resume next
Set Comandos = WScript.CreateObject("Wscript.Shell")
Set Rede = WScript.CreateObject("WScript.Network") 
Set Nome = WScript.CreateObject("Shell.Application")
Set PadraoSky = WScript.CreateObject("Scripting.FileSystemObject")

On Error Resume Next
Set objSysInfo = CreateObject("ADSystemInfo")
strUser = objSysInfo.UserName
Set objUser = GetObject("LDAP://" & strUser)
With objUser
  strName = .FullName
  strTitle = .Description
End With

'REMOVE OS MAPEAMENTOS
Comandos.Run "net use * /delete /y",0,True

'MAPEAMENTOS
On Error Resume Next
caminho = "\\server\compartilhamentos\Dorina"
Rede.MapNetworkDrive "R:", caminho , "true"
Nome.NameSpace("R:").Self.Name = "Dorina"
