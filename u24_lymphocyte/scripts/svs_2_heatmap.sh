#!/bin/bash

if [[ -n $BASE_DIR ]]; then
	cd $BASE_DIR
else
	cd ../
fi

source ./conf/variables.sh
date 
echo "Starting patch extraction process" 
cd patch_extraction
nohup bash start.sh &
cd .. 
echo "patch extraction process complete" 
date 
echo "Working on prediction "
cd prediction
nohup bash start.sh &
cd ..
echo "finished prediction" 
date 
wait;
echo "working on heatmap generation " 
cd heatmap_gen
nohup bash start.sh &
cd ..
echo "Done with heatmap generation"
wait;
date 

exit 0
