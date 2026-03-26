FROM ghcr.io/openclaw/openclaw:2026.3.23

USER root

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libnspr4 libnss3 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 \
    libasound2 libpango-1.0-0 libcairo2 \
    libx11-6 libx11-xcb1 libxcb1 libxext6 libxshmfence1 \
    python3 python3-pip wget curl unzip git sudo \
    && rm -rf /var/lib/apt/lists/*

# Instalar libs Python globalmente (como root)
RUN pip3 install --break-system-packages \
    selenium playwright beautifulsoup4 \
    requests httpx lxml pandas numpy

# Instalar browsers do Playwright globalmente
RUN playwright install chromium --with-deps

# Instalar libs Node.js globalmente
RUN cd /app && npm install cheerio puppeteer axios

# Permissões
RUN mkdir -p /home/node/.openclaw \
    && chown -R node:node /home/node/.openclaw

# Sudo sem senha para node
RUN echo "node ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/node \
    && chmod 0440 /etc/sudoers.d/node

USER node
