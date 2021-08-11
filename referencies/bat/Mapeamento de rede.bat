@echo off
echo Mapeando unidades de rede
net use l: /delete
net use l: \\capri.local\Arquivos\CONSULTA_TECNICA_$
net use n: /delete
net use N: \\capri.local\Arquivos\PROCEDIMENTOS_E_POLITICAS_$
net use o: /delete
net use O: \\capri.local\Arquivos\ASSISTENTE_DIRETORIA_$ /Y
net use p: /delete
net use P: \\capri.local\Arquivos\DIRETORIA_$ /Y
net use q: /delete
net use Q: \\capri.local\Arquivos\JOSECARLOS_FLAVIODEZORZI_$ /Y
net use r: /delete
net use R: \\capri.local\Arquivos\PRITELEMATICA_$ /Y

net use t: /delete
net use T: \\capri.local\Arquivos\TEANI_$ /Y
net use u: /delete
net use U: \\capri.local\Arquivos\TERENVILLAGE_$ /Y
net use v: /delete
net use V: \\capri.local\Arquivos\TERRACAPRI_$ /Y
net use x: /delete
net use X: \\capri.local\Arquivos\COMUNICADOS_$ /Y
net use y: /delete
net use Y: \\capri.local\Arquivos\SCANNER_$ /Y
net use z: /delete
net use Z: \\capri.local\Arquivos\TEMPORARIOS_$ /Y