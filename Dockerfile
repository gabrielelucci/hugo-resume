FROM klakegg/hugo:ext-alpine-onbuild AS hugo

FROM nginx:stable-alpine
COPY --from=hugo /target /usr/share/nginx/html

