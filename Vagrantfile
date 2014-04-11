# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.hostname = "heartbleed-tester"
  config.vm.box = "phusion-open-ubuntu-12.04-amd64"
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"

  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.synced_folder "./", "/vagrant"
  config.vm.synced_folder "~/.ec2", "/home/vagrant/.ec2"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
  end

  cmd = "if [ ! -f /tmp/installed ]; then " \
        "sudo apt-get update; sudo apt-get install -y wget git; " \
        "cd /tmp; wget http://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz; " \
        "tar xzf go1.2.1.linux-amd64.tar.gz; " \
        "echo 'export GOPATH=/tmp\n export GOROOT=/go\n export PATH=$PATH:GOROOT/bin' >> /home/vagrant/.bashrc; " \
        "GOPATH=/tmp GOROOT=/tmp/go PATH=$PATH:$GOROOT/bin go get github.com/FiloSottile/Heartbleed; " \
        "GOPATH=/tmp GOROOT=/tmp/go PATH=$PATH:$GOROOT/bin go install github.com/FiloSottile/Heartbleed; " \
        "fi; echo 'yes' > /tmp/installed; "

  config.vm.provision :shell, :inline => cmd
end
