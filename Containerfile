FROM ghcr.io/hugomods/hugo:exts-non-root-0.154.5@sha256:c10b8ab4e03e06f77211f1c15acbe854d9a3ca440bb0b44ff18740ba346ca2da AS builder

COPY --chown=hugo:hugo . /src
RUN npm ci --prefix themes/hugo-devresume-theme && hugo --minify --gc

FROM docker.angie.software/angie:1.12.5-templated@sha256:9ff3f20bb73f2620c1f7fd8e7365a6cc4c05f3e527547ad3a595a6c38d9c7f3b
ENV ANGIE_WORKER_CONNECTIONS="1024"
COPY --from=builder /src/public /usr/share/angie/html

