apt-get update &&
apt-get install -y language-pack-en-base &&
export LC_ALL=en_US.UTF-8 &&
export LANG=en_US.UTF-8 &&
apt-get install -y software-properties-common &&
apt-get install -y curl unzip &&
add-apt-repository ppa:ondrej/php &&
apt-get update

apt-get --assume-yes --force-yes install -y -q php7.0-fpm \
    php7.0-cli php7.0-curl php7.0-gd \
    php7.0-intl php7.0-mysql php7.0-dom php7.0-zip php7.0-intl php7.0-xdebug


# install composer + symfony installer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
chmod a+x /usr/local/bin/symfony

mkdir -p /run/php

sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php/7.0/fpm/php-fpm.conf

sed -i '/^;ping\.path/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf

sed -i '/^;pm\.status_path/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf


sed -e 's/listen\.owner = www-data/listen.owner = tworzenieweb/' -i /etc/php/7.0/fpm/pool.d/www.conf
sed -e 's/;listen\.group = www-data/listen.group = tworzenieweb/' -i /etc/php/7.0/fpm/pool.d/www.conf
sed -e 's/user = www-data/user = tworzenieweb/' -i /etc/php/7.0/fpm/pool.d/www.conf
sed -e 's/group = www-data/group = tworzenieweb/' -i /etc/php/7.0/fpm/pool.d/www.conf
sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.0/fpm/pool.d/www.conf

adduser --disabled-password --gecos '' tworzenieweb
adduser tworzenieweb sudo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
usermod -a -G www-data tworzenieweb
