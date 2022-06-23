# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box_check_update = false
  config.vm.guest = "linux"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.ssh.insert_key = false

  config.vm.define "master", primary: true do |master|
    master.vm.box = "./master_k3os_virtualbox.box"
    master.vm.network "public_network", bridge: "Killer E2200 Gigabit Ethernet Controller", adapter: "1", auto_config: false
    master.ssh.host = "192.168.1.200"
    master.ssh.username = "rancher"
    master.ssh.password = "rancher"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "1"
    end
  end

  (1..1).each do |i|
    config.vm.define "agent-#{i}" do |agent|
      agent.vm.box = "./agent_k3os_virtualbox.box"
      agent.vm.network "public_network", bridge: "Killer E2200 Gigabit Ethernet Controller", adapter: "2", auto_config: false
      # config.ssh.forward_agent = true
      # config.vm.network "forwarded_port", guest: 22, host: 2223, protocol: "tcp", auto_correct: true
      agent.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
        vb.cpus = "1"
      end
    end
  end
end
