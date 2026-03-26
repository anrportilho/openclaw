FROM ghcr.io/openclaw/openclaw:2026.3.23

USER root

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libnspr4 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxext6 \
    libxshmfence1 \
    python3 \
    python3-pip \
    wget \
    curl \
    unzip \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Instalar libs Python globalmente
RUN pip3 install --break-system-packages \
    selenium \
    playwright \
    beautifulsoup4 \
    requests \
    httpx \
    lxml \
    pandas \
    numpy \
    && chmod -R 755 /usr/local/lib/python3.11/dist-packages

# Instalar browsers do Playwright e tornar acessível para todos
RUN playwright install chromium --with-deps \
    && mkdir -p /home/node/.cache \
    && cp -r /root/.cache/ms-playwright /home/node/.cache/ \
    && chown -R node:node /home/node/.cache/ms-playwright \
    && chmod -R 755 /root/.cache/ms-playwright

# Instalar libs Node.js em diretório separado (não sobrescrever /app)
RUN mkdir -p /home/node/libs \
    && cd /home/node/libs \
    && npm init -y \
    && npm install cheerio puppeteer axios \
    && chown -R node:node /home/node/libs

# Permissões corretas
RUN mkdir -p /home/node/.openclaw \
    && chown -R node:node /home/node/.openclaw \
    && chown -R node:node /home/node/libs 2>/dev/null || true

# Sudo sem senha para node
RUN echo "node ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/node \
    && chmod 0440 /etc/sudoers.d/node

# Variável de ambiente para o playwright encontrar os browsers
ENV PLAYWRIGHT_BROWSERS_PATH=/root/.cache/ms-playwright

USER node
