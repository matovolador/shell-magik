#!/bin/bash
cd ..
yarn run build
scp -r dist/* root@172.105.0.231:/var/www/html