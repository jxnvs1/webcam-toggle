#!/usr/bin/env bash
#####################################################################
# Script para Ativar ou Desativar a Webcam Interna do Laptop
# Autor: Jonas Santana
# Descrição: Este script permite ativar ou desativar a webcam interna
# do laptop, com base nas preferências do usuário. Ele também oferece
# um tutorial para identificar a webcam e mantém um log para facilitar
# futuras alterações.
#####################################################################

LOG_FILE="/var/log/webcam_toggle.log"
RULE_FILE="/etc/udev/rules.d/40-disable-internal-webcam.rules"

# Verifica se é executado como root
[ $UID -ne 0 ] && { echo "Este script precisa ser executado como root."; exit 1; }

# Exibe tutorial para identificar a webcam
function tutorial_identificacao() {
    echo "=== Tutorial para identificar a Webcam ==="
    echo "1. Execute o comando abaixo para listar os dispositivos USB conectados:"
    echo "   lsusb"
    echo "2. Procure pela linha correspondente à sua webcam."
    echo "   Exemplo: Bus 001 Device 002: ID 2232:1069 Webcam XYZ"
    echo "3. Copie o 'idVendor' e o 'idProduct' (Exemplo: 2232 e 1069)."
    echo "4. Cole esses valores quando solicitado pelo script."
    echo "=========================================="
}

# Grava no log
function registrar_log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Ativa a webcam
function ativar_webcam() {
    if [ ! -e "$RULE_FILE" ]; then
        echo "Nenhuma regra encontrada. A webcam já está ativada."
        registrar_log "Tentativa de ativar a webcam, mas nenhuma regra encontrada."
        exit 0
    fi

    # Remove a regra e recarrega as configurações do UDEV
    rm "$RULE_FILE"
    udevadm control --reload-rules
    udevadm trigger

    echo "Webcam ativada com sucesso."
    registrar_log "Webcam ativada."
}

# Desativa a webcam
function desativar_webcam() {
    if [ -e "$RULE_FILE" ]; then
        echo "A regra já existe. A webcam já está desativada."
        registrar_log "Tentativa de desativar a webcam, mas regra já existente."
        exit 0
    fi

    # Solicita idVendor e idProduct ao usuário
    echo "Digite o ID do fabricante (idVendor):"
    read idVendor
    echo "Digite o ID do produto (idProduct):"
    read idProduct

    # Cria a regra e recarrega as configurações do UDEV
    cat <<EOF > "$RULE_FILE"
ATTRS{idVendor}=="$idVendor", ATTRS{idProduct}=="$idProduct", RUN="/bin/sh -c 'echo 0 >/sys/\$devpath/authorized'"
EOF

    udevadm control --reload-rules
    udevadm trigger

    echo "Webcam desativada com sucesso."
    registrar_log "Webcam desativada (idVendor=$idVendor, idProduct=$idProduct)."
}

# Menu principal
if [ -e "$RULE_FILE" ]; then
    echo "A webcam está atualmente desativada."
    echo "O que você deseja fazer?"
    echo "1. Ativar a webcam"
    echo "2. Sair"
    read opcao

    case $opcao in
        1) ativar_webcam ;;
        2) echo "Saindo..."; exit 0 ;;
        *) echo "Opção inválida. Saindo..."; exit 1 ;;
    esac
else
    echo "A webcam está atualmente ativada."
    echo "O que você deseja fazer?"
    echo "1. Desativar a webcam"
    echo "2. Mostrar tutorial de identificação"
    echo "3. Sair"
    read opcao

    case $opcao in
        1) desativar_webcam ;;
        2) tutorial_identificacao ;;
        3) echo "Saindo..."; exit 0 ;;
        *) echo "Opção inválida. Saindo..."; exit 1 ;;
    esac
fi
