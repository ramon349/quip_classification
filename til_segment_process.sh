#/bin/bash 
for i in "$@"
do
case $i in
    -imageInput=*)
    imageInput="${i#*=}"
    shift # past argument=value
    ;;
    -originalInput=*)
    originalInput="${i#*=}"
    shift # past argument=value
    ;;
    -result=*)
    result="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done 
echo "Received imageInput=$imageInput"
echo "Received originalInput=$originalInput"
if [ -s "$imageInput" ]
then
     echo "imageInput=$imageInput from converter is not empty, use it"
else
     echo "imageInput=$imageInput from converter is empty, use originalInput=$originalInput"
     imageInput=${originalInput}
fi

## image svs or tif file  
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
bash ./svs_2_heatmap.sh

tar -czf /cromwell_root/${result} ${output_dir}
ls -alt /cromwell_root/${result}
