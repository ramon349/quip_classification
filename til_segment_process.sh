!/bin/bash
## image svs or tif file
echo "Received imageInput=$imageInput"


echo "Received result=$result"
[ -z "$result" ] && { echo "result is empty"; exit 1; }

data_dir=/root/quip_classification/u24_lymphocyte/data
svs_dir =${data_dir}/svs/
output_dir=${data_dir}/output/

mkdir -p $svs_dir
mkdir -p $output_dir

echo "Copy imageInput=$imageInput to ${svs_dir}/"
mv $imageInput ${svs_dir}/


cd /root
#Now let's CD to the tile extraction folder 
cd /root/quip_classification/u24_lymphocyte/patch_extraction 
bash ./start.sh
cd cd ./prediction 
bash ./start.sh

tar -czf /cromwell_root/${result} $outputDir
ls -alt /cromwell_root/${result}