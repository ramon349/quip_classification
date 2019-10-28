task quip_lymphocyte_segmentation {
  File imageInput 
  String result ="multirest_tilSegment.tar.gz"
  command {
      echo "$(date): Till Segment has begun "
      cd /root/quip_classification 
      echo "GET WHAT IS IN THE DIRECTORY"  
      ls 
      chmod a+x ./til_segment_process.sh
      time ./til_segment_process.sh ${imageInput} ${result}
      echo "$(date): Task: pyradiomics finished"
    }
    output {
      File out="${result}"
    }
    runtime {
      docker: "us.gcr.io/cloudypipelines/til_segmentation:.1"
      bootDiskSizeGb: 100
      disks: "local-disk 100 SSD"
      memory:  "64 GB"
      cpu: "8" 
      gpuCount: 1
      gpu: "nvidia-tesla-k80"
      maxRetries: 1
      zones: "us-east1-d us-east1-c us-central1-a us-central1-c us-west1-a us-west1-b"
      gpuType: "nvidia-tesla-k80"
      nvidiaDriverVersion: "418.40.04"
      }
  }

workflow wf_quip_lymphocyte_segmentation{ 
  call quip_lymphocyte_segmentation 
  output {
     quip_lymphocyte_segmentation.out
  }
}