task quip_lymphocyte_segmentation {
  File originalInput
  String result 
  String? BORBcompatible
  command {
      echo "$(date): Till Segment has begun "
      cd /root/quip_classification 
      chmod a+x ./til_segment_process.sh 
      time ./til_segment_process.sh -originalInput=${originalInput} -result="${result}".tar.gz -BORBcompatible=BORBcompatible
      echo "$(date): Task: Til segment has finished"
    }
    output {
      File out="${result}.tar.gz"
    }
    runtime {
      docker: "us.gcr.io/cloudypipelines-com/til_segmentation:1.3"
      bootDiskSizeGb: 70
      disks: "local-disk 70 SSD"
      memory:  "52 GB"
      cpu: "8"
      maxRetries: 1
      gpuCount: 1
      preemptible:3
      zones: "us-east1-d us-east1-c us-central1-a us-central1-c us-west1-a us-west1-b"
      gpuType: "nvidia-tesla-t4"
      nvidiaDriverVersion: "418.40.04"
    }
 }


workflow wf_quip_lymphocyte_segmentation{ 
  File imageToBeProcessed
  String resultName 
  String? BORBcompatible
  call quip_lymphocyte_segmentation {input: originalInput=imageToBeProcessed,result=resultName,BORBcompatible=BORBcompatible}
  output {
     quip_lymphocyte_segmentation.out
  }
} 