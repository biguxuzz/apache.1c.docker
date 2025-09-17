FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apache2 \
       libapache2-mod-auth-kerb \
       krb5-user \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Включаем модули Apache, необходимые для директив совместимости (Order/Allow) и Kerberos
RUN a2enmod access_compat auth_kerb alias

# Подключаем loader файла модуля 1C Web Server и включаем модуль
COPY apache/1cws.load /etc/apache2/mods-available/1cws.load
RUN a2enmod 1cws

# Каталог публикации 1C (будет монтироваться volume)
RUN mkdir -p /var/www/uh

EXPOSE 80

CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]


