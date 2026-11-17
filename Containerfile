FROM ghcr.io/hugomods/hugo:exts-non-root-0.154.5@sha256:c10b8ab4e03e06f77211f1c15acbe854d9a3ca440bb0b44ff18740ba346ca2da AS builder

COPY --chown=hugo:hugo . /src
RUN npm ci --prefix themes/hugo-devresume-theme && hugo --minify --gc

FROM docker.angie.software/angie:1.12.4-templated@sha256:ede6f3257c4fde42ea01a0a5d834a51ab17e0de6c9e7afe9753985a95d1b4ddb
ENV ANGIE_WORKER_CONNECTIONS="1024"
COPY --from=builder /src/public /usr/share/angie/html

