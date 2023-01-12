#---- > Pastas com arquivos  ------------------------------------------------------------------------------------------------------------------------------------------------
ORIGEM_ARQUIVOS='/home/benjamim/Downloads/SCRIPT/NOVO_TESTE' # Original é '/var/spool/cups-pdf/ANONYMOUS'. Nao colocar a "/" no final
DEST_ARQUIVOS='/tmp/PDF' # Pasta PDF dentro da Home do usuario

#VARIAVEL AUXILIAR
CONTADOR='1'

#Filtra linha 2 da saída do find
# find /home/benjamim/Downloads/SCRIPT/NOVO_TESTE -printf "%f\n" | grep d | sed -n 2p



#----> Cria variavel "USUARIO" que vai receber os usernames que estao dentro dos arquivos de cabecalho do diretorio ORIGEM_ARQUIVOS -----------------------------------------

    for USUARIO in `find $ORIGEM_ARQUIVOS -printf "%f\n" | grep c`
        do
        #Extrai o username e remove caracteres invalidos da string
        USERNAME=$(cat $ORIGEM_ARQUIVOS/$USUARIO | awk -F'job' '{print $2}' | awk -F'-' '{print $4}' | awk -F'name' '{print $2}'| tr -dc '[:print:]'| rev | cut -c 2- | rev)
        #Printa nomes em arquivos de texto para verificação
        echo $USERNAME >> users.txt
        #Cria diretorios dos usuarios
        mkdir -p $DEST_ARQUIVOS/$USERNAME

        #Extrai Nome da Fila
        NOME_FILA=$(cat $ORIGEM_ARQUIVOS/$USUARIO | awk -F'job' '{print $1}' | awk -F'/' '{print $5}' | rev | cut -c 2- | rev)
        #Printa nomes em arquivos de texto para verificação
        echo $NOME_FILA >> fila.txt

        #Extrai JOB NAME
        JOB=$(cat $ORIGEM_ARQUIVOS/$USUARIO | awk -F'job' '{print $3}' | awk -F'name' '{print $2}' | tr -dc '[:print:]' | rev | cut -c 2- | rev )
        #Printa nomes em arquivos de texto para verificação
        echo $JOB >> job.txt


       #identifica nome do arquivo com username
       find $ORIGEM_ARQUIVOS -printf "%f\n" | grep d | sed -n $CONTADOR+'p' #CONTADOR vai representar o numero da linha do comando original


       #Incrementa contador para repetir no proximo arquivo
       CONTADOR=CONTADOR+1


    done

