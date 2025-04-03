FROM  ghcr.io/hugomods/hugo:exts-non-root AS builder

COPY . /src
RUN hugo --minify --gc

FROM docker.io/library/nginx:mainline-alpine-slim
COPY --from=builder /src/public /usr/share/nginx/html

