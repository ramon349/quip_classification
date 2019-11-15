source ../conf/variables.sh 
SCRIPTDIR="${BASE_DIR}/scripts"
declare -a arr=("$JSON_OUTPUT_FOLDER" "$BINARY_JSON_OUTPUT_FOLDER") 
for i in "${arr[@]}"
do 
    echo "${i}"
    input_path=${i}
    temp_path="${i}/temp"
    output_path="${i}/BORB_FILES"  
    mkdir -p "${temp_path}" 
    cd "${input_path}" 
    ls 
    cp *.json "${temp_path}"
    cd "${temp_path}" 
    echo "---- on temp dir ----  " 
    ls 
    rm ./meta*  
    cd "${SCRIPTDIR}" 
    echo "Working on ${temp_path}"
    node process_json.js "${temp_path}" "${output_path}"
done 
