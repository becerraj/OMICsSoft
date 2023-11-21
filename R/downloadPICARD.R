#' @title downloadPICARD
#' @description Downloads and decompresses the GATK software
#' @return The path where the .exe file is located
downloadPICARD <- function(mitor_sof) {
  tryCatch(
    expr = {
      PICARD <<- sprintf('%s/picard-2.27.5/picard.jar', mitor_sof)
      system2(PICARD, "--help")
      
      return(PICARD)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable, 
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/PICARD', mitor_sof))) {
        system2("rm", sprintf('-r %s/PICARD', mitor_sof))
        
        print("There is a problem with the PICARD .exe file. It will be removed and download again")
      }
      
      message("GATK download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      tryCatch(
        expr = {
          # Proceso de Descarga de PICARD
          URL <- "https://github.com/broadinstitute/picard/archive/refs/tags/2.27.5.tar.gz"
          #system2("wget", URL)
          system2("wget", args = c(URL, "-P", mitor_sof), wait = TRUE, stdout = NULL, stderr = NULL)
          system2("gzip" , sprintf("-d %s/2.27.5.tar.gz", mitor_sof))
          system2("tar" , sprintf("-xvf %s/2.27.5.tar -C %s", mitor_sof, mitor_sof))
          #system2("rm", substr(basename(URL), start = 0, stop = (nchar(basename(URL)) - 3)))
          file.remove(sprintf("%s/2.27.5.tar", mitor_sof))
          
          URL2 <- "https://github.com/broadinstitute/picard/releases/download/2.27.5/picard.jar"
          dir2 <- sprintf("%s/picard-2.27.5", mitor_sof)
          system2("wget", args = c(URL2, "-P", dir2), wait = TRUE, stdout = NULL, stderr = NULL)
          
          PICARD <<- sprintf('%s/picard-2.27.5/picard.jar', mitor_sof)
          system2(PICARD, "--help")
          
          return(PICARD)
        },
        
        error = function(e) {
          message("An error occured while performing the PICARD download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install wget tar gzip
------------------------------------------------------")
          print(e)
        },
        
        finally = {
          message("-.Message from PICARD")
        }
      )
    },
    finally = {
      message("PICARD download and installation completed successfully")
    }
  )
}