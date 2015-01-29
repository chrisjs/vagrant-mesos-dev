# -*- mode: ruby -*-

VAGRANTFILE_API_VERSION = "2"

VM_BOX = ENV['VM_BOX'] ? ENV['VM_BOX'] : "box-cutter/ubuntu1404"
VM_BOX_CHECK_UPDATE = ENV['VM_BOX_CHECK_UPDATE'] ? ENV['VM_BOX_CHECK_UPDATE'] : false
VM_NETWORK_IP = ENV['VM_NETWORK_IP'] ? ENV['VM_NETWORK_IP'] : "10.0.0.10"
VM_NAME = ENV['VM_NAME'] ? ENV['VM_NAME'] : "trusty.14.04.1.64bit.v1.0.11.mesos.singlenodedev"
VM_MEMORY = ENV['VM_MEMORY'] ? ENV['VM_MEMORY'] : 2048
VM_CPUS = ENV['VM_CPUS'] ? ENV['VM_CPUS'] : 2
VM_GUI = ENV['VM_GUI'] ? ENV['VM_GUI'] : false

printf "Configuring VM with box: %s, check update: %s, network ip: %s, name: %s, memory: %d, cpus: %d, gui enabled: %s\n\n",
  VM_BOX, VM_BOX_CHECK_UPDATE, VM_NETWORK_IP, VM_NAME, VM_MEMORY, VM_CPUS, VM_GUI

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = VM_BOX
  config.vm.box_check_update = VM_BOX_CHECK_UPDATE

  config.vm.provision :file, source: "scripts", destination: "~/scripts"
  config.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: false

  config.vm.network :private_network, ip: VM_NETWORK_IP

  # mesos UI
  config.vm.network "forwarded_port", guest: 5050, host: 5050

  config.vm.provider :virtualbox do |vb|
    vb.name = VM_NAME
    vb.customize ['modifyvm', :id, '--memory', VM_MEMORY]
    vb.customize ['modifyvm', :id, '--cpus', VM_CPUS]
  end

  config.vm.provider "vmware_fusion" do |vb|
    vb.name = VM_NAME
    vb.gui = VM_GUI
    vb.vmx['memsize'] = VM_MEMORY
    vb.vmx['numvcpus'] = VM_CPUS
  end
end
