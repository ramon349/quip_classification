task vsi_detector {
  String fileInput
  command {
    is_vsi.sh ${fileInput}
  }
  output {
    Boolean out=read_boolean(stdout())
  }
  runtime {
    docker: "us.gcr.io/cloudypipelines-com/quip_vsi_detector:1.0"
    memory:  "3.75 GB"
    cpu: "1"
    maxRetries: 1
    zones: "us-east1-b us-east1-c us-east1-d us-central1-a us-central1-b us-central1-c us-central1-f us-east4-a us-east4-b us-east4-c us-west1-a us-west1-b us-west1-c us-west2-a us-west2-b us-west2-c"
  }
}

task convert {
  File vsiInput
  String pattern = "\\.+\\w+"
  String replacement = ".tif"
  String tiffName = sub(basename(vsiInput),pattern,replacement)
  command {
    echo "$(date): Task: convert started"
    echo "File name to be used ${tiffName}" 
    cd /root
    time ./converter_process.sh ${vsiInput} ${tiffName}
    echo "$(date): Task: convert finished"
  }
  output {
    File out=tiffName
  }
  runtime {
    docker: "us.gcr.io/cloudypipelines-com/quip_converter_to_tiff:1.1"
    bootDiskSizeGb: 50
    disks: "local-disk 50 SSD"
    memory:  "12 GB"
    cpu: "2"
    maxRetries: 1
    zones: "us-east1-b us-east1-c us-east1-d us-central1-a us-central1-b us-central1-c us-central1-f us-east4-a us-east4-b us-east4-c us-west1-a us-west1-b us-west1-c us-west2-a us-west2-b us-west2-c"
  }
}

task quip_lymphocyte_segmentation {
  File? imageInput  
  File originalInput
  String? BORBcompatible
  String network
  String pattern = "\\.+\\w+"
  String replacement = "_segmentation"
  String result = sub(basename(originalInput),pattern,replacement)
  command {
      echo "$(date): Till Segment has begun "
      cd /root/quip_classification 
      chmod a+x ./til_segment_process.sh 
      time ./til_segment_process.sh -originalInput=${originalInput} -imageInput=${imageInput} -result="${result}".tar.gz -BORBcompatible=${BORBcompatible} -network=${network}
      echo "$(date): Task: Til segment has finished"
    }
    output {
      File out="${result}.tar.gz"
    }
    runtime {
      docker: "us.gcr.io/cloudypipelines-com/til_segmentation:1.4"
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
  File imageToBeProcessed
  String? BORBcompatible
  String network 
  #Detect if input image is vsi or not 
  call vsi_detector {input: fileInput=imageToBeProcessed} 
  Boolean should_call_convert = vsi_detector.out 
  if(should_call_convert){
    call convert {input: vsiInput=imageToBeProcessed} 
    File convert_out = convert.out
  }#do standard process  
  File? convert_out_maybe = convert_out
  call quip_lymphocyte_segmentation {input: imageInput=convert_out_maybe,originalInput=imageToBeProcessed,BORBcompatible=BORBcompatible,network=network}
  output {
     quip_lymphocyte_segmentation.out
  }
} 