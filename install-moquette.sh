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

MOQUETTE_BRANCH="08cc8ce1b885990b86411a96d2b62f71b6b5b429"

function usage(){

	echo "Usage: ./install.moquette.sh <STOPPING_CRITERION> <TRIAL>"
	exit 1
}

[ $# -eq 2 ] && STOPPING_CRITERION=$1 && TRIAL=$2 || usage

source fuzz.cfg

echo "Creating Moquette directory..."
mkdir "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette"

#Latest Version 0.13 from Github repository
echo "Cloning Moquette repository from Github..."
git clone https://github.com/moquette-io/moquette.git "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette"
git -C "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette" checkout "$MOQUETTE_BRANCH"

echo "Removing -Xplugin:ErrorProne in broker/pom.xml to compile Moquette successfully"
sed -i 's|<arg>-Xplugin:ErrorProne</arg>|<!--<arg>-Xplugin:ErrorProne</arg>-->|g' "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette/broker/pom.xml"
sed -i 's|<annotationProcessorPaths>|<!--<annotationProcessorPaths>|g' "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette/broker/pom.xml"
sed -i 's|</annotationProcessorPaths>|<annotationProcessorPaths>-->|g' "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette/broker/pom.xml"

echo "Install in local maven repository (This step is necessary in order for the command mvn cobertura:instrument to execute successfully)"
mvn -f "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette/pom.xml" install -DskipTests

./compile-broker.sh "$BROKER_DIR/$STOPPING_CRITERION/trial$TRIAL/moquette"
