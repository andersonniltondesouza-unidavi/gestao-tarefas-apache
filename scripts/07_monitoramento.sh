#!/bin/bash
# Coleta e analise de metricas de performance do servidor de projetos

LOG_FILE="/app/logs/monitoramento.log"
DATA_COLETA=$(date "+%Y-%m-%d %H:%M:%S")

coletar_metricas() {
    echo "=== Coleta realizada em: $DATA_COLETA ===" >> "$LOG_FILE"
    
    # Extrai o percentual de uso usando awk
    USO_DISCO=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    USO_RAM=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    USO_CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d. -f1)

    echo "[INFO] Analisando recursos de infraestrutura..."
    
    # Validacao de alertas de hardware
    if [ "$USO_CPU" -gt 80 ]; then
        echo "[ALERTA] Uso de CPU elevado: ${USO_CPU}%" | tee -a "$LOG_FILE"
    else
        echo "[OK] CPU dentro do limite operacional: ${USO_CPU}%"
    fi

    if [ "$USO_RAM" -gt 80 ]; then
        echo "[ALERTA] Uso de memoria RAM acima do esperado: ${USO_RAM}%" | tee -a "$LOG_FILE"
    else
        echo "[OK] Memoria RAM estavel: ${USO_RAM}%"
    fi

    if [ "$USO_DISCO" -gt 80 ]; then
        echo "[ALERTA] Espaco em disco critico: ${USO_DISCO}%" | tee -a "$LOG_FILE"
    else
        echo "[OK] Armazenamento seguro: ${USO_DISCO}%"
    fi
}

verificar_servico_web() {
    if pgrep -x "apache2" > /dev/null; then
        echo "[OK] Apache em execucao" | tee -a "$LOG_FILE"
    else
        echo "[ALERTA] Servidor Web Apache esta offline ou travado!" | tee -a "$LOG_FILE"
    fi
}

coletar_metricas
verificar_servico_web
