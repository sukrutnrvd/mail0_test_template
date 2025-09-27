FROM node:20-bookworm-slim


RUN apt-get update \
  && apt-get install -y --no-install-recommends git openssl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

RUN git clone https://github.com/Mail-0/Zero.git ./

RUN pnpm install

RUN set -eux; \
  cat > /docker-entrypoint.sh <<'EOS' \
  && chmod +x /docker-entrypoint.sh
#!/usr/bin/env sh
set -eu

# -------- Varsayılanlar (env verilmezse bunlar kullanılır)
: "${VITE_PUBLIC_APP_URL:=http://localhost:3000}"
: "${VITE_PUBLIC_BACKEND_URL:=http://localhost:8787}"

: "${DATABASE_URL:=postgresql://postgres:postgres@localhost:5432/zerodotemail}"

: "${BETTER_AUTH_SECRET:=my-better-auth-secret}"
: "${BETTER_AUTH_URL:=http://localhost:3000}"

: "${COOKIE_DOMAIN:=localhost}"

: "${GOOGLE_CLIENT_ID:=}"
: "${GOOGLE_CLIENT_SECRET:=}"

: "${REDIS_URL:=http://localhost:8079}"
: "${REDIS_TOKEN:=upstash-local-token}"

: "${RESEND_API_KEY:=}"

: "${OPENAI_API_KEY:=}"
: "${PERPLEXITY_API_KEY:=}"

: "${OPENAI_MODEL:=}"
: "${OPENAI_MINI_MODEL:=}"

: "${AI_SYSTEM_PROMPT:=}"

: "${NODE_ENV:=development}"

: "${AUTUMN_SECRET_KEY:=}"

: "${TWILIO_ACCOUNT_SID:=}"
: "${TWILIO_AUTH_TOKEN:=}"
: "${TWILIO_PHONE_NUMBER:=}"

: "${PLAYWRIGHT_SESSION_TOKEN:=}"
: "${PLAYWRIGHT_SESSION_DATA:=}"
: "${EMAIL:=}"

# -------- .env dosyasını üret
cat > .env <<ENVFILE
VITE_PUBLIC_APP_URL=${VITE_PUBLIC_APP_URL}
VITE_PUBLIC_BACKEND_URL=${VITE_PUBLIC_BACKEND_URL}

DATABASE_URL=${DATABASE_URL}

BETTER_AUTH_SECRET=${BETTER_AUTH_SECRET}
BETTER_AUTH_URL=${BETTER_AUTH_URL}

COOKIE_DOMAIN=${COOKIE_DOMAIN}

GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}

REDIS_URL=${REDIS_URL}
REDIS_TOKEN=${REDIS_TOKEN}

RESEND_API_KEY=${RESEND_API_KEY}

OPENAI_API_KEY=${OPENAI_API_KEY}
PERPLEXITY_API_KEY=${PERPLEXITY_API_KEY}

OPENAI_MODEL=${OPENAI_MODEL}
OPENAI_MINI_MODEL=${OPENAI_MINI_MODEL}

AI_SYSTEM_PROMPT=${AI_SYSTEM_PROMPT}

NODE_ENV=${NODE_ENV}

AUTUMN_SECRET_KEY=${AUTUMN_SECRET_KEY}

TWILIO_ACCOUNT_SID=${TWILIO_ACCOUNT_SID}
TWILIO_AUTH_TOKEN=${TWILIO_AUTH_TOKEN}
TWILIO_PHONE_NUMBER=${TWILIO_PHONE_NUMBER}

PLAYWRIGHT_SESSION_TOKEN=${PLAYWRIGHT_SESSION_TOKEN}
PLAYWRIGHT_SESSION_DATA=${PLAYWRIGHT_SESSION_DATA}
EMAIL=${EMAIL}
ENVFILE

pnpm db:push
exec pnpm dev
EOS

EXPOSE 3000
EXPOSE 8787

# Varsayılan komut
CMD ["/docker-entrypoint.sh"]
