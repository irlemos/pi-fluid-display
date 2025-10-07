#!/bin/bash
# PiFluidDisplay - Instalador Automático
set -e

# --- Detecção de Caminho e Configuração de Log ---
SCRIPT_PATH=$(readlink -f "$0")
SRC_DIR=$(dirname "$SCRIPT_PATH")
FLAG_FILE="/etc/pfd_install_done"
LOG_FILE="$SRC_DIR/pfd-install-log.txt"
DEST_DIR="/home/pi/pi-fluid-display"
CONFIG_FILE="$SRC_DIR/pfd-config.txt"
exec > >(tee -a ${LOG_FILE}) 2>&1
echo "--- Iniciando Instalação do PiFluidDisplay ---"

# --- Verificações Iniciais ---
if [ -f "$FLAG_FILE" ]; then echo "Instalação já realizada. Saindo."; exit 0; fi
if [ "$(id -u)" -ne 0 ]; then echo "Este script precisa ser executado como root."; exit 1; fi

# --- Passo 1: Instalação de Pacotes ---
echo "[1/9] Atualizando e instalando dependências..."
apt-get update
apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox tigervnc-viewer avahi-daemon raspberrypi-ui-mods xterm

# --- Passo 2: Cópia de Arquivos ---
echo "[2/9] Copiando arquivos de projeto..."
mkdir -p "$DEST_DIR"
cp -r "$SRC_DIR/files"/* "$DEST_DIR/"
cp "$DEST_DIR/idle-screen.service" "/etc/systemd/system/"
cp "$DEST_DIR/xorg.conf.pfd" "/etc/X11/"

# --- Passo 3: Configuração Personalizada ---
echo "[3/9] Lendo arquivo de configuração..."
if [ -f "$CONFIG_FILE" ]; then
    # Copia o arquivo de configuração para o diretório de destino
    cp "$CONFIG_FILE" "$DEST_DIR/"
    source "$CONFIG_FILE"
    echo "Configurando hostname para: $HOSTNAME"
    raspi-config nonint do_hostname "$HOSTNAME"
else
    echo "AVISO: Arquivo 'pfd-config.txt' não encontrado. Usando configurações padrão."
fi

# --- Passo 4: Permissões ---
echo "[4/9] Definindo permissões..."
chown -R pi:pi "$DEST_DIR"
chmod +x "$DEST_DIR"/*.sh
usermod -a -G video,input pi

# --- Passo 5: Instalação do Mecanismo de Reinstalação ---
echo "[5/9] Instalando o gatilho de reinstalação..."
cp "$DEST_DIR/pfd-reinstall-trigger.sh" "/usr/local/bin/"
chmod +x "/usr/local/bin/pfd-reinstall-trigger.sh"
cp "$DEST_DIR/pfd-reinstall-check.service" "/etc/systemd/system/"

# --- Passo 6: Configuração de Boot ---
echo "[6/9] Configurando o boot para modo gráfico..."
systemctl set-default graphical.target
systemctl disable getty@tty1.service

# --- Passo 7: Habilitação dos Serviços ---
echo "[7/9] Habilitando serviços..."
systemctl daemon-reload
systemctl enable idle-screen.service
systemctl enable pfd-reinstall-check.service

# --- Passo 8: Limpeza do Gatilho de Boot ---
echo "[8/9] Limpando o gatilho de inicialização..."
touch "$FLAG_FILE"
CMDLINE_PATH="/boot/firmware/cmdline.txt"
if [ -f "$CMDLINE_PATH" ]; then
    sed -i 's/ init=\/boot\/pi-fluid-display\/install.sh//' "$CMDLINE_PATH"
fi

# --- Passo 9: Finalização ---
echo "[9/9] Instalação Concluída! Reiniciando em 5 segundos..."
sleep 5
reboot