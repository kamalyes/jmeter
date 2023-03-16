#!/bin/bash

CMD_RUNNER_URL="http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.3/cmdrunner-2.3.jar"
PLUGIN_MANAGER_URL="https://jmeter-plugins.org/get/"

# DOWNLOAD RUNNER
wget -o "lib/cmdrunner-2.3.jar" $CMD_RUNNER_URL

# DOWNLOAD MANAGER
wget -o "lib/ext/jmeter-plugins-manager.jar" $PLUGIN_MANAGER_URL

# GENERATING SCRIPTS
# java -cp lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller
