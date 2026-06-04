#!/bin/bash
# Rotina de Backup

DIR_ORIGEM="/app/logs_gestao_projetos"
DIR_DESTINO="/app/backups"
DATA=$(date +"%Y%m%d_%H%M%S")
NOME_BACKUP="backup_logs_tarefas_$DATA.tar.gz"
LOG_FILE="/app/logs/backup.log"

echo "[INFO] Iniciando processo de backup..."

# Verifica se a pasta de origem existe
if [ ! -d "$DIR_ORIGEM" ]; then
    echo "[ERRO] O diretório $DIR_ORIGEM não existe. Execute a Opção 3 primeiro." | tee -a "$LOG_FILE"
    exit 1
fi

# Gera o arquivo compactado
tar -czf "$DIR_DESTINO/$NOME_BACKUP" "$DIR_ORIGEM" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "[SUCESSO] Backup gerado com sucesso: $NOME_BACKUP em $DIR_DESTINO" | tee -a "$LOG_FILE"
else
    echo "[ERRO] Falha ao gerar o backup." | tee -a "$LOG_FILE"
fi
