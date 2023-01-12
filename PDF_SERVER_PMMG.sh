#Pastas com arquivos
ORIGEM_ARQUIVOS='/home/benjamim/Downloads/SCRIPT/scripts_cups_pdf' # Original é '/var/spool/cups-pdf/ANONYMOUS'
DEST_ARQUIVOS='/tmp/PDF' # Pasta PDF dentro da Home do usuario

#Cria variavel "usuario" que vai receber os usernames que estao dentro dos arquivos de cabecalho do diretorio ORIGEM_ARQUIVOS
for USUARIO in `find $ORIGEM_ARQUIVOS -printf "%f\n" | grep c`
 do
 #Extrai o username e remove caracteres invalidos da string
 USERNAME=$(cat $ORIGEM_ARQUIVOS/$USUARIO | awk -F'job' '{print $2}' | awk -F'-' '{print $4}' | awk -F'name' '{print $2}'| tr -dc '[:print:]'| rev | cut -c 2- | rev)
 #echo $USERNAME >> users.txt

 #Cria diretorios dos usuarios
 mkdir -p $DEST_ARQUIVOS/$USERNAME
 done
