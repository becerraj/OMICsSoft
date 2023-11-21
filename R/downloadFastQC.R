#' @title downloadFastQC
#' @description Downloads and decompresses the FastQC software
#' @return The path where the .exe file is located
downloadFastQC <- function(mitor_sof) {
  tryCatch(
    expr = {
      FastQC <<- sprintf('%s/FastQC/FastQC/fastqc', mitor_sof)
      system2(FastQC, "--help")
      
      return(FastQC)
    },
    error = function(e) {
      message("FastQC download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      # En caso de haberlo descargado y hay algun problema con el ejecutable, 
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/FastQC', mitor_sof))) {
        system2("rm", sprintf('-r %s/FastQC', mitor_sof))
      }
      
      tryCatch(
        expr = {
          # Proceso de Descarga de FastQC
          dir.create(sprintf("%s/FastQC", mitor_sof))
          setwd(sprintf("%s/FastQC", mitor_sof))
          URL <- ("https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip")
          
          system2("wget", URL, wait = TRUE, stdout = NULL, stderr = NULL)
          
          file <- basename(URL)
          file_dir <- file.path(sprintf("%s/FastQC", mitor_sof), file)
          filedc <- substr(file, start = 0, stop = (nchar(file) - 4))
          
          # Descomprimo y elimino el ZIP
          system2("unzip", sprintf("%s -d %s/FastQC", file_dir, mitor_sof), wait = TRUE)
          system2("rm", file_dir)
          
          # Definicion de la variable FastQC con el ejecutable
          FastQC <<- sprintf('%s/FastQC/FastQC/fastqc', mitor_sof)
          system2(FastQC, "--help")
          
          return(FastQC)
        },
        error = function(e) {
          message("An error occured while performing the FastQC download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install wget unzip
------------------------------------------------------")
          print(e)
        },
        
        finally = {
          message("-.Message from FastQC")
        }
      )
    },
    finally = {
      message("FastQC download and installation completed successfully")
    }
  )
}