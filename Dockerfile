FROM docker.io/klakegg/hugo:ext-alpine-onbuild AS hugo

FROM docker.io/library/nginx:mainline-alpine-slim
COPY --from=hugo /target /usr/share/nginx/html

