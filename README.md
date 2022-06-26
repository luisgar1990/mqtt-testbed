# MQTT-fuzzware: An open source testbed for evaluating MQTT fuzzers.

## Context

The Message Queueing Telemetry Transport (MQTT) is a publish-subscribe messaging protocol developed by IBM in 1999. MQTT has two main components: MQTT clients and MQTT brokers. An MQTT client can be either a *publisher* or *subscriber*. A publisher sends messages to subscribers, however messages are not sent directly. The MQTT broker receives messages from publishers and sends them to interested subscribers.

## Objective

This repository contains the source code of MQTT-fuzzware, which is a testbed for evaluating MQTT fuzzers. The repository contains a Vagrantfile that automatically configures the broker in a virtual machine.	

## Repository Structure

### Directories

* */provision* contains bash scripts for running commands such as installing dependencies or brokers such as Mosquitto. 
* */vagrant_data* is a shared directory between the host and virtual machines. This directory. The broker logs are sent to this directory in order to be accessible from the host machine.

### Files

#### Vagrantfile

The *Vagrantfile* installs the necessary dependencies for the broker in a virtual machine. The IP address of the broker is static, however it can be easily modified in the Vagrantfile.

| Component | IP            |
| --------- | ------------- |
| Broker    | 192.168.33.20 |

##### Commands supported

The commands supported on the Vagrantfile are as follows.

###### Initialize virtual machine where broker is hosted

```bash
vagrant up
```
At first execution, the command will create the virtual machine and install the necessary dependencies for the broker.

###### Access the virtual machine

```bash
vagrant ssh broker
```

#### fuzz.cfg
File for *configuration settings* of the experiment. Settings include, but not limited to:
* Stopping criterion;
* MQTT fuzzer and directory that contains both its experiment results and source code;
* Number of test runs per stopping criterion and fuzzer;
* Name, IP, and directory of brokers;

#### Bash scripts

| File            | Objective |
| ----------      | --------- |
| setup-target.sh | Once the virtual machine is created and the settings configured, execute this script from within the VM to set up the broker.| 
| compile-broker.sh | Compiles the source code of the broker to generate an executable file |
| install-broker-dependencies.sh | Install dependencies for the broker. Currently supports only Mosquitto and Moquette. |
| install-moquette.sh | Installs Moquette in the virtual machine. |
| install-mosquitto.sh | Installs Mosquitto in the virtual machine. |
| execute.sh      | *Executes* the experiments and generates the results automatically. Also monitors CPU and memory usage of the fuzzer and broker. |
| setup-host.sh   | Generates output/result directories in host machine. |
| measure-coverage-broker.sh  | Measures code coverage after the test run has been completed. Currently supports only Mosquitto and Moquette. |


## Requirements

The following software has to be installed for the testbed to work properly:

* [Vagrant](https://www.vagrantup.com/)
* [tshark](https://tshark.dev/setup/install/)

MQTT-fuzzware was developed, tested, and used on Ubuntu Mate 20.04 LTS, which has installed the following software:

* GNU bash version 5.0.17
* Tshark 3.2.3
* Vagrant 2.2.9

## License
This testbed is available under *GPL-2.0-or-later*, meaning developers can use, modify, and redistribute the source code according to their needs.
