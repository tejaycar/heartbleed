#!/bin/bash

if [ ! -f /tmp/installed ]
then
  #update apt-get and get some utilities
  sudo apt-get update
  sudo apt-get install -y wget git

  #install go-lang
  cd /tmp
  wget http://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz
  tar xzf go1.2.1.linux-amd64.tar.gz
  echo 'export GOPATH=/tmp\n export GOROOT=/go\n export PATH=$PATH:GOROOT/bin' >> /home/vagrant/.bashrc
  export GOPATH=/tmp
  export GOROOT=/tmp/go
  export PATH=$PATH:$GOROOT/bin

  #install heartbleed code
  go get github.com/FiloSottile/Heartbleed
  GOPATH=/tmp GOROOT=/tmp/go PATH=$PATH:$GOROOT/bin go install github.com/FiloSottile/Heartbleed

  mkdir /opt/heartbleed
  cd /opt/heartbleed

  git clone https://github.com/pblittle/suture
  git clone https://github.com/tejaycar/heartbleed

  touch /tmp/installed
else
  cd /opt/heartbleed/suture
  git pull

  cd /opt/heartbleed/heartbleed
  git pull
fi