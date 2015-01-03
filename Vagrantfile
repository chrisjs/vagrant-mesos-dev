# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "box-cutter/ubuntu1404"
  config.vm.box_check_update = false

  config.vm.provision :shell, path: "bootstrap.sh", privileged: false

  config.vm.network "private_network", ip: "10.0.0.10"

  # mesos UI
  config.vm.network "forwarded_port", guest: 5050, host: 5050

  config.vm.provider :virtualbox do |vb|
    vb.name = "ubuntu14.04.1.trusty.64.v1.0.11"
    vb.customize ['modifyvm', :id, '--memory', "2048"]
    vb.customize ['modifyvm', :id, '--cpus', 2]
  end
end