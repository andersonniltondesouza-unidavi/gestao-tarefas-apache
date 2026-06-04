#!/bin/bash
# Utilitario de administracao e monitoria de processos do sistema

listar_processos() {
    echo -e "\n--- Processos Ativos no Sistema (Top 15 por CPU) ---"
    ps -aux --sort=-%cpu | head -n 15
}

buscar_processo() {
    local termo="$1"
    if [ -z "$termo" ]; then
        echo "[AVISO] Informe uma palavra-chave para a busca. Ex: $0 buscar apache"
        return
    fi
    echo -e "\n--- Resultados para a busca: '$termo' ---"
    ps -aux | grep -i "$termo" | grep -v "grep"
}

matar_processo() {
    local pid="$1"
    # Impede a execucao caso o operador nao passe o PID por seguranca
    if [ -z "$pid" ]; then
        echo "[ERRO SEGUURANCA] Operacao cancelada. E obrigatorio passar o PID do processo."
        echo "Exemplo de uso: $0 matar 1234"
        return
    fi

    echo "[PERIGO] Tentando encerrar o processo de PID: $pid..."
    if kill -9 "$pid" 2>/dev/null; then
        echo "[SUCESSO] Processo $pid finalizado."
    else
        echo "[ERRO] Nao foi possivel encerrar o processo $pid. Verifique as permissoes ou se o PID existe."
    fi
}

# Direcionamento de fluxo com base nos argumentos de linha de comando
ACAO="$1"
PARAMETRO="$2"

case "$ACAO" in
    listar)         listar_processos ;;
    buscar)         buscar_processo "$PARAMETRO" ;;
    matar)          matar_processo "$PARAMETRO" ;;
    *)              echo "Uso: $0 {listar|buscar <nome>|matar <PID>}" ;;
esac
