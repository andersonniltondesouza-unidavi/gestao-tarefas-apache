#!/bin/bash
# Configuração de Usuários e Permissões

GRUPO="pm_ops"
USUARIO="scrum_master"
PASTA_ALVO="/app/logs_gestao_projetos"
LOG_FILE="/app/logs/seguranca.log"

echo "[INFO] Iniciando configuração de segurança..." | tee -a "$LOG_FILE"

# Verifica se a pasta existe antes de aplicar permissões
if [ ! -d "$PASTA_ALVO" ]; then
    echo "[ERRO] A pasta $PASTA_ALVO não existe. Execute a Opção 3 primeiro." | tee -a "$LOG_FILE"
    exit 1
fi

# 1. Criar grupo se não existir
if ! getent group "$GRUPO" > /dev/null 2>&1; then
    groupadd "$GRUPO"
    echo "[OK] Grupo '$GRUPO' criado com sucesso." | tee -a "$LOG_FILE"
else
    echo "[INFO] O grupo '$GRUPO' já existe." | tee -a "$LOG_FILE"
fi

# 2. Criar usuário se não existir e adicionar ao grupo
if ! id -u "$USUARIO" > /dev/null 2>&1; then
    useradd -m -g "$GRUPO" -s /bin/bash "$USUARIO"
    echo "[OK] Usuário '$USUARIO' criado e adicionado ao grupo '$GRUPO'." | tee -a "$LOG_FILE"
else
    echo "[INFO] O usuário '$USUARIO' já existe." | tee -a "$LOG_FILE"
fi

# 3. Aplicar permissões estritas na pasta alvo
chown -R "$USUARIO:$GRUPO" "$PASTA_ALVO"
chmod -R 770 "$PASTA_ALVO"

echo "[OK] Permissões aplicadas: Dono '$USUARIO', Grupo '$GRUPO', Acesso restrito 770 na pasta '$PASTA_ALVO'." | tee -a "$LOG_FILE"
echo -e "\n[SUCESSO] Configuração de segurança finalizada com sucesso!" | tee -a "$LOG_FILE"
