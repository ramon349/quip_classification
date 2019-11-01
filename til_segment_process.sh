#/bin/bash
## image svs or tif file  
imageInput=$1 
result=$2
echo "Received imageInput=${imageInput}"
echo "Received result=${result}"

data_dir=/root/quip_classification/u24_lymphocyte/data
svs_dir=${data_dir}/svs/
output_dir=${data_dir}/output/ 
patch_dir=${data_dir}/patches/

mkdir -p ${svs_dir}
mkdir -p ${output_dir}
mkdir -p ${patch_dir}

echo "Copy imageInput=$imageInput to ${svs_dir}"
mv $imageInput ${svs_dir}


cd /root
#Now let's CD to the tile extraction folder 
cd /root/quip_classification/u24_lymphocyte/scripts/
bash ./patch_2_heatmap.sh

tar -czf /cromwell_root/${result} ${outpu_dir}
ls -alt /cromwell_root/${result}
