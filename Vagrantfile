# -*- mode: ruby -*-
# vi: set ft=ruby :
#==========================================================================
#    MQTT-fuzzware: An open source testbed for evaluating MQTT fuzzers.
#    Copyright (C) 2020 Luis Gustavo Araujo Rodriguez, from Honduras C.A.
#
#    This file is part of MQTT-fuzzware.
#
#    MQTT-fuzzware is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    MQTT-fuzzware is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with MQTT-fuzzware.  If not, see <https://www.gnu.org/licenses/>.
#==========================================================================


# VM for MQTT CLIENTS
VM_BOX = "ubuntu/xenial64"
VM_MEMORY = "1024"
VM_SYNCED = "/vagrant_data"

# IP ADDRESS FOR MQTT CLIENTS
BROKER_IP = "192.168.33.20"

# HOST
BROKER_FOLDER = "./output/broker"

Vagrant.configure(2) do |config| 

# CONFIGURE BROKER
   config.vm.define "broker" do |broker|
      broker.vm.hostname = "broker"
      broker.vm.box = VM_BOX
      broker.vm.network "private_network", ip: BROKER_IP
      broker.vm.synced_folder BROKER_FOLDER, VM_SYNCED

      broker.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = VM_MEMORY
      end

      broker.vm.provision "setup", run: "once", preserve_order: "true", type: "shell" do |s|
	s.path = "./provision/broker/dependencies.sh"
      end

      broker.vm.provision "install-mosquitto", run: "once", privileged: false, preserve_order: "true",  type: "shell" do |s|
        s.path = "./provision/broker/install-mosquitto.sh"   
      end

      broker.vm.provision "run-mosquitto", run: "never", privileged: false, type: "shell" do |s|
        s.path = "./provision/broker/run-mosquitto.sh"
      end

      broker.vm.provision "stop-mosquitto", run: "never", privileged: false, type: "shell" do |s|
        s.path = "./provision/broker/stop-mosquitto.sh"
      end

   end

end
