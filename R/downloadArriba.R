#' @title downloadArriba
#' @description Downloads and decompresses the GATK software
#' @return The path where the .exe file is located
downloadArriba <- function(mitor_sof) {
  tryCatch(
    expr = {
      Arriba <<- sprintf("%s/Arriba/arriba_v2.4.0/arriba", mitor_sof)
      system2(Arriba, "-help")
      
      return(Arriba)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable, 
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/Arriba', mitor_sof))) {
        system2("rm", sprintf('-r %s/Arriba', mitor_sof))
        
        print("There is a problem with the Arriba exe file. It will be removed and download again")
      }
      
      message("Arriba download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      tryCatch(
        expr = {
          # Proceso de Descarga de Arriba
          dir.create(sprintf("%s/Arriba", mitor_sof))
          URL <- "https://github.com/suhrig/arriba/releases/download/v2.4.0/arriba_v2.4.0.tar.gz"
          setwd(sprintf("%s/Arriba", mitor_sof))
          
          system2("wget" , URL, wait = TRUE, stdout = NULL, stderr = NULL)
          system2("tar", "-xzf arriba_v2.4.0.tar.gz", wait = TRUE, stdout = NULL, stderr = NULL)
          setwd(sprintf("%s/Arriba/arriba_v2.4.0", mitor_sof))
          system2("make", wait = TRUE, stdout = NULL, stderr = NULL)
          
          
          Arriba <<- sprintf("%s/Arriba/arriba_v2.4.0/arriba", mitor_sof)
          system2(Arriba, "-help")
          
          return(Arriba)
        },
        
        error = function(e) {
          message("An error occured while performing the Arriba download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install wget tar
------------------------------------------------------")
          print(e)
        },
        
        finally = {
          message("-.Message from Arriba")
        }
      )
    },
    finally = {
      message("Arriba download and installation completed successfully")
    }
  )
}



