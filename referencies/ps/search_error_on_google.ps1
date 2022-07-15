# Direciona o catch diretamente para uma pesquisa no Google
# Ivo Dias
# https://github.com/IGDEXE/PS-Google-Catch/blob/master/GoogleSearch.psm1
# Funcao para fazer a pesquisa
function Get-GoogleAnswer {
    param (
        [Parameter(Mandatory, ValueFromRemainingArguments)]    
        $mensagemErro
    )

    # Abre uma pesquisa com o termo que deu erro
    Start-Process "https://www.google.com/search?q=$mensagemErro"
}

# Exemplo de uso
try {
    Set-ADUser -Identity "87ssdd877sd"
}
catch {
    Get-GoogleAnswer $_.Exception.Message
}