#/bin/bash
#--------------------------------------------> LPDF service - 1.0 beta - Policia Militar de Minas Gerais - CTS - Secao de redes
#
#Script para manipulacao de arquivos de impressao Prodemge.
#Baseado no script de sandro.alves@bombeiros.mg.gov.br
#
# Licença GPL
# Autores: benjamim.gois@gmail.com , rodrigoferreira@unatec.com.br
# 10/01/2023
#
# Dependencias (enscript, ghostscript, cups)

#---- > Variaveis globais  ------------------------------------------------------------------------------------------------------------------------------------------------

ORIGEM_ARQUIVOS='/var/spool/cups' # Pasta que contem os arquivos recebidos pelos CUPs, a original é '/var/spool/cups'. Nao colocar a "/" no final
PASTA_TEMP='/tmp/PDF' # Pasta temporaria para criacao e mescla dos PDFs. Nao colocar a "/" no final
DEST_ARQUIVOS=' /var/www/html/' #Pasta final com PDFs montados
TEMPO_LOOP=10 # Tempo em segs para aguardar entre as verificacoes

#---- > Variaveis globais  ------------------------------------------------------------------------------------------------------------------------------------------------


clear

while true; do #Loop para inicializar daemon

    #Cria variavel "ARQUIVO" que vai receber o nome dos arquivos de cabecalho do diretorio ORIGEM_ARQUIVOS.
    for ARQUIVO in `find $ORIGEM_ARQUIVOS -printf "%f\n" | grep c`
        do

        #Exibe nome do arquivo (DEBUG)
        echo '---' $ARQUIVO '---'
        #Extrai Nome da Fila
        NOME_FILA=$(cat $ORIGEM_ARQUIVOS/$ARQUIVO | awk -F'job' '{print $1}' | awk -F'/' '{print $5}' | tr -dc '[:print:]' | rev | cut -c 2- | rev)
        #Printa valor (DEBUG)
        echo Fila = $NOME_FILA

        #Extrai JOB NAME
        JOB=$(cat $ORIGEM_ARQUIVOS/$ARQUIVO | awk -F'job' '{print $3}' | awk -F'name' '{print $2}' | tr -dc '[:print:]' | rev | cut -c 2- | rev )
        #Printa valor (DEBUG)
        echo Jobname = $JOB


        #Extrai o username e remove caracteres invalidos da string
        USERNAME=$(cat $ORIGEM_ARQUIVOS/$ARQUIVO | awk -F'job' '{print $2}' | awk -F'-' '{print $4}' | awk -F'name' '{print $2}'| tr -dc '[:print:]'| rev | cut -c 2- | rev)
        #Printa valor (DEBUG)
        echo Username = $USERNAME


        #Cria pasta temporaria com diretorios do usuario
        mkdir -p $PASTA_TEMP/$USERNAME


        # Move arquivo dados para diretorio do usuario. Arquivo de dados possui o mesmo nome do cabecalho, mas com a letra "D" e o sufixo "-001"
        ARQUIVO_DADOS=$(echo $ARQUIVO'-001' | tr 'c' 'd')
        mv $ORIGEM_ARQUIVOS/$ARQUIVO_DADOS $PASTA_TEMP/$USERNAME
        # Deleta arquivo cabecalho
        rm -Rf $ORIGEM_ARQUIVOS/$ARQUIVO

        #Printa valor (DEBUG)
        echo Arquivo = $ARQUIVO_DADOS

        #Conta arquivos na pasta dos usuarios
        #QTD_ARQUIVOS_1=$(ls $PASTA_TEMP/$USERNAME | grep d | wc -l)
        #Printa valor (DEBUG)
        #echo QTD Arquivos = $QTD_ARQUIVOS_1

       # Salta espaco para organizacao
       echo ' '

    done

 echo ------------------------------------------------------------------------------------------------ CONTAGEM_1 --------------------------------------------------------------------------------------------
 echo
 #Cria arquivo de texto com contagem de arquivos inicial
 for ARQUIVO_PASTA in `ls $PASTA_TEMP`
        do
        echo ' '
        #Exibe nome do arquivo (DEBUG)
        echo '---' $ARQUIVO_PASTA '---'
        #Printa valor (DEBUG)
        echo Username = $ARQUIVO_PASTA
        #Grava username no arquivo texto
        #echo $ARQUIVO_PASTA >> /tmp/QTD_ARQUIVOS_1.txt

        #Conta arquivos na pasta dos usuarios
        QTD_ARQUIVOS_1=$(ls $PASTA_TEMP/$ARQUIVO_PASTA | grep d | wc -l)
        #Printa valor (DEBUG)
        echo QTD Arquivos = $QTD_ARQUIVOS_1
        #Grava quantidade no arquivo texto
        echo $QTD_ARQUIVOS_1 >> /tmp/QTD_ARQUIVOS_1.txt
        done

    echo
    echo -------------------------------------------------------------------------------  TEMPO DE VERIFICACAO $TEMPO_LOOP seg ---------------------------------------------------------------------------------------
    echo
    echo

    #Espera tempo para chegar novos arquivos
    sleep $TEMPO_LOOP

  echo ------------------------------------------------------------------------------------------------ CONTAGEM_2 --------------------------------------------------------------------------------------------
  echo

 #Cria arquivo de texto com contagem de arquivos apos tempo de verificacao
 for ARQUIVO_PASTA in `ls $PASTA_TEMP`
        do
        echo ' '
        #Exibe nome do arquivo (DEBUG)
        echo '---' $ARQUIVO_PASTA '---'
        #Printa valor (DEBUG)
        echo Username = $ARQUIVO_PASTA
        #Grava username no arquivo texto
        #echo $ARQUIVO_PASTA >> /tmp/QTD_ARQUIVOS_2.txt

        #Conta arquivos na pasta dos usuarios
        QTD_ARQUIVOS_2=$(ls $PASTA_TEMP/$ARQUIVO_PASTA | grep d | wc -l)
        #Printa valor (DEBUG)
        echo QTD Arquivos = $QTD_ARQUIVOS_2
        #Grava quantidade no arquivo texto
        echo $QTD_ARQUIVOS_2 >> /tmp/QTD_ARQUIVOS_2.txt
        done


  for ARQUIVO_PASTA in `ls $PASTA_TEMP`
  do

        #Cria diretorio final para arquivos PDF
        mkdir -p $DEST_ARQUIVOS/$ARQUIVO_PASTA

        #Compara valores e cria PS/PDF
        if [ $ARQUIVOS_USUARIO_1 -eq $ARQUIVOS_USUARIO_2 ]; then
        #Exibe pasta (DEBUG)ORIGEM_ARQUIVOS
        echo $PASTA_TEMP/$ARQUIVO_PASTA

        #Gera arquivo Postscript
        enscript -B -r -f Courier7 -p $PASTA_TEMP/$ARQUIVO_PASTA/file.ps $PASTA_TEMP/$ARQUIVO_PASTA/* # -B no header, -r landscape , -t title, -f fonte Courier7

        #Converte Postscript em PDF
        ps2pdf $PASTA_TEMP/$ARQUIVO_PASTA/file.ps $DEST_ARQUIVOS/$ARQUIVO_PASTA/Arquivo_$(date +%d-%m-%Y_%H-%M).pdf

        echo Criado PDF para usuario $ARQUIVO_PASTA
        # Salta espaco para organizacao
        echo ' '

        else
        echo $PASTA_TEMP/$ARQUIVO_PASTA
        echo Aguardando finalizar transferencia de arquivo
        echo ' '
        fi
  done


#Remove arquivos temporarios
rm -Rf $PASTA_TEMP/*

#Remove arquivo de contagem antigo
rm -Rf /tmp/QTD_ARQUIVOS_*


done #while loop
