FROM ubuntu:trusty
MAINTAINER Luke Adamczewski "tworzenieweb@gmail.com"
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Install basic packages
RUN apt-get update && apt-get install -y curl pkg-config git build-essential supervisor wget nano zsh

# installing php
COPY php.sh ./php.sh
RUN chmod +x ./php.sh
RUN ./php.sh

ADD php.ini /etc/php/7.0/fpm/conf.d/40-custom.ini
ADD php_cli.ini /etc/php/7.0/cli/conf.d/40-custom.ini

COPY nginx.sh ./nginx.sh
RUN chmod +x ./nginx.sh 
RUN ./nginx.sh
COPY nginx.conf /etc/nginx/

COPY node.sh ./node.sh
RUN chmod +x ./node.sh 
RUN ./node.sh

COPY ruby.sh ./ruby.sh
RUN chmod +x ./ruby.sh
RUN ./ruby.sh

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor
RUN chmod 755 /var/log/supervisor

ENV USER tworzenieweb
ENV HOME /home/tworzenieweb

USER tworzenieweb

ADD gitconfig /home/tworzenieweb/.gitconfig
RUN git config --global user.email "tworzenieweb@gmail.com"
RUN git config --global user.name "Luke Adamczewski"
RUN git config --global credential.helper 'cache --timeout=3600'

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

COPY extra.sh ./extra.sh
RUN chmod +x ./extra.sh
RUN ./extra.sh

VOLUME ["/var/www", "/etc/nginx/conf.d"]

WORKDIR /var/www
USER root

EXPOSE 80 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
