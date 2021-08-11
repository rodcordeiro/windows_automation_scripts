# Script para enviar mensagens
# AUTOR  : Ivo Dias 
# VERSAO : 1.0.MSC 

# Receber conteudo da mensagem
$msg = Read-Host "Informe a mensagem: "

# Recebe o hostname de destino
$hostname = Read-Host "Informe o Hostname ou IP do computador: "

# Envia a mensagem
Invoke-WmiMethod ` -Path Win32_Process ` -Name Create ` -ArgumentList "msg * $msg" ` -ComputerName $hostname

# Mostra mensagem de encerramento na tela
Write-Host "O procedimento foi concluido"
pause