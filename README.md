# PHP Development Stack

This repository was made to help users developing PHP applications with instant setup.

This repository contains the following modules:

- PHP 5.6
- Nginx
- MariaDB
- Ruby + Sass + Compass
- NPM + Gulp + Bower
- Memcache

# Installation

To be able to run this toolset you need to install docker and fig tool.

https://docs.docker.com/installation/

http://www.fig.sh/install.html

If all is set just run
`fig up` from command line inside of repository directory.

```bash
git clone https://github.com/tworzenieweb/php-stack.git
cd php-stack
fig run
```

Make sure you've got the following folder structure:

- folder with php development stack repo
- projects folder
  * default directory with your application code
 
This stack is setuped mainly for symfony2 apps so it will look for web dir inside of default directory. To change this edit `sites/default.vhost`

# Database credentials:

MySQL container is linked with Front container so you've got direct connection to the database. 
By default you can access using the following credentials:
```
mysql -u admin -ppass -h mysql
```
You can change this in your `fig.yml` file

If you want to access specific container like you do in vagrant using `ssh` connection just use
```
fig run {container-name} bin/bash
```

In this case we've got front/mysql/memcache containers defined.
