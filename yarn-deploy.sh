#!/bin/bash
# So this assumes you dont actually have a shell script located on your project base path. so it goes back a step, and executes the yarn command. OFC...you need to change the user, host, and maybe even the destination path? (doubtfull)
cd ..
yarn run build
scp -r dist/* root@172.105.0.231:/var/www/html