# O script fornecido é um script em shell que captura o 
# tráfego de rede usando o comando tcpdump, analisa o arquivo
# de captura gerado usando o comando dnstop e envia o 
# resultado para um chat no Telegram usando a API do Telegram.
# Em seguida, remove os arquivos temporários gerados durante o processo.
# É importante notar que o script utiliza alguns recursos 
# específicos do ambiente Linux. Portanto, para executá-lo 
# corretamente, você precisará de um ambiente Unix/Linux
# e ter as ferramentas tcpdump, dnstop, curl instaladas no sistema.
# Além disso, certifique-se de ter permissões suficientes
# para criar e remover arquivos no diretório /tmp/

#!/bin/bash

FILE="dnstop_$(date +%Y-%m-%d_%H-%M-%S).txt"
TELEGRAM_BOT_TOKEN="TOKEN"
TELEGRAM_CHAT_ID="ID"

# Executa o comando tcpdump para capturar o tráfego de rede
echo " Iniciando Script"
tcpdump -w dump.pcap -c 10000 port 53

# Executa o comando dnstop para analisar o arquivo de captura gerado pelo tcpdump
dnstop -l 4 dump.pcap > "$FILE"

# Envia o arquivo usando a API do Telegram
echo "enviando via API telegram"
curl -F document=@"$FILE" "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument?chat_id=$TELEGRAM_CHAT_ID" &>/dev/null

# Remove arquivos temporarios
echo "Removendo arquivos temporarios"
sleep 02
rm -rf "/tmp/dump.pcap"
rm -rf "/tmp/$FILE"

echo "Script finalizado"
