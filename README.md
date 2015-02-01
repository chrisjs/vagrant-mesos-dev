single node mesos dev instance using vagrant - WIP

only tested w/ vagrant 1.6.3, virtualbox 4.3.20 (r96996) and the 64 bit ubuntu 14.04 vagrant box from boxcutter (v1.0.11) via vagrantcloud

mesos bound to 10.0.0.10 and web UI on port 5050

Vagrant file allows various configuration options such as the box name, number of CPU's, RAM etc to be overriden via environment variables. See the top of Vagrantfile for overridable options.

