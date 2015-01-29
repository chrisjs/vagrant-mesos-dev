# -*- mode: ruby -*-

VAGRANTFILE_API_VERSION = "2"

VM_BOX = ENV['VM_BOX'] ? ENV['VM_BOX'] : "box-cutter/ubuntu1404"
VM_BOX_CHECK_UPDATE = ENV['VM_BOX_CHECK_UPDATE'] ? ENV['VM_BOX_CHECK_UPDATE'] : false
VM_NETWORK_IP = ENV['VM_NETWORK_IP'] ? ENV['VM_NETWORK_IP'] : "10.0.0.10"
VM_NAME = ENV['VM_NAME'] ? ENV['VM_NAME'] : "trusty.14.04.1.64bit.v1.0.11.mesos.singlenodedev"
VM_MEMORY = ENV['VM_MEMORY'] ? ENV['VM_MEMORY'] : 2048
VM_CPUS = ENV['VM_CPUS'] ? ENV['VM_CPUS'] : 2
VM_GUI = ENV['VM_GUI'] ? ENV['VM_GUI'] : false

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = VM_BOX
  config.vm.box_check_update = VM_BOX_CHECK_UPDATE

  # TODO: https://github.com/chrisjs/vagrant-mesos-dev/issues/7
  config.vm.provision :file, source: "scripts", destination: "~/scripts"
  config.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: false

  config.vm.network :private_network, ip: VM_NETWORK_IP

  # mesos UI
  # TODO: https://github.com/chrisjs/vagrant-mesos-dev/issues/7
  config.vm.network "forwarded_port", guest: 5050, host: 5050

  config.vm.provider :virtualbox do |provider|
    log_install_info

    provider.name = VM_NAME
    provider.customize ['modifyvm', :id, '--memory', VM_MEMORY]
    provider.customize ['modifyvm', :id, '--cpus', VM_CPUS]
  end

  config.vm.provider "vmware_fusion" do |provider|
    log_install_info

    provider.name = VM_NAME
    provider.gui = VM_GUI
    provider.vmx['memsize'] = VM_MEMORY
    provider.vmx['numvcpus'] = VM_CPUS
  end
end

def log_install_info
  printf "Configuring VM with box: %s, check update: %s, network ip: %s, name: %s, memory: %d, cpus: %d, gui enabled: %s\n\n",
    VM_BOX, VM_BOX_CHECK_UPDATE, VM_NETWORK_IP, VM_NAME, VM_MEMORY, VM_CPUS, VM_GUI
end
