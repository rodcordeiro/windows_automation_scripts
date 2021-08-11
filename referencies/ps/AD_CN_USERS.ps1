# Script para verificar usuarios 
# AUTOR  : Ivo Dias
# VERSAO : 1.0.MSC

# Recebe o grupo
$grupo = Read-Host "Informe o grupo "

# Gera o relatorio no arquivo GroupListUsers.txt, dentro da temp
Get-ADGroup -Filter {CN -eq  $grupo} -Properties Member | Select-Object -ExpandProperty Member | Get-ADUser | Select-Object name >> C:\GroupListUsers.txt

# Ao concluir, mostra mensagem na tela
Write-Host "Por favor, verifique o relatorio em: C:\GroupListUsers.txt"