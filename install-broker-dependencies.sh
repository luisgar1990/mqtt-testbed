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

WORKING_DIR="/usr/local"
MAVEN_LINK="https://www-eu.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz" #Maven Version 3.6.3
MAVEN_TAR_FILE="apache-maven-3.6.3-bin.tar.gz"
MAVEN_DIR="apache-maven-3.6.3"
MAVEN_ENVIRONMENT_VARIABLE_FILE="/etc/profile.d/apache-maven.sh"
MAVEN_LINK_FILE="apache-maven"

apt-get update
apt install -y build-essential gdb clang xsltproc libssl-dev docbook-xsl gcovr uuid-dev libsqlite3-dev sqlite3 sqlite3-pcre libwrap0 libwrap0-dev default-jdk default-jre

cd $WORKING_DIR
wget $MAVEN_LINK
tar xzf $MAVEN_TAR_FILE
ln -s $MAVEN_DIR $MAVEN_LINK_FILE

cat > $MAVEN_ENVIRONMENT_VARIABLE_FILE <<EOF
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export M2_HOME=$WORKING_DIR/$MAVEN_LINK_FILE
export MAVEN_HOME=$WORKING_DIR/$MAVEN_LINK_FILE
export PATH=\${M2_HOME}/bin:\${PATH}
EOF

rm -f $MAVEN_TAR_FILE
echo "Restart VM for changes to take effect!"
