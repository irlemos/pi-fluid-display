#!/bin/bash
# Script da tela de espera com loop "auto-reparável".
# Garante que a tela de status sempre volte após uma desconexão.

# Configurações iniciais da sessão gráfica, executadas uma única vez
sleep 1
/usr/bin/xset s off      # Desabilita o screensaver
/usr/bin/xset s noblank  # Desabilita o escurecimento da tela
/usr/bin/xset -dpms      # Desabilita o gerenciamento de energia do monitor
/usr/bin/openbox &       # Inicia o gerenciador de janelas leve em segundo plano

# Loop de auto-reparo
while true; do
    # Monta o texto de informações a ser exibido
	CONFIG_FILE="/home/pi/pi-fluid-display/pfd-config.txt"
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        # Valor padrão caso o arquivo de config não exista
        DISPLAY_NAME="Tela em $(hostname)"
    fi
    IP_ADDR=$(hostname -I | cut -d' ' -f1)
    WIFI_SSID=$(/usr/sbin/iwgetid -r)
    if [ -z "$WIFI_SSID" ]; then NETWORK_INFO="Rede:           Conectado via Cabo"; else NETWORK_INFO="Rede Wi-Fi:     $WIFI_SSID"; fi
    
    INFO_TEXT="\n\n\n                          PiFluidDisplay"
	INFO_TEXT+="\n -------------------------------------------------------------------\n\n"
    INFO_TEXT+="   Display:        $DISPLAY_NAME\n"
    INFO_TEXT+="   Hostname:       $(hostname)\n"
    INFO_TEXT+="   $NETWORK_INFO\n"
    INFO_TEXT+="   IP:             $IP_ADDR\n\n"
    INFO_TEXT+=" -------------------------------------------------------------------\n\n"
    INFO_TEXT+="                   Aguardando conexão..."

    # Inicia o xterm. O script fica "preso" aqui enquanto o xterm estiver aberto.
    /usr/bin/xterm -fullscreen -fg white -bg black -fa 'DejaVu Sans Mono' -fs 16 -e "printf '%b' \"$INFO_TEXT\"; sleep infinity"

    # Se o xterm for fechado (pelo pfd-connect), o loop continua e o reinicia após 1s.
    sleep 1
done