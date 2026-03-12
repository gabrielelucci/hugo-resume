FROM  ghcr.io/hugomods/hugo:exts-non-root AS builder

COPY --chown=hugo:hugo . /src
RUN npm ci --prefix themes/hugo-devresume-theme && hugo --minify --gc

FROM docker.angie.software/angie:templated
ENV ANGIE_WORKER_CONNECTIONS="1024"
COPY --from=builder /src/public /usr/share/angie/html

