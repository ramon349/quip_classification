task quip_lymphocyte_segmentation {
  File imageInput
  String result ="processing.tar.gz"
  command {
      #reminder this is all from wihtin the container
      echo "$(date): Task: pyradiomics started"  
      cd /root
      chmod a+x ./pyradiomics_features_process.sh
      time ./til_segment_process.sh -imageInput=${imageInput} -result=${result} 
      echo "$(date): Task: pyradiomics finished"
    }
    output {
      File out="${result}"
    }
    runtime {
    docker: "us.gcr.io/cloudypipelines/pyradiomics_features:1.0"
    bootDiskSizeGb: 70
    disks: "local-disk 70 SSD"
    memory:  "52 GB"
    cpu: "8"
    maxRetries: 1
    gpuCount: 1
    zones: "us-east1-d us-east1-c us-central1-a us-central1-c us-west1-a us-west1-b"
    gpuType: "nvidia-tesla-k80"
    }
  }

workflow wf_quip_lymphocyte_segmentation{
  call quip_lymphocyte_segmentation
  output {
     quip_lymphocyte_segmentation.out
  }
}