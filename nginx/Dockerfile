FROM ubuntu:trusty
MAINTAINER Luke Adamczewski "tworzenieweb@gmail.com"

RUN adduser --disabled-password --gecos '' tworzenieweb
RUN adduser tworzenieweb sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
RUN usermod -a -G www-data tworzenieweb


RUN apt-get update

# Install packages
RUN apt-get install -y nginx openssh-server software-properties-common git build-essential curl supervisor wget php5-common php5-fpm php5-mysql php5-pgsql php5-mcrypt php5-gd php5-memcached php5-curl php5-xdebug php5-dev nano screen zsh

RUN chsh -s /bin/zsh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#install other dependances
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs
RUN npm install -g grunt-cli bower gulp
# install composer + symfony installer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

#install zeromq
RUN apt-get install pkg-config
RUN wget http://download.zeromq.org/zeromq-4.0.5.tar.gz
RUN tar -xzf zeromq-4.0.5.tar.gz && cd zeromq-4.0.5 && ./configure && make && make install && ldconfig
RUN pecl install zmq-beta
RUN echo "extension=zmq.so" > /etc/php5/fpm/conf.d/zmq.ini
RUN cp /etc/php5/fpm/conf.d/zmq.ini /etc/php5/cli/conf.d/zmq.ini

# Create required directories
RUN mkdir -p /var/log/supervisor
RUN chmod 755 /var/log/supervisor
RUN mkdir -p /etc/nginx
RUN mkdir -p /var/run/php5-fpm
RUN chmod 777 /var/run/screen

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -e 's/listen\.owner = www-data/listen.owner = tworzenieweb/' -i /etc/php5/fpm/pool.d/www.conf
#RUN sed -e 's/;listen\.group = www-data/listen.group = tworzenieweb/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/user = www-data/user = tworzenieweb/' -i /etc/php5/fpm/pool.d/www.conf
#RUN sed -e 's/group = www-data/group = tworzenieweb/' -i /etc/php5/fpm/pool.d/www.conf

RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini

# Add configuration files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD php.ini /etc/php5/fpm/conf.d/40-custom.ini
ADD php_cli.ini /etc/php5/cli/conf.d/40-custom.ini


USER tworzenieweb

RUN composer global require "phpunit/phpunit=4.6.*"
RUN composer global require "squizlabs/php_codesniffer=*"
RUN composer global require "escapestudios/symfony2-coding-standard=~2.0"

ENV USER tworzenieweb
ENV HOME /home/tworzenieweb

ADD screenrc /home/tworzenieweb/.screenrc
ADD gitconfig /home/tworzenieweb/.gitconfig

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN /bin/bash -l -c "curl -L get.rvm.io | bash -s stable --gems=sass,compass"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

RUN echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> /home/tworzenieweb/.zshrc
RUN /home/tworzenieweb/.composer/vendor/bin/phpcs --config-set installed_paths /home/tworzenieweb/.composer/vendor/escapestudios/symfony2-coding-standard


# Expose volumes
VOLUME ["/var/www", "/etc/nginx/sites-enabled"]

WORKDIR /var/www
USER root

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sudo sysctl -p

EXPOSE 80 9001 1337 22

CMD ["/usr/bin/supervisord"]
