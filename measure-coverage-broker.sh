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

function usage(){

	echo "Usage: ./measure-coverage-broker.sh <BROKER_DIR>"
	echo "MQTT Brokers supported: Mosquitto | Moquette"
	exit 1
}

measure_coverage_moquette(){

	MOQUETTE_DIR="$1"
	mvn -f "$MOQUETTE_DIR/pom.xml" cobertura:dump-datafile
}


measure_coverage_mosquitto(){

	MOSQUITTO_DIR="$1"
	cd "$MOSQUITTO_DIR/src/" && gcovr -r .
}

[[ $# -eq 1 && -n "$1" ]] && BROKER_DIR="$1" || usage

case $BROKER_DIR in

	*"mosquitto"*)
		measure_coverage_mosquitto $BROKER_DIR
		;;

	*"moquette"*)
		measure_coverage_moquette $BROKER_DIR
		;;

	*)
		usage

esac
