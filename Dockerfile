FROM ghcr.io/openclaw/openclaw:latest

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
    && rm -rf /var/lib/apt/lists/*

# Instalar libs Python
RUN pip3 install --break-system-packages \
    selenium \
    playwright \
    beautifulsoup4 \
    requests \
    httpx \
    lxml \
    pandas \
    numpy

# Instalar libs Node.js
RUN mkdir -p /home/node/libs \
    && cd /home/node/libs \
    && npm init -y \
    && npm install cheerio puppeteer axios

# Instalar browsers do Playwright
RUN npx playwright install chromium --with-deps

# Permissões corretas
RUN chown -R node:node /home/node/libs

USER node
