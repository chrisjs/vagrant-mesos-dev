# -*- mode: ruby -*-

VAGRANTFILE_API_VERSION = "2"

VERSION = File.open('VERSION', 'r') { |file| file.read }
VM_BOX = ENV['VM_BOX'] ? ENV['VM_BOX'] : "puphpet/ubuntu1404-x64"
VM_BOX_CHECK_UPDATE = ENV['VM_BOX_CHECK_UPDATE'] ? ENV['VM_BOX_CHECK_UPDATE'] : false
VM_NETWORK_IP = ENV['VM_NETWORK_IP'] ? ENV['VM_NETWORK_IP'] : "10.0.0.10"
VM_NAME = ENV['VM_NAME'] ? ENV['VM_NAME'] : "trusty.14.04.64bit.v2.mesos.singlenodedev-#{VERSION}"
VM_MEMORY = ENV['VM_MEMORY'] ? ENV['VM_MEMORY'] : 2048
VM_CPUS = ENV['VM_CPUS'] ? ENV['VM_CPUS'] : 2
VM_GUI = ENV['VM_GUI'] ? ENV['VM_GUI'] : false

Vagrant.require_version ">= 1.6.3"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = VM_BOX
  config.vm.box_check_update = VM_BOX_CHECK_UPDATE

  config.vm.provision :file, source: "scripts", destination: "~/scripts"
  config.vm.provision :shell, inline: "chmod +x scripts/bootstrap.sh"
  config.vm.provision :shell, path: "scripts/bootstrap.sh", privileged: false

  config.vm.network :private_network, ip: VM_NETWORK_IP

  config.vm.provider "virtualbox" do |provider|
    provider.name = VM_NAME
    provider.customize ['modifyvm', :id, '--memory', VM_MEMORY]
    provider.customize ['modifyvm', :id, '--cpus', VM_CPUS]
  end

  config.vm.provider "vmware_fusion" do |provider|
    provider.name = VM_NAME
    provider.gui = VM_GUI
    provider.vmx['memsize'] = VM_MEMORY
    provider.vmx['numvcpus'] = VM_CPUS
  end
end
