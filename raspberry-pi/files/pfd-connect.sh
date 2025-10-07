#!/bin/bash
# Script de conexão chamado via SSH. Opera dentro da sessão X existente.

# Recebe o IP do controlador como primeiro argumento
PC_HOSTNAME=$1

if [ -z "$PC_HOSTNAME" ]; then
    exit 1
fi

# Exporta a variável de display para garantir que os comandos gráficos encontrem a sessão X correta
export DISPLAY=:0

# 1. "Mata" o processo do xterm (a tela de espera) para liberar a tela.
pkill xterm

# Aguarda um momento para a tela limpar
sleep 1

# 2. Inicia o cliente VNC (TigerVNC) diretamente na sessão X que já está ativa.
/usr/bin/vncviewer -fullscreen "$PC_HOSTNAME"

# Ao finalizar, o loop no 'pfd-idle.sh' automaticamente reiniciará o xterm.