  
# Autor  : Ivo Dias
# Social : igd753
# E-mail : igd753@outlook.com.br

# Adiciona biblioteca
Add-Type -AssemblyName System.speech

# Cria narrador
$narrador = New-Object System.Speech.Synthesis.SpeechSynthesizer

# Recebe o texto 
$texto = Read-Host "Informe o que deseja ouvir: "

# Lê o texto
$narrador.Speak("$texto")