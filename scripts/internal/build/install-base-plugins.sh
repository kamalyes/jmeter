#!/bin/bash
set -e
mvn-download.sh -f plugins-lib-ext-dependencies.xml -t ${JMETER_HOME}/lib/ext
mvn-download.sh -f plugins-lib-dependencies.xml -t ${JMETER_HOME}/lib
chmod +x $DEPENCENCIES_PATH/plugins-sh/*.sh
cp $DEPENCENCIES_PATH/plugins-sh/*.sh  ${JMETER_HOME}/bin
