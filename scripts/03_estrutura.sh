#!/bin/bash
# Provisionamento da pasta de logs da aplicação

BASE_DIR="/app/logs_gestao_projetos"
LOG_FILE="/app/logs/estrutura.log"

echo "[INFO] Iniciando provisionamento do diretório de logs da aplicação..."

# Cria a pasta de logs de gestão
mkdir -p "$BASE_DIR"
echo "[OK] Diretório base '$BASE_DIR' criado." | tee -a "$LOG_FILE"

# Provisiona o arquivo de log de atividades com permissão global para a API escrever
touch "$BASE_DIR/historico_atividades.log"
chmod 666 "$BASE_DIR/historico_atividades.log"
echo "[OK] Arquivo 'historico_atividades.log' provisionado com sucesso." | tee -a "$LOG_FILE"

echo -e "\n[SUCESSO] Estrutura provisionada!" | tee -a "$LOG_FILE"
