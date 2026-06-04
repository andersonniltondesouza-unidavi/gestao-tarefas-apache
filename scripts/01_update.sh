#!/bin/bash
# Script responsável por garantir que o SO do servidor esteja em dia

LOG_FILE="../logs/update.log"

atualizar_sistema() {
    echo "[INFO] Iniciando rotina de atualizacao do servidor..."
    echo "Data da execucao: $(date)" >> "$LOG_FILE"
    
    # Atualiza repositorios e pacotes
    if apt-get update && apt-get upgrade -y >> "$LOG_FILE" 2>&1; then
        echo "[SUCESSO] Servidor atualizado sem erros."
    else
        echo "[ERRO] Falha ao tentar atualizar o sistema. Verifique o log em $LOG_FILE"
    fi
}

atualizar_sistema
