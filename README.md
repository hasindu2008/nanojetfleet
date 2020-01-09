# nanojetfleet

### Required Hardware

A cluster of Jetson development boards connected to each other using Gigabit Ethernet. We built our cluster using 16 Jetson Nano development boards and 2 Jetson Xavier development boards and the list of items we used are :

| Item                                    | Quantity      | Info                                    |
| -------------                           |-------------:|-------------                          |
| Jetson Nano development boards          |           16    |                                         |   
| 64 GB micro SD cards (A2 rating)        |           16    | We used SanDisk 64GB Extreme microSDXC  |
| Ethernet Cables                         |           18    |                                         |  
| USB to 5.5mm x 2.1mm 5V DC Power Cable  |           16    | To provide power to Jetson Nanos        |
| Gigabit Ethernet Switch                 |            1   |  We used HPE OfficeConnect 1420 Gigabit 24 Port 2 SFP+ Unmanaged Switch                                       |
| Power supply                            |            2   |  We used Alogic VROVA 10 Port 2.4A USB Charger stations                                        |
| Jetson Xavier development kits           |            2   |                                         |  
| NVMe SSD drives                         |            2   | Extra storage for Jetson Xaviers                                        |  
| Copper cylinders (thread Diameter: M2.5)                        |            ~200   |   To stack the Jetson Nanos together                                      |  

Note that the quantities can be varied as per your choice and budget. Jetson Xaviers are optional, you can make a cluster solely using Jetson Nanos.

### Connecting nodes together

- Build the cluster
  - Stack the Jetson Nanos together using copper cylinders
  - Flash Linux distributions onto microSD cards (see the getting [started guide for Jetson Nano](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit) for instructions. We installed Ubuntu 18.04.2 LTS)
  - Plug microSD cards to the Jetson Nanos
  - Connect Jetson Nanos onto the Switch using Ethernet Cables
  - Provide Jetson Nanos power by connecting them to the USB charger stations through USB to 5.5mm x 2.1mm 5V DC power cables


- Configure the Ethernet network
  Requires some networking knowledge. This is not a full guide but some tips.
  - Assigning IP addresses to the nodes
    There is a few ways this can be done.
    1. Assigning static IP addresses to each and every node manually
    2. Configuring a DHCP server on the switch if available (not available on the above switch)
    3. Installing and configuring a DHCP server on one of the nodes (see [here](https://www.tecmint.com/install-dhcp-server-in-ubuntu-debian/))

  - Providing Internet to the nodes
    There are a few ways again
    1. Using a NAT Switch
    2. Connecting a USB ethernet adaptor to one of the nodes and configuring for NAT


### Setting up the *head node*

The node which will be used to control, connect and assign work to the other *worker nodes* is referred to as the *head node*.  This *head node* can be a Jetson Xavier, Jetson Nano it self or any other computer. We used an old PC as the *head node*. On the head node you may want to do the following.

- Install and configure [*ansible*](https://docs.ansible.com/ansible/latest/index.html). *Ansible* will be used to launch commands on all *worker nodes*, centrally from the *head node*.
  - install *ansible*. On Ubuntu:
    ```bash
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt update
    sudo apt install ansible
    ```
  - configure *ansible*.
    You need to edit your `/etc/ansible/ansible.cfg` and `/etc/ansible/hosts`. Our sample config files are at [scripts/sample_config/ansible](scripts/sample_config/ansible).
    - The only modification to `/etc/ansible/ansible.cfg` is that the number of forks have to be set to a number equal or higher than the number of *worker nodes* to be controlled. Otherwise, the automation commands will be serialised.
    - To `/etc/ansible/hosts`, you need to add the ip address range of the *worker nodes*


- Create an SSH key on the head node. You can use the command `ssh-keygen`. This key is needed for password-less access to the *worker nodes*.

- Mount the network attached storage. You can add an entry to the `/etc/fstab` for persist across reboots.

- Optionally, you can install *ganglia* to monitor various metrics of the nodes. In Ubuntu you may use :

  ```bash
  sudo apt-get install ganglia-monitor rrdtool gmetad ganglia-webfrontend
  sudo cp /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled/ganglia.conf

  ```

  You have to edit the configuration files `/etc/ganglia/gmetad.conf`  and /etc/`ganglia/gmond.conf`. Our sample config files are at [scripts/sample_config/ganglia](scripts/sample_config/ganglia).

  You may refer [here](https://hostpresto.com/community/tutorials/how-to-install-and-configure-ganglia-monitor-on-ubuntu-16-04/) for a tutorial on installing and configuring ganglia.

- Optionally, you can configure *rsyslog* and [LogAnalyzer](https://loganalyzer.adiscon.com/) centrally view the logs through web browser.

- Add path of  `scripts/system` of this repository to PATH variable

### Compiling software and preparing the folder structure

On one of your Jetson Nano nodes:

- compile the software. We compiled [minimap2](https://github.com/lh3/minimap2), [samtools](http://www.htslib.org) and [f5c](https://github.com/hasindu2008/f5c) for ARM-v8 architecture.

  ```bash
  #minimap2
  git clone https://github.com/hasindu2008/minimap2-arm/ && cd minimap2-arm/
  make arm_neon=1 aarch64=1

  #samtools
  sudo apt install libbz2-dev liblzma-dev
  wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
  tar xf samtools-1.9.tar.bz2
  cd samtools-1.9
  ./configure --without-curses
  make

  #f5c
  sudo apt install libhdf5-dev zlib1g-dev   #install HDF5 and zlib development libraries
  VERSION=v0.2-beta
  wget "https://github.com/hasindu2008/f5c/releases/download/$VERSION/f5c-$VERSION-release.tar.gz" && tar xvf f5c-$VERSION-release.tar.gz && cd f5c-$VERSION/
  scripts/install-hts.sh  # download and compile the htslib
  ./configure             
  make  cuda=1 NVCC=/usr/local/cuda/bin/nvcc
  ```

- create folder named `nanopore` under `/`.
- Put compiled binaries to a folder named `/nanopore/bin`.
- Put the reference genome and a minimap2 reference index under `/nanopore/reference`. See [here](https://github.com/hasindu2008/minimap2-arm/tree/master/misc/idxtools) how to generate a reference index for limited RAM systems like the Jetson Nano.
- Create a folder named `/nanopore/scratch` for later use.

The directory structure should look like bellow :

  ```
  nanopore
  ├── bin
  │   ├── f5c
  │   ├── minimap2-arm
  │   └── samtools
  ├── reference
  │   ├── hg38noAlt.fa
  │   ├── hg38noAlt.fa.fai
  │   └── hg38noAlt.idx
  └── scratch

  ```

### Setting up *woker nodes*

#### On the *worker node* do the following

  1. assign IP address, subnet mask, default gateway and DNS servers (this can be skipped if you have setup DHCP)
  2. create a user and a password with super user priviledge. make sure you use the same username and the password to make the automated administration tasks through ansible smoother.
  3. change device name (hostname)
  4. change the time zone (and configure NTP if needed)
  5. apt update and package installation  eg: nfs-common ganglia-monitor
  6. mount the network attached storage
  7. copy the binaries and the folder structure we constructed before.

  [shell script](scripts/new_workernode_setup/run_on_workernode.sh)  

#### On the *head node* do the following

  - copy ssh-key generated using *ssh-keygen* previously created on the *head node* to the *worker node*. You can use the command *ssh-copy-id* for this, eg. *ssh-copy-id username@ip_of_worker_node*
  - copy *ganglia* configuration files to the *worker node*
  - copy *rsyslog* configuration files to the *worker node*

  [shell script](scripts/new_workernode_setup/run_on_headnode.sh)  
