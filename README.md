# PHP Development Stack

This repository was made to help users developing PHP applications with instant setup.

This repository contains the following modules:

- PHP 7.1
- Nginx
- MariaDB
- php-fpm
- Ruby + Sass + Compass
- node, NPM + Bower

# Installation

To be able to run this toolset you need to install docker and fig tool.

https://docs.docker.com/installation/

https://docs.docker.com/compose/

If all is set just run
`docker-compose build` from command line inside of repository directory.

```bash
git clone https://github.com/tworzenieweb/php-stack.git
cd php-stack
docker-compose up
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
You can change this in your `docker-compose.yml` file

If you want to access specific container like you do in vagrant using `ssh` connection just use
```
docker exec -i -t -u tworzenieweb container_id_or_name /bin/zsh -l
```


Where container_id_or_name can be obtained by running

`docker ps`
