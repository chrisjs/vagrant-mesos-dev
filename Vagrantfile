# -*- mode: ruby -*-
#
# Vagrant file that defines configuration parameters and builds the
# VM instance using the provided scripts. This configuration file
# provides reasonable defaults for the VM, allowing them to be
# overridden via environment variables. The following environment
# variables may be set or passed to Vagrant by the user to change
# these defaults:
#
# VM_BOX - the vagrant box name to use
# VM_BOX_CHECK_UPDATE - boolean if updates should be checked
# VM_NETWORK_IP - the IP to use for the private network interface
# VM_NAME - the name of this VM instance
# VM_MEMORY - the amount of memory for this VM instance
# VM_CPUS - the number of CPU's for this VM instance
# VM_GUI - boolean to display the provider GUI or not
#
# NOTE: Mesos compilation uses a large amount of memory and
# it's recommended to use the default size when first building the
# VM (2gig).
#
# The provided scripts, downloaded sources, logs, etc. reside in the
# home directory of the user "vagrant".
#
# Currently Virtualbox and VWware fusion are supported providers.
#
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
