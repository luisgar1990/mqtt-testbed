#!/bin/bash
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

source fuzz.cfg

function usage(){

	echo "Usage: ./install-mosquitto.sh <MOSQUITTO_VERSION> <STOPPING_CRITERION> <TRIAL>"
	exit 1
}

# Receive argument from user
[ $# -eq 3 ] && MOSQUITTO_VERSION=$1; STOPPING_CRITERION=$2; TRIAL=$3 || usage

echo "Installing and setting up $MOSQUITTO_VERSION"
wget https://mosquitto.org/files/source/$MOSQUITTO_VERSION.tar.gz -P $HOME
sudo tar -xvf $HOME/$MOSQUITTO_VERSION.tar.gz -C "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL"
rm -rf $HOME/$MOSQUITTO_VERSION.tar.gz

# Modifies mosquitto.conf to allow external connections (ONLY FOR >= mosquitto-2.0)
if [[ $MOSQUITTO_VERSION == "mosquitto-2.0"* ]]
then
        echo "Modifying mosquitto.conf to allow external connections..."
        echo -e "allow_anonymous true\nlistener 1883" >> "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/$MOSQUITTO_VERSION/mosquitto.conf"
        echo "DONE"
fi

# Modifies config.mk for obtaining coverage results. Works only for Mosquitto versions >= 1.6.0
if [[  $MOSQUITTO_VERSION == "mosquitto-1.6"* || $MOSQUITTO_VERSION == "mosquitto-2.0"* ]]
then

	echo "Modifying config.mk to enable code coverage reports..."
	sed -i "s/WITH_COVERAGE:=no/WITH_COVERAGE:=yes/g" "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/$MOSQUITTO_VERSION/config.mk"
	echo "DONE"

	if [[ $MOSQUITTO_VERSION == "mosquitto-1.6.10" ]]
        then
                echo "Modifying config.mk to disable TLS..."
                sed -i "s/WITH_TLS:=yes/WITH_TLS:=no/g" "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/$MOSQUITTO_VERSION/config.mk"
                echo "DONE"
        fi
fi

# Compiles with Address Sanitizer. This line only works for Mosquitto versions >= 1.4
if [[ $MOSQUITTO_VERSION == "mosquitto-1.4"* || $MOSQUITTO_VERSION == "mosquitto-1.5"* || $MOSQUITTO_VERSION == "mosquitto-1.6"* || $MOSQUITTO_VERSION == "mosquitto-2.0"* ]]
then
	echo "Modifying config.mk to enable Address Sanitizer..."
	sed -i "/-Wl,--dynamic-list=linker.syms/s/$/ -g -fsanitize=address/" "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/$MOSQUITTO_VERSION/config.mk"
	echo "DONE"

#Compiles with Address Sanitize. This line only works for Mosquitto <= 0.5.4
elif [[ $MOSQUITTO_VERSION == "mosquitto-0.5"* || $MOSQUITTO_VERSION == "mosquitto-0.4"* || $MOSQUITTO_VERSION == "mosquitto-0.3"* || $MOSQUITTO_VERSION == "mosquitto-0.2"* || $MOSQUITTO_VERSION == "mosquitto-0.1"* ]]
then
	sed -i "s/-nopie/-no-pie/ ; /LDFLAGS=/s/$/ -g -fsanitize=address/" "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/$MOSQUITTO_VERSION/config.mk"
	echo "DONE"
fi

echo "Compiling..."
make -C "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/$MOSQUITTO_VERSION/src"
