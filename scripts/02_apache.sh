#!/bin/bash
# Verificação e garantia de disponibilidade do Servidor Web Apache

LOG_FILE="/app/logs/apache.log"

verificar_apache() {
    echo "[INFO] Analisando o estado do servidor web Apache2..."
    
    if pgrep -x "apache2" > /dev/null; then
        echo "[OK] Apache2 em execução e pronto para receber requisições." | tee -a "$LOG_FILE"
    else
        echo "[AVISO] Apache2 inativo. Tentando restabelecer serviço..." | tee -a "$LOG_FILE"
        service apache2 start >> "$LOG_FILE" 2>&1
        
        if pgrep -x "apache2" > /dev/null; then
            echo "[SUCESSO] Apache2 reinicializado com êxito." | tee -a "$LOG_FILE"
        else
            echo "[ERRO] Falha crítica ao levantar o Apache2." | tee -a "$LOG_FILE"
            exit 1
        fi
    fi
}

verificar_modulos() {
    echo "[INFO] Validando módulos de proxy para o ecossistema Node.js..."
    if apache2ctl -M | grep -q "proxy_http_module"; then
        echo "[OK] Módulo de Proxy Reverso ativo."
    else
        echo "[AVISO] Módulo de Proxy desativado. Ajustando configurações..."
        a2enmod proxy proxy_http >> "$LOG_FILE" 2>&1
        service apache2 restart
    fi
}

verificar_apache
verificar_modulos
