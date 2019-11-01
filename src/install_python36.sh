#!/bin/bash

export PATH=$PATH:/usr/local/bin

sudo yum install python36 python36-devel python36-setuptools -y 
sudo easy_install pip
sudo python3 -m pip install --upgrade pip

(
  wget https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.xz
  tar -xJf node-v12.13.0-linux-x64.tar.xz 
  sudo cp -r node-v12.13.0-linux-x64 /opt
  echo 'export PATH=/opt/node-v12.13.0-linux-x64/bin:$PATH' >> ~/.bash_profile
)
export PATH=/opt/node-v12.13.0-linux-x64/bin:$PATH

if grep isMaster /mnt/var/lib/info/instance.json | grep true; then
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
	selenium
	pillow
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
	selenium
	pillow"
fi

for WHEEL_NAME in $WHEELS
do
	sudo python3 -m pip install $WHEEL_NAME
done
