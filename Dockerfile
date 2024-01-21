# docker build --build-arg http_proxy=http://192.168.0.66:3128 --build-arg https_proxy=http://192.168.0.66:3128 .

FROM debian:bookworm

ENV LC_ALL C.UTF-8

ARG DEBIAN_FRONTEND=noninteractive
ARG http_proxy=""
ARG https_proxy=""

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/force-unsafe-io && \
    apt-get -q update && \
    apt-get install -y eatmydata  && \
    eatmydata -- apt-get install -y apt-transport-https ca-certificates && \
    apt-get clean && rm -Rf /var/lib/apt/lists/* && \
    rm /etc/apt/sources.list.d/debian.sources

COPY ./provisioning/sources.list /etc/apt/sources.list
COPY ./provisioning/deb.sury.org-php.gpg /usr/share/keyrings/deb.sury.org-php.gpg

RUN apt-get -qq update && \
    eatmydata -- apt-get -qy install \
        apache2 libapache2-mod-php7.0 \
        curl \
        git-core \
        jq \
        php7.0 php7.0-cli php7.0-curl php7.0-json php7.0-xml php7.0-mysql php7.0-mbstring php7.0-bcmath php7.0-zip php7.0-mysql php7.0-sqlite3 php7.0-opcache php7.0-xml php7.0-xsl php7.0-intl php-sodium php7.0-imagick php7.0-gd php7.0-xmlrpc \
        zip unzip msmtp-mta && \
    eatmydata -- apt-get -y autoremove && \
    apt-get clean && \
    rm -Rf /var/lib/apt/lists/* && \
    a2enmod headers rewrite deflate php7.0 remoteip

COPY ./provisioning/msmtprc /etc/msmtprc
COPY ./provisioning/php.ini /etc/php/7.0/apache2/conf.d/local.ini
COPY ./provisioning/php.ini /etc/php/7.0/cli/conf.d/local.ini
COPY ./provisioning/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf

RUN echo GMT > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata \
    && mkdir -p "/var/log/apache2" \
    && ln -sfT /dev/stderr "/var/log/apache2/error.log" \
    && ln -sfT /dev/stdout "/var/log/apache2/access.log" \
    && ln -sfT /dev/stdout "/var/log/apache2/other_vhosts_access.log"

RUN curl -o /usr/local/bin/composer https://getcomposer.org/download/2.0.11/composer.phar && chmod 755 /usr/local/bin/composer

RUN /usr/local/bin/composer self-update

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

WORKDIR /workspace

EXPOSE 80
