#' @title downloadSamtools
#' @description Downloads and decompresses the Samtools software
#' @return The path where the .exe file is located
downloadSamtools <- function(mitor_sof) {
  # La funcion deberia funcionar. Pero tenemos que darle un valor por defecto que tenga sentido!!!
  tryCatch(
    expr = {
      SAMTOOLS <<- sprintf("%s/Samtools/samtools-1.16.1/samtools", mitor_sof)
      system2(SAMTOOLS, "help")
      
      return(SAMTOOLS)
      },
    error = function(e) {
      message("Samtools download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      tryCatch(
        expr = {
          # Proceso de Descarga de Samtools
          dir.create(sprintf("%s/Samtools", mitor_sof))
          dir <- sprintf("%s/Samtools", mitor_sof)
          URL <- "https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2"
          system2("wget", args = c(URL, "-P", dir), wait = TRUE, stdout = NULL, stderr = NULL)
          
          #system2("bzip2", c("-d", basename(URL)), wait = TRUE)
          system2("bzip2", sprintf("-d %s/Samtools/samtools-1.16.1.tar.bz2", mitor_sof))
          system2("tar", c("-xvf", sprintf("%s/Samtools/%s -C %s", mitor_sof, list.files(sprintf("%s/Samtools", mitor_sof)), dir)))
          
          #file.remove(list.files(sprintf("%s/Samtools", mitor_sof))[stringr::str_detect(list.files(sprintf("%s/Samtools", mitor_sof)), ".tar")])
          file.remove(sprintf("%s/samtools-1.16.1.tar", dir))
          
          #setwd(sprintf("%s", list.files(sprintf("%s/Samtools", mitor_sof))))
          #system2("./configure")
          #system2("make")
          
          samtools_dir <- sprintf("%s/samtools-1.16.1", dir)
          system(paste("cd", shQuote(samtools_dir), "&& ./configure"))
          system(paste("cd", shQuote(samtools_dir), "&& make"))
          
          # Definicion de la variable Samtools con el ejecutable
          SAMTOOLS <<- sprintf("%s/Samtools/samtools-1.16.1/samtools", mitor_sof)
          
          system2(SAMTOOLS, "help")
          
          return(SAMTOOLS)
        },
        
        error = function(e) {
          message("An error occured while performing the Samtools download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install bzip2 libncurses5-dev tar
------------------------------------------------------
  libncurses5-dev for Debian or Ubuntu Linux or ncurses-devel for RPM-based Linux distributions")
          
          print(e)
        },
        
        finally = {
          message("-.Message from Samtools")
        }
      )
    }
  )    
}

