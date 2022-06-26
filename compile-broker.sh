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

	echo "Usage: ./compile-broker.sh <BROKER_DIR>"
	echo "MQTT Brokers supported: Mosquitto | Moquette"
	exit 1
}

function compile_moquette(){

	MOQUETTE_DIR="$1"

	#cd "$MOQUETTE_DIR"

	echo "Cleaning Moquette folder..."
	mvn -f "$MOQUETTE_DIR/pom.xml" clean
	#mvn clean

	echo "Compiling Moquette..."
	mvn -f "$MOQUETTE_DIR/pom.xml" compile
	#mvn compile

	echo "Instrumenting code..."
	mvn -f "$MOQUETTE_DIR/pom.xml" cobertura:instrument
	#mvn cobertura:instrument

	echo "Generating .jar file based on Instrumented code..."
	#jar cfv "$MOQUETTE_DIR/broker/target/generated-classes/cobertura/moquette-broker-0.14-SNAPSHOT.jar" "$MOQUETTE_DIR/broker/target/generated-classes/cobertura/"*
	cd "$MOQUETTE_DIR/broker/target/generated-classes/cobertura" && jar cfv moquette-broker-0.14-SNAPSHOT.jar *
	cd "$MOQUETTE_DIR"

	echo "Building Moquette package..."
	mvn -f "$MOQUETTE_DIR/pom.xml" package -DskipTests
	#mvn package -DskipTests

	echo "Extracting Moquette package..."
	tar -xvzf "$MOQUETTE_DIR/distribution/target/distribution-0.14-SNAPSHOT-bundle-tar.tar.gz" -C "$MOQUETTE_DIR/distribution/target/" 
	#cd "distribution/target" && tar -xvzf distribution-0.14-SNAPSHOT-bundle-tar.tar.gz
	#cd "$MOQUETTE_DIR"


	echo "Removing .jar file with uninstrumented code..."
	rm "$MOQUETTE_DIR/distribution/target/lib/moquette-broker-0.14-SNAPSHOT.jar"

	echo "Copying .jar file with instrumented code to library folder..."
	cp "$MOQUETTE_DIR/broker/target/generated-classes/cobertura/moquette-broker-0.14-SNAPSHOT.jar" "$MOQUETTE_DIR/distribution/target/lib/"

	echo "Downloading cobertura-2.1.1.jar file to library to run instrumented code..."
	wget "https://repo1.maven.org/maven2/net/sourceforge/cobertura/cobertura/2.1.1/cobertura-2.1.1.jar" -P "$MOQUETTE_DIR/distribution/target/lib/"
}


function compile_mosquitto(){

	MOSQUITTO_DIR="$1"

	make -C $MOSQUITTO_DIR/src/ clean
	make -C $MOSQUITTO_DIR/src/
}

[[ $# -eq 1 && -n "$1" ]] && BROKER_DIR="$1" || usage

case $BROKER_DIR in

	*"mosquitto"*)
		compile_mosquitto $BROKER_DIR
		;;

	*"moquette"*)
		compile_moquette $BROKER_DIR
		;;

	*)
		usage

esac
