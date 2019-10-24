task quip_lymphocyte_segmentation {
  File imageInput
  command {
      #reminder this is all from wihtin the container
      echo "$(date): Task: pyradiomics started"
      cd /root
      chmod a+x ./pyradiomics_features_process.sh
      time ./pyradiomics_features_process.sh -imageInput=${imageInput} -originalInput=${originalInput} -result=${result} -PATCH_SIZE=${PATCH_SIZE} -segmentResults=${segmentResults} -tumorRegionFile=${tumorRegionFile}
      echo "$(date): Task: pyradiomics finished"
    }
    output {
      File out="${result}"
    }
    runtime {
      docker: "us.gcr.io/cloudypipelines/pyradiomics_features:1.0"
      bootDiskSizeGb: 100
      disks: "local-disk 70 SSD"
      memory:  "64 GB"
      cpu: "12"
      gpu: "nvidia-tesla-t4"
      maxRetries: 1
      zones: "us-east1-b us-east1-c us-east1-d us-central1-a us-central1-b us-central1-c us-central1-f us-east4-a us-east4-b us-east4-c us-west1-a us-west1-b us-west1-c us-west2-a us-west2-b us-west2-c"
    }
  }

workflow wf_quip_lymphocyte_segmentation{
  call quip_lymphocyte_segmentation
  output {
     quip_lymphocyte_segmentation.out
  }
}