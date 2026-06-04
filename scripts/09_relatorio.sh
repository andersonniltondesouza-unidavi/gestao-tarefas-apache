#!/bin/bash
# Relatório de Auditoria e Estado do Servidor

# 1. DECLARAÇÃO DA VARIÁVEL
RELATORIO="/app/logs/relatorio_execucao.txt"

echo "[INFO] A gerar o relatório de auditoria..."

# 2. GERAÇÃO DO CABEÇALHO
echo "==================================================" > "$RELATORIO"
echo "      RELATORIO OPERACIONAL                       " >> "$RELATORIO"
echo "==================================================" >> "$RELATORIO"
echo "Data/Hora de Emissao : $(date +'%Y-%m-%d %H:%M:%S')" >> "$RELATORIO"
echo "Aluno(a)             : ANDERSON NILTON DE SOUZA" >> "$RELATORIO"
echo "Matricula            : 1031186" >> "$RELATORIO"
echo "Disciplina           : CLOUD COMPUTING" >> "$RELATORIO"
echo "Tema                 : Gestao de Tarefas e Projetos" >> "$RELATORIO"
echo "==================================================" >> "$RELATORIO"
echo "" >> "$RELATORIO"

# 3. STATUS DO SERVIDOR WEB
echo "[STATUS DO SERVIDOR WEB]" >> "$RELATORIO"
if service apache2 status | grep -q "is running"; then
    echo "Apache2 a correr normalmente." >> "$RELATORIO"
else
    echo "Apache2 parado ou com erro." >> "$RELATORIO"
fi
echo "" >> "$RELATORIO"

# 4. USO DE ESPAÇO EM DISCO
echo "[USO DE ESPACO EM DISCO]" >> "$RELATORIO"
df -h | grep -E "^Filesystem|/$|overlay" >> "$RELATORIO"
echo "" >> "$RELATORIO"

# 5. VOLUMES E DIRETÓRIOS ATIVOS
echo "[VOLUMES E DIRETORIOS ATIVOS]" >> "$RELATORIO"
if [ -d "/app/logs_gestao_projetos" ]; then
    ls -la /app/logs_gestao_projetos >> "$RELATORIO"
else
    echo "Nenhuma estrutura criada ainda." >> "$RELATORIO"
fi
echo "" >> "$RELATORIO"

# 6. ÚLTIMOS BACKUPS GERADOS
echo "[ULTIMOS BACKUPS GERADOS]" >> "$RELATORIO"
if ls /app/backups/*.tar.gz 1> /dev/null 2>&1; then
    ls -la /app/backups/*.tar.gz >> "$RELATORIO"
else
    echo "Nenhum backup encontrado." >> "$RELATORIO"
fi
echo "" >> "$RELATORIO"

# 7. HISTÓRICO RECENTE DE LOGS
echo "[HISTORICO RECENTE DE LOGS]" >> "$RELATORIO"
ls -la /app/logs/*.log 2>/dev/null >> "$RELATORIO"
echo "" >> "$RELATORIO"

# 8. PERMISSÕES E UTILIZADORES DA APLICAÇÃO
echo "[PERMISSOES E USUARIOS DA APLICACAO]" >> "$RELATORIO"
grep "pm_ops" /etc/group >> "$RELATORIO" 2>/dev/null || echo "Grupo pm_ops nao encontrado." >> "$RELATORIO"
grep "scrum_master" /etc/passwd >> "$RELATORIO" 2>/dev/null || echo "Usuario scrum_master nao encontrado." >> "$RELATORIO"

echo "[SUCESSO] Relatorio gerado com exito em: $RELATORIO"
