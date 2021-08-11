# GUI - Desbloquear conta
# O objetivo desse script eh exemplificar o desenvolvimento de interfaces graficas para scripts em Powershell
# Ivo Dias

# Criacao do formulario principal
Add-Type -assembly System.Windows.Forms # Recebe a biblioteca
Import-Module ActiveDirectory # Carrega o modulo do AD
$GUI = New-Object System.Windows.Forms.Form # Cria o formulario principal
# Configura o formulario
$GUI.Text ='TI - Desbloquear Conta' # Titulo
$GUI.AutoSize = $true # Configura para aumentar caso necessario
$GUI.StartPosition = 'CenterScreen' # Inicializa no centro da tela

# Recebe as credenciais
$userADM = $env:UserName # Recebe o usuario atual logado
$userADM = get-aduser -identity $useradm # Busca no AD, as informacoes dele
$userfirst = $userADM.givenName # Pega o primeiro nome do usuario atual
$userlast = $userADM.Surname # Pega o sobrenome do usuario atual
$Domain = (Get-ADDomain).DNSRoot # Recebe o dominio em que o usuario esta
$userAdm = "$Domain\adm.$userfirst$userlast" # Configura a credencial com o padrao: DOMINIO\adm.primeroNomeSegundoNome 
$CredDomain = Get-Credential -Message "Informe as credenciais de Administrador do AD" -UserName $userAdm # Recebe as credenciais

# Label do texto
$lblTexto = New-Object System.Windows.Forms.Label # Cria a label
$lblTexto.Text = "Usuario:" # Define um texto para ela
$lblTexto.Location  = New-Object System.Drawing.Point(0,10) # Define em qual coordenada da tela vai ser desenhado
$lblTexto.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblTexto) # Adiciona ao formulario principal

# Caixa de texto para receber a conta
$TextBox = New-Object System.Windows.Forms.TextBox # Cria a caixa de texto
$TextBox.Width = 300 # Configura o tamanho
$TextBox.Location  = New-Object System.Drawing.Point(60,10) # Define em qual coordenada da tela vai ser desenhado
$GUI.Controls.Add($TextBox) # Adiciona ao formulario principal

# Botao para fazer o desbloqueio
$Button = New-Object System.Windows.Forms.Button # Cria um botao
$Button.Location = New-Object System.Drawing.Size(400,10) # Define em qual coordenada da tela vai ser desenhado
$Button.Size = New-Object System.Drawing.Size(120,23) # Define o tamanho
$Button.Text = "Desbloquear" # Define o texto
$GUI.Controls.Add($Button) # Adiciona ao formulario principal

# Label para receber o retorno do procedimento
$lblResposta = New-Object System.Windows.Forms.Label # Cria a label
$lblResposta.Text = "" # Coloca um texto em branco
$lblResposta.Location  = New-Object System.Drawing.Point(0,40) # Define em qual coordenada da tela vai ser desenhado
$lblResposta.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblResposta) # Adiciona ao formulario principal

# Label para receber o erro
$lblErro = New-Object System.Windows.Forms.Label # Cria a label
$lblErro.Text = "" # Coloca um texto em branco
$lblErro.Location  = New-Object System.Drawing.Point(0,55) # Define em qual coordenada da tela vai ser desenhado
$lblErro.AutoSize = $true # Configura tamanho automatico
$GUI.Controls.Add($lblErro) # Adiciona ao formulario principal

# Configura o retorno do botao, quando for utilizado
$Button.Add_Click(
    {
        # Tenta fazer o desbloqueio da conta
        try {
            $Conta = $TextBox.Text # Recebe a conta que foi escrita na caixa de texto
            Unlock-ADAccount -Identity $Conta -Credential $CredDomain # Faz o desbloqueio da conta
            $resposta = "A conta $conta foi desbloqueada" # Utiliza a label para notificar na tela o resultado
        }
        # Caso encontre algum erro ao fazer o procedimento, retorna
        catch {
            $ErrorMessage = $_.Exception.Message # Recebe a mensagem de erro
            $resposta = "|Ocorreu um erro ao desbloquear a conta|" # Utiliza a label para notificar na tela o resultado
            $lblErro.Text = "|Erro: $ErrorMessage|" # Utiliza a segunda label para mostrar exatamente qual o erro
        }
        $lblResposta.Text =  $resposta # Exibe na tela o retorno do procedimento
        $TextBox.Text = "" # Limpa a caixa de texto, para um proximo uso
    }
)

# Inicia o formulario
$GUI.ShowDialog() # Desenha na tela todos os componentes adicionados ao formulario