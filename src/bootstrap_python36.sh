#!/bin/bash
set -e

# This file is available in public bucket: s3://hms-dbmi-docs/hail_bootstrap/bootstrap_python36.sh

export PATH=$PATH:/usr/local/bin

wget https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.xz
tar -xJf node-v12.13.0-linux-x64.tar.xz
echo 'export PATH=~/node-v12.13/bin:$PATH' >> ~/.bash_profile
export PATH=~/node-v12.13/bin:$PATH

cd $HOME
mkdir -p $HOME/.ssh/id_rsa
sudo yum install python36 python36-devel python36-setuptools -y 
sudo easy_install pip
sudo python3 -m pip install --upgrade pip

if grep isMaster /mnt/var/lib/info/instance.json | grep true; then
    sudo yum install g++ cmake git -y
    sudo yum install gcc72-c++ -y # Fixes issue with c++14 incompatibility in Amazon Linux
    sudo yum install lz4 lz4-devel -y # Fixes issue of missing lz4
	# Master node: Install all
	WHEELS="pyserial
	oauth
	argparse
	parsimonious
	wheel
	pandas
	utils
	ipywidgets
	numpy
	scipy
	bokeh
	requests
	boto3
	python-magic
	jupyterlab"
else 
	# Worker node: Install all but jupyter lab
	WHEELS="pyserial
	oauth
	argparse
	parsimonious
	wheel
	pandas
	utils
	ipywidgets
	numpy
	scipy
	bokeh
	requests
	boto3
	python-magic"
fi

for WHEEL_NAME in $WHEELS
do
	sudo python3 -m pip install $WHEEL_NAME
done


# Ref: https://www.codeammo.com/article/install-phantomjs-on-amazon-linux/
# Install phantomjs-2.1.1 for bokeh.export_png
# yum install fontconfig freetype freetype-devel fontconfig-devel libstdc++
# wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
# sudo mkdir -p /opt/phantomjs
# bzip2 -d phantomjs-2.1.1-linux-x86_64.tar.bz2
# sudo tar -xvf phantomjs-2.1.1-linux-x86_64.tar \
#     --directory /opt/phantomjs/ --strip-components 1
# sudo ln -s /opt/phantomjs/bin/phantomjs /usr/bin/phantomjs

sudo yum update -y # It has to be at the end so it does not interfere with other yum installations
