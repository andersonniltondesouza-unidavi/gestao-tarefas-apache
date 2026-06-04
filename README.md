# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno
Anderson Nilton de Souza

## Tema
Sistema de Gestão de Tarefas e Projetos

## Descrição do Projeto
O cenário simulado neste projeto é a implantação de uma infraestrutura web completa para uma aplicação de gestão de tarefas. O ambiente simula um servidor de produção onde um servidor web Apache opera como Proxy Reverso, recebendo as requisições externas e encaminhando-as de forma segura para uma API a rodar em Node.js, que por sua vez persiste os dados num banco de dados PostgreSQL.

Este projeto relaciona-se diretamente com os conceitos de Cloud Computing porque utiliza a conteinerização (Docker) para isolar serviços, garantindo que a aplicação corra da mesma forma em qualquer ambiente. Além disso, a automatização de rotinas (como backups e deploys) via Shell Script simula práticas de DevOps essenciais na nuvem, e a publicação da imagem no DockerHub demonstra a base da entrega contínua (CD) em ambientes Cloud-Native.

## Tecnologias Utilizadas
- Ubuntu
- Docker
- Docker Compose
- Apache
- Shell Script
- GitHub
- DockerHub
- Node.js
- PostgreSQL
- HTML
- CSS

## Estrutura do Projeto
A organização do repositório foi pensada para separar o código da aplicação da infraestrutura:

* **`/scripts/`**: Contém todos os ficheiros em Shell Script responsáveis por automatizar a administração do servidor (menu e rotinas 01 a 09).
* **`/source/`**: Código-fonte da aplicação, contendo o backend (Node.js) e o frontend (HTML/CSS/JS).
* **`/logs/` e `/logs_gestao_projetos/`**: Diretórios dinâmicos onde os scripts e a aplicação guardam os seus registos de auditoria e histórico de atividades.
* **`/backups/`**: Pasta isolada para armazenar as cópias de segurança compactadas geradas pelo sistema.
* **`/evidencias/`**: Pasta contendo todas as capturas de ecrã que comprovam o funcionamento prático do ambiente.
* **`docker-compose.yml` e `Dockerfile`**: Ficheiros de infraestrutura como código (IaC) que constroem a rede, os volumes e as imagens dos contentores.

## Como Executar

Para subir a infraestrutura e aceder à aplicação, utilize os comandos abaixo na raiz do projeto:

```bash
docker compose up -d --build
```

Para aceder ao terminal do servidor Linux e executar o painel de automatização:

```bash
docker exec -it -w trabalho03-linux bash
```
*(Após entrar no conteiner, basta digitar `./scripts/menu.sh`)*

## Scripts Disponíveis

| Script | Descrição |
|---|---|
| 01_update.sh | Atualiza pacotes do sistema e repositórios do Ubuntu |
| 02_apache.sh | Ativa módulos (mod_proxy) e valida o Apache como Proxy Reverso |
| 03_estrutura.sh | Cria diretórios do projeto e provisiona ficheiros de log |
| 04_backup.sh | Realiza o backup compactado (.tar.gz) dos logs e ficheiros críticos |
| 05_deploy.sh | Publica os ficheiros do frontend no diretório de produção do Apache |
| 06_processos.sh | Gere processos e verifica os serviços a rodar em background |
| 07_monitoramento.sh | Monitoriza o consumo de disco, memória RAM e estado vital do Apache |
| 08_usuarios_permissoes.sh | Configura utilizadores, cria o grupo pm_ops e aplica políticas RBAC |
| 09_relatorio.sh | Gera um relatório operacional consolidado sobre a saúde do servidor |
| menu.sh | Menu principal interativo para navegação entre os scripts |

## Evidências
As evidências de funcionamento (prints do terminal, sistema a correr, logs e criação de pastas) estão armazenadas na pasta **[`/evidencias`](./evidencias)** na raiz deste repositório.

## DockerHub
A imagem Docker do servidor Ubuntu customizado com a nossa aplicação foi publicada no DockerHub para facilitar a distribuição. Pode ser descarregada com o comando `docker pull` através do link abaixo:

**Link da Imagem:** [https://hub.docker.com/repository/docker/andersonsouza23/gestao-tarefas-linux]

## Uso de IA
Utilizei ferramentas de Inteligência Artificial para me auxiliar na resolução de problemas de infraestrutura e otimização de sintaxe no Bash. Em vez de simplesmente copiar o código, usei a IA como um "tutor" para entender por que o Docker estava a reter senhas antigas em volumes em cache e para me guiar na resolução de conflitos de versionamento no Git na hora de fazer o push para o repositório remoto. Todos os scripts foram testados linha a linha localmente, validados dentro do container e ajustados manualmente para atender aos requisitos deste trabalho.

## Dificuldades Encontradas
1. **Conflito de Volumes no Docker (PostgreSQL):** Enfrentei um erro de autenticação (`password authentication failed for user "postgres"`) porque o Docker Compose estava a reutilizar um volume local antigo. Aprendi que o Postgres só define a senha na primeira execução do volume, precisando rodar um `docker compose down -v` para limpar a estrutura antes de recriá-la.
2. **Conflito no Envio (Push) para o GitHub:** Como iniciei o repositório remotamente e localmente ao mesmo tempo, gerou um conflito de histórico (o erro `fetch first`). Resolvi o problema entendendo como usar a tag `--force` no Git, garantindo que a versão local correta substituísse a versão vazia do repositório.
