#' @title downloadGATK
#' @description Downloads and decompresses the GATK software
#' @return The path where the .exe file is located
downloadGATK <- function(mitor_sof) {
  tryCatch(
    expr = {
      GATK <<- sprintf('%s/%s/gatk-package-4.3.0.0-local.jar', mitor_sof, filedc)
      system2(GATK, "--help")
      
      return(GATK)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable, 
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/GATK', mitor_sof))) {
        system2("rm", sprintf('-r %s/GATK', mitor_sof))
        
        print("There is a problem with the GATK exe file. It will be removed and download again")
      }
      
      message("GATK download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      tryCatch(
        expr = {
          # Proceso de Descarga de GATK
          URL <- 'https://github.com/broadinstitute/gatk/releases/download/4.3.0.0/gatk-4.3.0.0.zip'
          
          system2("wget", args = c(URL, "-P", mitor_sof), wait = TRUE, stdout = NULL, stderr = NULL)
          file <- basename(URL)
          file_dir <- file.path(mitor_sof, file)
          filedc <- substr(file, start = 0, stop = (nchar(file) - 4))
          
          system2(sprintf("unzip %s -d %s", file_dir, mitor_sof), wait = TRUE)
          unzip(zipfile = file_dir, exdir = mitor_sof)
          
          GATK <<- sprintf('%s/%s/gatk-package-4.3.0.0-local.jar', mitor_sof, filedc)
          system2(GATK, "--help")
          
          return(GATK)
        },
        
        error = function(e) {
          message("An error occured while performing the GATK download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install wget unzip
------------------------------------------------------")
          print(e)
        },
        
        finally = {
          message("-.Message from GATK")
        }
      )
    },
    finally = {
      message("GATK download and installation completed successfully")
    }
  )
}