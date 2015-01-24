# -*- mode: ruby -*-

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "box-cutter/ubuntu1404"
  config.vm.box_check_update = false

  config.vm.provision :shell, inline: "mkdir -p ~/scripts/app ; mkdir ~/scripts/os ; mkdir ~/scripts/util"

  config.vm.provision :file, source: "scripts/os/ubuntu-64.sh", destination: "~/scripts/os/ubuntu-64.sh"
  config.vm.provision :file, source: "scripts/app/docker.sh", destination: "~/scripts/app/docker.sh"
  config.vm.provision :file, source: "scripts/app/zookeeper.sh", destination: "~/scripts/app/zookeeper.sh"
  config.vm.provision :file, source: "scripts/app/mesos.sh", destination: "~/scripts/app/mesos.sh"
  config.vm.provision :file, source: "scripts/util/util.sh", destination: "~/scripts/util/util.sh"

  config.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: false

  config.vm.network :private_network, ip: "10.0.0.10"

  # mesos UI
  config.vm.network "forwarded_port", guest: 5050, host: 5050

  config.vm.provider :virtualbox do |vb|
    vb.name = "trusty.14.04.1.64bit.v1.0.11.mesos.singlenodedev"
    vb.customize ['modifyvm', :id, '--memory', "2048"]
    vb.customize ['modifyvm', :id, '--cpus', 2]
  end
end

