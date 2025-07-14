ARG NODE_VERSION=20.18.0
FROM node:${NODE_VERSION}-slim as base
ARG PORT=3000
ARG DIRECTUS_URL=${DIRECTUS_URL:-https://cms.dev.nativeit.net}
ARG DIRECTUS_SERVER_TOKEN=${DIRECTUS_SERVER_TOKEN}
ARG NUXT_PUBLIC_SITE_URL=${NUXT_PUBLIC_SITE_URL}
RUN echo "$srv-captain--appname"
RUN apt update && apt-get install -y git
RUN git clone https://github.com/nativeit/agency-os /usr/src/app
WORKDIR /usr/src/app
RUN git checkout dev
ENV PATH /usr/src/app/node_modules/.bin:$PATH
# COPY . /usr/src/app

# Build
FROM base as build
# COPY /usr/src/app/package.json package-lock.json .
COPY . .
RUN npm install -g pnpm
RUN pnpm install
RUN pnpm run build
COPY .output .output

# Run
FROM build
ARG PORT=3000
ARG DIRECTUS_URL=${DIRECTUS_URL}
ARG DIRECTUS_SERVER_TOKEN=${DIRECTUS_SERVER_TOKEN}
ARG NUXT_PUBLIC_SITE_URL=${NUXT_PUBLIC_SITE_URL}
ENV PORT=${PORT}
ENV NODE_ENV=production

COPY --from=build .output /usr/src/app/.output
# Optional, only needed if you rely on unbundled dependencies
# COPY --from=build node_modules /usr/src/node_modules

# RUN pnpm run dev -o
CMD [ "node", "/usr/src/app/.output/server/index.mjs" ]
# CMD [ "bash", "/usr/src/app" ]
