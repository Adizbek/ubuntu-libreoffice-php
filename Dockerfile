FROM php:7.4.13-fpm-buster as prod

RUN apt-get update && \
    # office tools
    apt-get -qq install libxinerama1 libdbus-1-3 libcairo2 libcups2 libsm6 libx11-xcb-dev wget \
    # ms fonts
    cabextract xfonts-utils libmspack0 libfontenc1 xfonts-encodings fontconfig \
    # php dependencies
    libzip-dev libsqlite3-dev libxml2-dev libfreetype6-dev libjpeg-dev libjpeg62-turbo-dev \
    # fonts
    fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core \
    # other deps
    nano nginx supervisor procps htop && \
    cd /tmp && \
    wget http://ftp.ru.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb && \
    dpkg -i ttf-mscorefonts-installer_3.7_all.deb && \
    fc-cache -f  && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    wget https://download.documentfoundation.org/libreoffice/stable/7.0.4/deb/x86_64/LibreOffice_7.0.4_Linux_x86-64_deb.tar.gz && \
    tar -xf LibreOffice_7.0.4_Linux_x86-64_deb.tar.gz && \
    cd LibreOffice_7.0.4.* && dpkg -i DEBS/* && \
    ln -s /usr/local/bin/libreoffice7.0 /usr/local/bin/libreoffice && \
    cd /tmp && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*


# install php and its dependencies
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install mysqli gd json sockets pcntl zip pdo pdo_mysql pdo_sqlite tokenizer xml iconv ctype fileinfo intl && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    echo "#zend_extension=xdebug" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

#
#RUN apk add --no-cache nano curl nginx supervisor py3-pip
#
#RUN pip3 install unoconv
