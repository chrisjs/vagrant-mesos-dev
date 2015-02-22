##Project intentions

* Provide simple shell scripts to create a development instance with Mesos and Marathon available out of the box.

* Build a development instance containing Apache Mesos, Docker, Marathon and ZooKeeper via Vagrant or by running the bootstrap script on a pre-existing VM/machine.

* Out of the box ability to do Mesos level development and/or run applications or Docker images via Marathon with no setup on the user's half beyond the initial build.

* Be as de-coupled from specific OS's / distributions as much as possible.

* Be as generic as possible to support using the scripts under Vagrant and standalone (i.e.: no assumptions are made about the current user, etc).

## What this project does not support at this time (and may never)

* Multi-nodes (the intent is a single node development instance).

* Support every OS and distribution right away (currently just Ubuntu 64bit).

* Provide the ability to configure everything and anything. The ability to tweak configuration settings will be added on an as needed basis. Some configuration options are available and documented within the appropriate shell script.

* Start-up scripts. Each distribution tends to have its own way to handle this. The scripts will detect installed / running applications to avoid re-doing those actions. If the VM is shutdown, re-provisioning via Vagrant or running the shell script directly can bring these services back up for you if needed.

## Getting started - General

* Clone this repository from master or use a specific branch. You can also use the download button in the same respects to just get an archive.

## Getting started - Vagrant

* At this time the following has been tested:

  * Vagrant 1.6.3
  * Virtualbox 4.3.20 (r96996)
  * VMware Fusion 6
  * Ubuntu 14.04 64 bit box from puphpet via Vagrant cloud

* Vagrant boxes seem to come and go - please report an issue if you encounter a 404. These scripts were initially developed against the box-cutter versions of Ubuntu 14.04 until they ran into hosting issues.

* In the top level source directory which contains the Vagrantfile, to build the VM for the first time (or after a destroy) run the following:

   ```
vagrant up
```

* To reinitialize a shutdown Vagrant VM run the following:

   ```
vagrant up --provision
```

* Reasonable defaults are set in the Vagrantfile but also allow you to override them via environment variables set or passed to vagrant during the execution of the above commands. See the comments at the top of the Vagrantfile for the currently supported options.

* The initial build will take some time, but should complete without error.


# Getting started - Standalone

* You can manually make an archive of the cloned repo (or use a downloaded archive as explained above), or use the create-distro.sh script provided in the main source directory to build a versioned archive:

   ```
./create-distro.sh
```

* Run the build script:

   ```
./scripts/bootstrap.sh
```

* The initial build will take some time, but should complete without error.

# Getting started - Using

* After the build via the method of your choice above completes without error, the environment can be accessed in the following ways:

  * Vagrant:
     * VM access:

         ```
         vagrant ssh
         ```
     * Mesos UI: http://10.0.0.10:5050

     * Marathon UI: http://10.0.0.10:8080

  * Standalone:
      * VM access - SSH to the IP you have pre-configured on the VM/machine

      * Mesos UI: http://VM_IP:5050

      * Marathon UI: http://VM_IP:8080

##Getting started - Extending

* To extend the Vagrant build itself, take a look at the Vagrant file and its comments.

* To extend the project (new apps, etc), take a look at the scripts/bootstrap.sh comments and app/*.sh comments for examples.

  * It's a good idea to make sure any extensions or exposing of additional configuration options work for both the Vagrant method as well as standalone (unless there is a specific reason not to).

The system is simple, yet has been working well. Issue reports and PR's are always welcome.
