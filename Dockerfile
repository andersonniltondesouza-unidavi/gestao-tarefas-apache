FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalação das dependências
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get update && apt-get install -y \
    apache2 \
    curl \
    gnupg \
    procps \
    iptables \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Habilita módulos do Apache
RUN a2enmod proxy proxy_http rewrite

# Configuração da estrutura de diretorios
RUN mkdir -p /app/scripts /app/source /app/logs /app/backups /app/logs_gestao_projetos /app/backend

WORKDIR /app/backend

# Copia dependências e instala
COPY package.json ./
RUN npm install

# Copia o backend
COPY server.js ./

# Configuração do Apache
RUN printf "<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    ProxyPass /api http://localhost:3000/api\n\
    ProxyPassReverse /api http://localhost:3000/api\n\
    ErrorLog /app/logs/apache_error.log\n\
    CustomLog /app/logs/apache_access.log combined\n\
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

EXPOSE 80

# Inicia os serviços em background
CMD service apache2 start && node server.js
