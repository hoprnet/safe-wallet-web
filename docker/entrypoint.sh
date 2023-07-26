#!/bin/sh

set -Eeo pipefail

# set defaults for supported variables
NEXT_PUBLIC_IS_PRODUCTION="${NEXT_PUBLIC_IS_PRODUCTION:-"true"}"
NEXT_PUBLIC_GATEWAY_URL_STAGING="${NEXT_PUBLIC_GATEWAY_URL_STAGING:-"localhost:8080"}"
NEXT_PUBLIC_GATEWAY_URL_PRODUCTION="${NEXT_PUBLIC_GATEWAY_URL_PRODUCTION:-"localhost:8081"}"

# replace placeholders in the actual code
find /app/.next \( -type d -name .git -prune \) -o -type f -print0 | \
	xargs -0 sed -i "s#APP_NEXT_PUBLIC_GATEWAY_URL_STAGING#$NEXT_PUBLIC_GATEWAY_URL_STAGING#g"
find /app/.next \( -type d -name .git -prune \) -o -type f -print0 | \
	xargs -0 sed -i "s#APP_NEXT_PUBLIC_GATEWAY_URL_PRODUCTION#$NEXT_PUBLIC_GATEWAY_URL_PRODUCTION#g"

# store in local env file
cat <<EOF > .env.local
NEXT_PUBLIC_IS_PRODUCTION="${NEXT_PUBLIC_IS_PRODUCTION}"
NEXT_PUBLIC_GATEWAY_URL_STAGING="${NEXT_PUBLIC_GATEWAY_URL_STAGING}"
NEXT_PUBLIC_GATEWAY_URL_PRODUCTION="${NEXT_PUBLIC_GATEWAY_URL_PRODUCTION}"
EOF

echo "Starting Nextjs"
exec node server.cjs
