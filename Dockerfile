ARG NODE_VERSION=${NODE_VERSION:-20.18.0-slim}
FROM node:${NODE_VERSION} AS base

# Environment
ENV PATH=/usr/src/app/node_modules/.bin:$PATH
ARG NUXT_PUBLIC_SITE_PORT=${NUXT_PUBLIC_SITE_PORT}
ARG DIRECTUS_URL=${DIRECTUS_URL}

# Setup & clone
RUN apt update && apt-get install -y git
RUN git clone https://github.com/nativeit/agencyos /usr/src/app
WORKDIR /usr/src/app
RUN git checkout main

# Build
FROM base AS build
# COPY /usr/src/app/package.json /usr/src/app/
# WORKDIR /usr/src/app

RUN npm install -g pnpm
RUN pnpm install
RUN pnpm run build

# Stage
FROM build
ENV PORT=${NUXT_PUBLIC_SITE_PORT:-3000}
ENV NODE_ENV=${AGENCY_OS_ENV:-development}
COPY --from=build /usr/src/app/.output .output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build node_modules /usr/src/node_modules

# Run
CMD [ "node", ".output/server/index.mjs" ]
