#!/bin/bash
# Pipeline de Deploy Contínuo para o Frontend da Aplicação de Tarefas

ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG_FILE="/app/logs/deploy.log"

limpar_ambiente_antigo() {
    echo "[INFO] Limpando diretórios estáticos anteriores no Apache..."
    rm -rf "${DESTINO:?}"/*
}

publicar_artefatos() {
    echo "[INFO] Copiando arquivos originais da aplicação para produção..."
    if cp -r "$ORIGEM"/* "$DESTINO/"; then
        echo "[SUCESSO] Artefatos de interface publicados em: $(date)" >> "$LOG_FILE"
    else
        echo "[ERRO] Falha ao transferir arquivos de interface para $DESTINO" | tee -a "$LOG_FILE"
        exit 1
    fi
}

validar_entrega() {
    echo "[INFO] Auditando integridade do deploy..."
    if [ -f "$DESTINO/index.html" ] && [ -f "$DESTINO/app.js" ]; then
        echo "[OK] Interface web e scripts clientes validados com sucesso."
        echo -e "\n--- Estrutura Publicada no Servidor ---"
        ls -la "$DESTINO"
    else
        echo "[ERRO] Falha na validação: Arquivos base ausentes no destino." | tee -a "$LOG_FILE"
    fi
}

limpar_ambiente_antigo
publicar_artefatos
validar_entrega
