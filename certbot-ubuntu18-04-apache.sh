#!/bin/bash
sudo apt-get update && apt-get install software-properties-common -y && add-apt-repository universe -y && add-apt-repository ppa:certbot/certbot -y && apt-get update && apt-get install certbot python-certbot-apache -y && certbot --apache
