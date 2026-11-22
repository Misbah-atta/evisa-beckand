FROM node:24-slim@sha256:dc26ae92c9fb15cf6b1d63e20f0944b2efe0f115b20e00be48fb23fceb061c54 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
####runtime image (final stage)
FROM node:24-slim@sha256:dc26ae92c9fb15cf6b1d63e20f0944b2efe0f115b20e00be48fb23fceb061c54
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/node_modules  ./node_modules
COPY --chown=node:node . .
RUN mkdir -p logs uploads && chown node:node logs uploads
USER node
EXPOSE 5000
CMD ["npm", "start"]
