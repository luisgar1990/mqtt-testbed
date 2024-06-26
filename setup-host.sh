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

[ $# != 1 ] && (echo "Usage: ./setup-host.sh <STOPPING_CRITERION>"; echo "OPTION: time | packets") && exit 1

source fuzz.cfg

case $1 in

	"time")
		STOPPING_CRITERION=("${FUZZING_CAMPAIGN[@]}");;

	"packets")

		STOPPING_CRITERION=("${PACKETS[@]}");;

		*)
			echo "Stopping criterion is unavailable" && exit 1;;

esac

mkdir "$OUTPUT_DIR" || exit 1

for (( i=0; i<${#STOPPING_CRITERION[@]}; i++ ))
do
	mkdir "$OUTPUT_DIR/${STOPPING_CRITERION[i]}" || exit 1
	
	for (( j=1; j<=$TRIALS; j++ ))
	do
		mkdir "$OUTPUT_DIR/${STOPPING_CRITERION[i]}/trial$j" || exit 1
		
		for (( k=0; k<${#BROKER_VERSION[@]}; k++ ))
		do
			mkdir "$OUTPUT_DIR/${STOPPING_CRITERION[i]}/trial$j/${BROKER_VERSION[k]}" || exit 1
		done

	done
done

