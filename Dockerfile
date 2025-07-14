ARG NODE_VERSION=${NODE_VERSION}
FROM node:${NODE_VERSION} AS base

# Environment
ENV PATH=/usr/src/app/node_modules/.bin:$PATH
ENV NUXT_PUBLIC_SITE_PORT=${NUXT_PUBLIC_SITE_PORT}
ENV DIRECTUS_URL=${DIRECTUS_URL}

# Setup & clone
RUN apt update && apt-get install -y git
RUN git clone https://github.com/nativeit/agency-os /usr/src/app
WORKDIR /usr/src/app
RUN git checkout dev

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
ENV NODE_ENV=${AGENCY_OS_ENV:-production}
COPY --from=build /usr/src/app/.output .output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build node_modules /usr/src/node_modules

# Run
CMD [ "node", ".output/server/index.mjs" ]
