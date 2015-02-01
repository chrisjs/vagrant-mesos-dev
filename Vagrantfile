# -*- mode: ruby -*-

VAGRANTFILE_API_VERSION = "2"

VM_BOX = ENV['VM_BOX'] ? ENV['VM_BOX'] : "box-cutter/ubuntu1404"
VM_BOX_CHECK_UPDATE = ENV['VM_BOX_CHECK_UPDATE'] ? ENV['VM_BOX_CHECK_UPDATE'] : false
VM_NETWORK_IP = ENV['VM_NETWORK_IP'] ? ENV['VM_NETWORK_IP'] : "10.0.0.10"
VM_NAME = ENV['VM_NAME'] ? ENV['VM_NAME'] : "trusty.14.04.1.64bit.v1.0.11.mesos.singlenodedev"
VM_MEMORY = ENV['VM_MEMORY'] ? ENV['VM_MEMORY'] : 2048
VM_CPUS = ENV['VM_CPUS'] ? ENV['VM_CPUS'] : 2
VM_GUI = ENV['VM_GUI'] ? ENV['VM_GUI'] : false

VM_APP_MESOS_UI_HOST_PORT = ENV['VM_APP_MESOS_UI_HOST_PORT'] ? ENV['VM_APP_MESOS_UI_HOST_PORT'] : 5050
VM_APP_MESOS_UI_GUEST_PORT = ENV['MESOS_MASTER_PORT'] ? ENV['MESOS_MASTER_PORT'] : 5050

Vagrant.require_version ">= 1.6.3"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = VM_BOX
  config.vm.box_check_update = VM_BOX_CHECK_UPDATE

  config.vm.provision :file, source: "scripts", destination: "~/scripts"
  config.vm.provision :shell, inline: "chmod +x scripts/bootstrap.sh"
  config.vm.provision :shell do |shell|
    shell.privileged = false
    shell.inline = "MESOS_MASTER_PORT=#{VM_APP_MESOS_UI_GUEST_PORT} scripts/bootstrap.sh"
  end

  config.vm.network :private_network, ip: VM_NETWORK_IP

  # mesos UI
  config.vm.network "forwarded_port", guest: VM_APP_MESOS_UI_GUEST_PORT, host: VM_APP_MESOS_UI_HOST_PORT

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
