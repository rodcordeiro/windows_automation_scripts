'wscript.echo "Começou"

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
caminho = "\\FDNC-SERVER8\MARKETING"
Rede.MapNetworkDrive "T:", caminho , "true"
Nome.NameSpace("T:").Self.Name = "MARKETING"

caminho = "\\FDNC-SERVER8\EVENTOS"
Rede.MapNetworkDrive "A:", caminho , "true"
Nome.NameSpace("A:").Self.Name = "EVENTOS"

On Error Resume Next
caminho = "\\FDNC-SERVER8\Fundacao"
Rede.MapNetworkDrive "U:", caminho , "true"
Nome.NameSpace("U:").Self.Name = "FUNDACAO"

On Error Resume Next
caminho = "\\FDNC-SERVER8\COMUM"
Rede.MapNetworkDrive "X:", caminho , "true"
Nome.NameSpace("X:").Self.Name = "COMUM"

On Error Resume Next
caminho = "\\FDNC-SERVER8\ICONOGRAFIA"
Rede.MapNetworkDrive "W:", caminho , "true"
Nome.NameSpace("W:").Self.Name = "Iconografia"

On Error Resume Next

