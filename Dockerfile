FROM ubuntu:22.04

LABEL maintainer="Kelvin Gunawan Hartono"

WORKDIR /var/www

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Asia/Jakarta 
ENV PHP_VERSION 8.1


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y gnupg
RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip git supervisor libcap2-bin libpng-dev python2 dnsutils librsvg2-bin fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils curl
RUN apt-get clean
RUN apt update \
    && apt install --no-install-recommends -y php8.1 \
    && apt-get install -y php8.1-cli php8.1-dev \
    php8.1-gd php8.1-imagick \
    php8.1-curl \
    php8.1-mbstring \
    php8.1-xml php8.1-zip php8.1-bcmath \
    php8.1-intl php8.1-readline \
    php8.1-msgpack php8.1-igbinary \
    php8.1-pcov php8.1-xdebug \
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer 

RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.5.1
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# install node modules
COPY     package.json /var/www/package.json
RUN      npm install

# COPY node_modules /var/www/node_modules



# RUN apt-get install -y nginx php8.1-fpm \
# && sed -i \
#     -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
#     -e "s/memory_limit\s*=\s*.*/memory_limit = 256M/g" \
#     -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" \
#     -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" \
#     -e "s/max_execution_time = 30/max_execution_time = 180/g" \
#     -e "s/max_input_time = 60/max_input_time = 180/g" \
#     -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
#     -e "s/;opcache.enable=1/opcache.enable=1/"\
#     -e "s/;opcache.memory_consumption=128/opcache.memory_consumption=512/g" \
#     -e "s/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=64/g" \
#     -e "s/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=30000/g" \
#     -e "s/;opcache.revalidate_freq=2/opcache.revalidate_freq=0/g" \
#     /etc/php/${PHP_VERSION}/fpm/php.ini \
#     && sed -i \
#     -e "s/;daemonize\s*=\s*yes/daemonize = no/g" \
#     /etc/php/${PHP_VERSION}/fpm/php-fpm.conf \
#     && sed -i \
#     -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
#     -e "s/pm.max_children = 5/pm.max_children = 4/g" \
#     -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
#     -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
#     -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
#     -e "s/;pm.max_requests = 500/pm.max_requests = 200/g" \
#     -e "s/^;clear_env = no$/clear_env = no/" \
#     /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

# NGINX & fpm
RUN apt-get install -y nginx php8.1-fpm \
    && mkdir /run/php 

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# RUN echo "php_admin_value[error_reporting] = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_STRICT & ~E_DEPRECATED">>/usr/local/etc/php-fpm.d/www.conf
# COPY www.conf /usr/local/etc/php-fpm.d/www.conf


# SQLSRV
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y \
    msodbcsql18 \
    mssql-tools18 \
    unixodbc \
    unixodbc-dev

RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN exec bash

# # INSTALL & LOAD SQLSRV DRIVER & PDO
# RUN pecl install sqlsrv
# # RUN echo "extension=sqlsrv.so" > /etc/php/8.1/cli/conf.d/20-sqlsrv.ini

# RUN pecl install pdo_sqlsrv
# # RUN echo "extension=pdo_sqlsrv.so" > /etc/php/8.1/cli/conf.d/30-pdo_sqlsrv.ini

RUN pecl uninstall -r sqlsrv
RUN pecl uninstall -r pdo_sqlsrv
RUN pecl -d php_suffix=8.1 install sqlsrv
RUN pecl -d php_suffix=8.1 install pdo_sqlsrv
RUN printf "; priority=30\nextension=sqlsrv.so\n" > /etc/php/8.1/mods-available/sqlsrv.ini
RUN printf "; priority=40\nextension=pdo_sqlsrv.so\n" > /etc/php/8.1/mods-available/pdo_sqlsrv.ini
RUN phpenmod -v 8.1 sqlsrv pdo_sqlsrv


COPY composer.json composer.json
# COPY composer.lock composer.lock

RUN composer install \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --no-dev \
    --prefer-dist

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.1

# Nginx config
COPY default /etc/nginx/sites-available/default

COPY php-fpm.conf /etc/php/8.1/fpm/php-fpm.conf



COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# COPY php.ini /etc/php/8.1/cli/conf.d/99-sail.ini
# COPY php.ini /usr/local/etc/php/
# RUN chmod +x /usr/local/bin/start-container
COPY . .
COPY . /var/www/
RUN chmod -R 777 /var/www/uploads



EXPOSE 80
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]