task quip_lymphocyte_segmentation {
  File imageInput 
  String result
  command {
      echo "$(date): Till Segment has begun "
      cd /root/quip_classification 
      echo "GET WHAT IS IN THE DIRECTORY"  
      ls 
      chmod a+x ./til_segment_process.sh 
      echo "From containers perspective" 
      echo "imageInput is: ${imageInput}" 
      echo "Result is: ${result}"
      time ./til_segment_process.sh ${imageInput} ${result}
      echo "$(date): Task: Til segment has finished"
    }
    output {
      File out="${result}"
    }
    runtime {
      docker: "us.gcr.io/cloudypipelines/til_segmentation:1.1"
      bootDiskSizeGb: 70
      disks: "local-disk 70 SSD"
      memory:  "52 GB"
      cpu: "8"
      maxRetries: 1
      gpuCount: 1
      zones: "us-east1-d us-east1-c us-central1-a us-central1-c us-west1-a us-west1-b"
      gpuType: "nvidia-tesla-t4"
      nvidiaDriverVersion: "418.40.04"
    }
 }

workflow wf_quip_lymphocyte_segmentation{ 
  call quip_lymphocyte_segmentation 
  output {
     quip_lymphocyte_segmentation.out
  }
}