#' @title downloadBWA
#' @description Downloads and decompresses the BWA software
#' @return The path where the .exe file is
downloadBWA <- function(mitor_sof) {
  tryCatch(
    expr = {
      BWA <<- sprintf('%s/BWA/usr/bin/bwa', mitor_sof)
      system2(BWA)
      
      return(BWA)
    },
    error = function(e) {
      message("BWA download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      tryCatch(
        expr = {
          # Proceso de Descarga de BWA
          dir.create(sprintf("%s/BWA", mitor_sof))
          
          bwa_url1 <- "https://download.opensuse.org/repositories/home:/vojtaeus/15.4/x86_64/bwa-0.7.17-lp154.6.1.x86_64.rpm"
          bwa_dir1 <- file.path(mitor_sof, "BWA")
          #system2("wget", bwa_rpm_url, wait = TRUE, stdout = NULL, stderr = NULL, cwd = bwa_dir1)
          system2("wget", args = c(bwa_url1, "-P", bwa_dir1), wait = TRUE, stdout = NULL, stderr = NULL)
          #system2("rpm2cpio", "bwa-0.7.17-lp154.6.1.x86_64.rpm | cpio -id", wait = TRUE)
          system2("rpm2cpio", sprintf("%s/bwa-0.7.17-lp154.6.1.x86_64.rpm | cpio -D %s -idmv", bwa_dir1, bwa_dir1), wait = TRUE)
          
          
          dir.create(sprintf("%s/BWA/bwa-0.7.17-lp154.6.1.src", mitor_sof))
          #setwd(sprintf("%s/BWA/bwa-0.7.17-lp154.6.1.src", mitor_sof))
          bwa_url2 <-"https://download.opensuse.org/repositories/home:/vojtaeus/15.4/src/bwa-0.7.17-lp154.6.1.src.rpm"
          bwa_dir2 <- file.path(mitor_sof, "BWA/bwa-0.7.17-lp154.6.1.src")
          #system2("wget", bwa_url2, wait = TRUE, stdout = NULL, stderr = NULL)
          system2("wget", args = c(bwa_url2, "-P", bwa_dir2), wait = TRUE, stdout = NULL, stderr = NULL)
          #system2("rpm2cpio", "bwa-0.7.17-lp154.6.1.src.rpm | cpio -i", wait=TRUE)
          system2("rpm2cpio", sprintf("%s/bwa-0.7.17-lp154.6.1.src.rpm | cpio -D %s -idmv", bwa_dir2, bwa_dir2), wait = TRUE)
          
          
          #setwd(sprintf("%s/BWA", mitor_sof))
          bwa_url3 <-"https://download.opensuse.org/repositories/home:/vojtaeus/15.4/i586/bwa-0.7.17-lp154.6.1.i586.rpm"
          #system2("wget", bwa_url3, wait = TRUE, stdout = NULL, stderr = NULL)
          system2("wget", args = c(bwa_url3, "-P", bwa_dir1), wait = TRUE, stdout = NULL, stderr = NULL)
          #system2("rpm2cpio", "bwa-0.7.17-lp154.6.1.i586.rpm | cpio -id", wait=TRUE)
          system2("rpm2cpio", sprintf("%s/bwa-0.7.17-lp154.6.1.i586.rpm | cpio -D %s -idmv", bwa_dir1, bwa_dir1), wait = TRUE)
          
          BWA <<- sprintf('%s/BWA/usr/bin/bwa', mitor_sof)
          
          return(BWA)
        },
        
        error = function(e) {
          message("An error occured while performing the BWA download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install wget rpm2cpio cpio
------------------------------------------------------
")
          print(e)
        },
        
        finally = {
          message("-.Message from BWA")
        }
      )
    }
  )  
}