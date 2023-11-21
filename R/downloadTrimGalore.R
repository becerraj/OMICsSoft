#' @title downloadGATK
#' @description Downloads and decompresses the GATK software
#' @return The path where the .exe file is located
downloadTrimGalore <- function(mitor_sof) {
  tryCatch(
    expr = {
      TrimGalore <<- sprintf("%s/TrimGalore/TrimGalore-0.6.10/trim_galore", mitor_sof)
      system2(TrimGalore, "--help")
      
      return(TrimGalore)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable, 
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/TrimGalore', mitor_sof))) {
        system2("rm", sprintf('-r %s/TrimGalore', mitor_sof))
        
        print("There is a problem with the TrimGalore exe file. It will be removed and download again")
      }
      
      message("TrimGalore download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      tryCatch(
        expr = {
          # Primero hay que verificar que este descargado FastQC y Cutadapt.
          downloadFastQC(mitor_sof)
          
          # Proceso de Descarga de TrimGalore
          dir.create(sprintf("%s/TrimGalore", mitor_sof))
          URL <- "https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz"
          setwd(sprintf("%s/TrimGalore", mitor_sof))
          system2("wget" ,sprintf("https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz -O trim_galore.tar.gz"), wait = TRUE, stdout = NULL, stderr = NULL)
          system2("tar", "xvzf trim_galore.tar.gz")
          
          TrimGalore <<- sprintf("%s/TrimGalore/TrimGalore-0.6.10/trim_galore", mitor_sof)
          system2(TrimGalore, "--help")
          
          return(TrimGalore)
        },
        
        error = function(e) {
          message("An error occured while performing the TrimGalore download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install cutadapt wget tar
------------------------------------------------------")
          print(e)
        },
        
        finally = {
          message("-.Message from TrimGalore")
        }
      )
    },
    finally = {
      message("TrimGalore download and installation completed successfully")
    }
  )
}