FROM tutum/nginx:latest

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install packages
RUN apt-get update
RUN apt-get install -y software-properties-common git build-essential curl supervisor wget php5-fpm php5-mysql php5-mcrypt php5-gd php5-memcached php5-curl php5-xdebug nano screen

#install other dependances
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs
RUN npm install -g grunt-cli bower

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 1.9.3"
RUN /bin/bash -l -c "gem install sass"
RUN /bin/bash -l -c "gem install compass"

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Create required directories
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/nginx
RUN mkdir -p /var/run/php5-fpm

# Add configuration files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD php.ini /etc/php5/fpm/conf.d/40-custom.ini

# Expose volumes
VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

EXPOSE 80 9000

CMD ["/usr/bin/supervisord"]
