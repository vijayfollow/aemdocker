# DOCKER-VERSION 1.7.0
FROM ubuntu:14.04
LABEL version="1.0"
LABEL description="AEM publish dispatcher.  Uses Apache and Google Pagespeed"
MAINTAINER dbenge

ENV DEBIAN_FRONTEND noninteractive

# In case windows line endings exist, yuck
RUN apt-get update && apt-get -y install software-properties-common dos2unix apache2 apache2-utils libssl1.0.0 libssl-dev

# Configure timezone and locale
RUN echo "US/Pacific" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata && \
    export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install pagespeed
ADD https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb /aem/dispatcher/pagespeed/module/
WORKDIR /aem/dispatcher/pagespeed/module
RUN dpkg -i mod-pagespeed-*.deb
RUN apt-get -y -f install

# Install dispatcher mod - Linux x86 64bit OpenSSL 1.0
ADD https://mavendc-utils.s3.amazonaws.com/internal/cq6/dispatcher-apache2.4-linux-x86-64-4.2.1.tar.gz /aem/dispatcher/module/
WORKDIR /aem/dispatcher/module/
RUN tar -zxvf *.gz && chown -R www-data:www-data *

WORKDIR /aem/dispatcher/
RUN mkdir logs

COPY resources/dispatcher.any dispatcher.any
RUN dos2unix dispatcher.any
WORKDIR /lib/x86_64-linux-gnu/

RUN ln -s libssl.so.1.0.0 libssl.so.10 && ln -s libcrypto.so.1.0.0 libcrypto.so.10

#Copies required mods
WORKDIR /etc/apache2/mods-available/
COPY resources/mods-available/* ./
RUN dos2unix ./*
WORKDIR /etc/apache2/sites-available/
COPY resources/sites-available/* ./
RUN dos2unix ./*

#enable mods and site
RUN a2enmod rewrite dispatcher ssl pagespeed expires headers && a2dissite 000-default && a2ensite aemsite

ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80 443
