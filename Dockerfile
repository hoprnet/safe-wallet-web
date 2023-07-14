FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat git python3 build-base

WORKDIR /app

# Install dependencies based on the preferred package manager
COPY tsconfig.json package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
COPY src ./src
COPY scripts ./scripts

RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi && \
  npx browserslist@latest --update-db

# Rebuild the source code only when needed
FROM base AS builder

WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# need to set placeholders for env vars which we want to overwrite at startup of
# the container
RUN \
  yarn postinstall && \
  env NEXT_PUBLIC_IS_PRODUCTION=true \
      NEXT_PUBLIC_GATEWAY_URL_STAGING=APP_NEXT_PUBLIC_GATEWAY_URL_STAGING \
      NEXT_PUBLIC_GATEWAY_URL_PRODUCTION=APP_NEXT_PUBLIC_GATEWAY_URL_PRODUCTION \
   yarn build

FROM base AS runner

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

WORKDIR /app

COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --chown=nextjs:nodejs ./docker/entrypoint.sh ./entrypoint.sh

RUN \
  mv server.js server.cjs && \
  chown nextjs:nodejs /app

USER nextjs

EXPOSE 8080
ENV PORT 8080
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

ENTRYPOINT ["/app/entrypoint.sh"]

#CMD ["npx", "next", "start", "-p", "8080"]
#CMD ["node", "server.cjs"]
