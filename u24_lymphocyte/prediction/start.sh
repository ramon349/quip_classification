#!/bin/bash

source ../conf/variables.sh
echo "prediction process has begun"   
date 
echo "Working on lymphocytes"
cd lymphocyte
nohup bash pred_thread_lym.sh \
    ${PATCH_PATH} 0 1 ${LYM_CNN_PRED_DEVICE} \
    &> ${LOG_OUTPUT_FOLDER}/log.pred_thread_lym_0.txt &
cd ..
echo "Completed lymphocytes working on necrosis" 
date
cd necrosis
nohup bash pred_thread_nec.sh \
    ${PATCH_PATH} 0 1 ${NEC_CNN_PRED_DEVICE} \
    &> ${LOG_OUTPUT_FOLDER}/log.pred_thread_nec_0.txt &
cd ..
echo "Completed necrosis workin on lymphocyte" 
date 
cd color
nohup bash color_stats.sh ${PATCH_PATH} 0 2 \
    &> ${LOG_OUTPUT_FOLDER}/log.color_stats_0.txt &
nohup bash color_stats.sh ${PATCH_PATH} 1 2 \
    &> ${LOG_OUTPUT_FOLDER}/log.color_stats_1.txt &
cd ..

wait

exit 0
