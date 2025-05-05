# Используем минимальный базовый образ Ubuntu
FROM ubuntu:24.04
    
RUN groupadd -g 55004 vmail
RUN useradd -u 55004 -g 55004 \
    -d /var/mail \
    -s /usr/sbin/nologin \
    -M vmail

# Устанавливаем необходимые пакеты
RUN apt-get update \
    && apt-get install -y \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    dovecot-mysql \
    dovecot-pgsql \
    dovecot-lmtpd \
    postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Копируем конфигурационные файлы Dovecot
#COPY conf/dovecot.conf /etc/dovecot/dovecot.conf
#COPY conf/conf.d/ /etc/dovecot/conf.d/

# Создаем пользователя и группу для работы почтового сервера
#RUN groupadd -g 5000 vmail && \
#    useradd -m -d /var/mail -s /sbin/nologin -u 5000 -g 5000 vmail

# Устанавливаем права на почтовый каталог
RUN mkdir -p /var/mail && \
    chown -R vmail:vmail /var/mail

# Открываем порты для IMAP и POP3
#EXPOSE 143 110 24
EXPOSE 993 995 24

# Запускаем Dovecot
CMD ["dovecot", "-F"]
