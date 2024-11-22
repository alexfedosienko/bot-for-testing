FROM composer:latest AS backend
WORKDIR /app
COPY ./app /app
RUN composer update --no-dev --prefer-dist --ignore-platform-reqs

FROM alpine:3.18
RUN apk --no-cache --update \
    add apache2 \
    apache2-ssl \
    php81-curl \
    php81-iconv \
    php81-mbstring \
    php81-apache2

RUN mkdir /app
WORKDIR /app

RUN sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' /etc/apache2/httpd.conf
RUN sed -i 's/#LoadModule\ deflate_module/LoadModule\ deflate_module/' /etc/apache2/httpd.conf
RUN sed -i 's/#LoadModule\ expires_module/LoadModule\ expires_module/' /etc/apache2/httpd.conf

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

ADD ./apache.conf /etc/apache2/conf.d/app.conf
COPY --from=backend /app /app
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

RUN set -xe && chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT [ "/entrypoint.sh" ]