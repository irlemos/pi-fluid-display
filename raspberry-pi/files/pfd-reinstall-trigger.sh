#!/bin/bash
# PiFluidDisplay - Gatilho de Reinstalação

set -e

# Caminhos para o sistema em execução
BOOT_PARTITION="/boot/firmware"
TRIGGER_FILE="$BOOT_PARTITION/reinstall.txt"
INSTALLER_SCRIPT="$BOOT_PARTITION/pi-fluid-display/install.sh"
LOG_FILE="$BOOT_PARTITION/pfd-reinstall-log.txt"

# Só executa se o arquivo de gatilho existir
if [ ! -f "$TRIGGER_FILE" ]; then
    exit 0
fi

# Inicia o processo de limpeza e reinstalação
exec > >(tee -a ${LOG_FILE}) 2>&1
echo "--- Gatilho de Reinstalação Detectado! ---"

echo "Limpando instalação anterior..."
systemctl disable --now idle-screen.service || true
rm -rf /home/pi/pi-fluid-display
rm -f /etc/systemd/system/idle-screen.service
rm -f /etc/sudoers.d/010_pfd-nopasswd
rm -f /etc/pfd_install_done
rm -f /etc/X11/xorg.conf.pfd

echo "Removendo o arquivo de gatilho..."
rm -f "$TRIGGER_FILE"

echo "Acionando o instalador original..."
$INSTALLER_SCRIPT

echo "Processo de reinstalação iniciado. O sistema será reiniciado pelo instalador."
exit 0