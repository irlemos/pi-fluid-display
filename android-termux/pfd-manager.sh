#!/bin/bash
clear

# --- CONFIGURACAO ---
PI_IP=""
PI_USER="pi"
SSH_PASSWORD=""
# --- FIM DA CONFIGURACAO ---

echo "--- PiFluidDisplay Manager (Android) ---"
echo ""

# --- Obter informacoes ---
if [ -z "$PI_IP" ]; then read -p "[1 de 3] Digite o IP do Raspberry Pi: " PI_IP; fi
if [ -z "$PI_IP" ]; then echo "IP do Pi nao fornecido. Saindo."; exit 1; fi

if [ -z "$SSH_PASSWORD" ]; then read -s -p "[2 de 3] Digite a senha do usuario '$PI_USER' no Pi: " SSH_PASSWORD; echo ""; fi
if [ -z "$SSH_PASSWORD" ]; then echo "Senha do SSH nao fornecida. Saindo."; exit 1; fi

# Detecta o IP do Android a partir da saida completa do 'ifconfig' (android sem root)
echo "[3 de 3] Detectando IP do Android..."
ANDROID_IP=$(ifconfig | awk '/wlan0/ {found=1; next} found && /inet / {print $2; exit}' | tail -n 1)

if [ -z "$ANDROID_IP" ]; then
    echo "ERRO: Nao foi possivel encontrar o IP da interface wlan0."
    exit 1
fi
echo "IP do Android detectado: $ANDROID_IP"

# --- Comandar o Pi ---
echo ""
echo "Enviando comando para $PI_IP se conectar a $ANDROID_IP..."

# Usa o sshpass para fornecer a senha do Pi de forma nao-interativa
sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no -t "$PI_USER@$PI_IP" "/home/pi/pi-fluid-display/pfd-connect.sh '$ANDROID_IP'"

echo ""
echo "Conexao encerrada."