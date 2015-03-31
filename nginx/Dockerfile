FROM tutum/nginx:latest

env PATH /usr/local/rvm/bin:$PATH
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install packages
RUN apt-get update
RUN apt-get remove openssh-client
RUN apt-get install -y openssh-server
RUN apt-get install -y software-properties-common git build-essential curl supervisor wget php5-fpm php5-mysql php5-pgsql php5-mcrypt php5-gd php5-memcached php5-curl php5-xdebug php5-dev nano screen zsh

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN curl -L http://install.ohmyz.sh | sh
RUN chsh -s /bin/zsh
RUN git config --global user.email "tworzenieweb@gmail.com"
RUN git config --global user.name "Luke Adamczewski"

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

#install zeromq
RUN wget http://download.zeromq.org/zeromq-4.0.5.tar.gz
RUN tar -xzf zeromq-4.0.5.tar.gz && cd zeromq-4.0.5 && ./configure && make && make install && ldconfig
RUN pecl install zmq-beta
RUN echo "extension=zmq.so" > /etc/php5/fpm/conf.d/zmq.ini
RUN cp /etc/php5/fpm/conf.d/zmq.ini /etc/php5/cli/conf.d/zmq.ini

# Create required directories
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/nginx
RUN mkdir -p /var/run/php5-fpm
RUN chmod 777 /var/run/screen

sed -e 's/listen\.owner = www-data/listen.owner = root/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group = www-data/listen.group = root/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/user = www-data/user = root/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/group = www-data/group = root/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf

# Add configuration files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD php.ini /etc/php5/fpm/conf.d/40-custom.ini
ADD php_cli.ini /etc/php5/cli/conf.d/40-custom.ini
ADD screenrc /.screenrc
RUN echo '[[ -s "/usr/local/rvm" ]] && source "/usr/local/rvm"' >> /.zshrc

RUN chsh -s /usr/bin/zsh

RUN git config --global user.email "tworzenieweb@gmail.com"
RUN git config --global user.name "Luke Adamczewski"
RUN git config --global credential.helper 'cache --timeout=3600'

# Expose volumes
VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

EXPOSE 22 80 1337 9000 9001

WORKDIR /var/www

CMD ["/usr/bin/supervisord"]
