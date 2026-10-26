FROM ghcr.io/hugomods/hugo:exts-non-root-0.154.5 AS builder

COPY --chown=hugo:hugo . /src
RUN npm ci --prefix themes/hugo-devresume-theme && hugo --minify --gc

FROM docker.angie.software/angie:1.12.4-templated
ENV ANGIE_WORKER_CONNECTIONS="1024"
COPY --from=builder /src/public /usr/share/angie/html

