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

  config.vm.provision :shell, :path => './setup.sh'
end
