#!/bin/bash
# This file is part of VPL for Moodle
# Script for debugging C++ language
# Copyright (C) 2014 Juan Carlos Rodríguez-del-Pino
# License http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
# Author Juan Carlos Rodríguez-del-Pino <jcrodriguez@dis.ulpgc.es>

# @vpl_script_description Using GDB or ddd if available
# load common script and check programs
. common_script.sh
check_program g++
get_source_files cpp C
# compile
. vpl_run.sh n "-g -O0"
if [ -f vpl_execution ] ; then
	mv vpl_execution vpl_program
	cat common_script.sh > vpl_execution
	chmod +x vpl_execution
	if [ "$(command -v ddd)" == "" ] ; then
		check_program gdb
		echo "gdb vpl_program" >> vpl_execution
	else
		echo "ddd --quiet --gdb vpl_program &>/dev/null" >> vpl_execution
		mkdir .ddd &>/dev/null
		mkdir .ddd/sessions &>/dev/null
		mkdir .ddd/themes &>/dev/null
		cat >.ddd/init <<END_OF_FILE
Ddd*splashScreen: off
Ddd*startupTips: off
Ddd*suppressWarnings: on
Ddd*displayLineNumbers: on
Ddd*saveHistoryOnExit: off

! DO NOT ADD ANYTHING BELOW THIS LINE -- DDD WILL OVERWRITE IT
END_OF_FILE
		mv vpl_execution vpl_wexecution
	fi
fi
