FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apache2 \
       gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Подключаем loader файла модуля 1C Web Server и включаем модуль
COPY apache/1cws.load /etc/apache2/mods-available/1cws.load
RUN a2enmod 1cws

# Каталог публикации 1C (будет монтироваться volume)
RUN mkdir -p /var/www/base

# Entrypoint для генерации VRD из шаблона
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]


