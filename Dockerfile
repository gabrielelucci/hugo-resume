FROM klakegg/hugo:ext-alpine-onbuild AS hugo

FROM nginx:mainline-alpine-slim
COPY --from=hugo /target /usr/share/nginx/html

