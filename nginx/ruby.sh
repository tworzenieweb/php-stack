gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
/bin/bash -l -c "rvm requirements"
/bin/bash -l -c "rvm install 2.3.1"
/bin/bash -l -c "gem install sass"
/bin/bash -l -c "gem install compass"
