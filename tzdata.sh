#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get install -y tzdata
ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata