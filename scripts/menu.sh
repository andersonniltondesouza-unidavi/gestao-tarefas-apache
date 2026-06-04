#!/bin/bash
# Painel Central de Operacoes e Gerenciamento

exibir_menu() {
    clear
    echo "=========================================================="
    echo " Criado por: Anderson Nilton de Souza"
    echo " Instituicao: Unidavi"
    echo " Tema: Gestao de Tarefas e Projetos"
    echo "=========================================================="
    echo "                MENU DEVOPS CLOUD"
    echo "=========================================================="
    echo " [1] Atualizar sistema"
    echo " [2] Instalar/Verificar Apache"
    echo " [3] Criar estrutura do projeto"
    echo " [4] Realizar backup"
    echo " [5] Fazer deploy"
    echo " [6] Ver processos ativos"
    echo " [7] Monitorar sistema"
    echo " [8] Configurar usuarios e permissoes"
    echo " [9] Gerar relatorio"
    echo " [0] Sair"
    echo "=========================================================="
    echo -n "Escolha uma opcao operacional: "
}

aguardar_usuario() {
    echo -e "\nPressione [ENTER] para retornar ao menu principal..."
    read -r
}

# Loop infinito para manter a execucao ate o comando de saida
while true; do
    exibir_menu
    read -r OPCAO
    
    case "$OPCAO" in
        1)  ./01_update.sh; aguardar_usuario ;;
        2)  ./02_apache.sh; aguardar_usuario ;;
        3)  ./03_estrutura.sh; aguardar_usuario ;;
        4)  ./04_backup.sh; aguardar_usuario ;;
        5)  ./05_deploy.sh; aguardar_usuario ;;
        6)  ./06_processos.sh listar; aguardar_usuario ;;
        7)  ./07_monitoramento.sh; aguardar_usuario ;;
        8)  ./08_usuarios_permissoes.sh; aguardar_usuario ;;
        9)  ./09_relatorio.sh; aguardar_usuario ;;
        0)  echo -e "\nEncerrando terminal..."; exit 0 ;;
        *)  echo -e "\n[ERRO] Opcao invalida!"; sleep 1.5 ;;
    esac
done
