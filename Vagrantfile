# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provision "ansible_local" do |ansible|
  config.vm.network "forwarded_port", guest: 1433, host: 4203
  config.vm.box = "ubuntu/xenial64"  
    ansible.playbook = "playbook.yml"
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end
end
