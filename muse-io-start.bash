#!/bin/bash

printf "\n  AutoConnect script initialized...\n"
export DYLD_LIBRARY_PATH=/Applications/Muse
export PATH=$PATH:/Applications/Muse
/Applications/Muse/muse-io --50hz --dsp --osc 'osc.udp://localhost:5000'

