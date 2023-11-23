#' @title downloadBWA
#' @description Downloads and decompresses the BWA software
#' @return The path where the .exe file is
downloadBWA <- function(soft_directory = sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER'))) {
  tryCatch(
    expr = {
      if (file.exists(sprintf("%s/OMICsSoft/path_to_softwares.txt", Sys.getenv('R_LIBS_USER')))) {
        softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
        linea_software <- grep("BWA", softwares, ignore.case = TRUE, value = TRUE)
        BWA <<- strsplit(linea_software, " ")[[1]][[2]]
      }

      system2(BWA)
      return(BWA)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable,
      # eliminamos y descargamos de nuevo en el directorio provisto por el usuario
      if (file.exists(sprintf('%s/BWA', soft_directory))) {
        system2("rm", sprintf('-r %s/BWA', soft_directory))

        print("There is a problem with the BWA .exe file. It will be removed and download again")
      }

      message("BWA download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)

      tryCatch(
        expr = {
          # Proceso de Descarga de BWA
          dir.create(sprintf("%s/BWA", soft_directory))

          bwa_url1 <- "https://download.opensuse.org/repositories/home:/vojtaeus/15.4/x86_64/bwa-0.7.17-lp154.6.1.x86_64.rpm"
          bwa_dir1 <- file.path(soft_directory, "BWA")
          #system2("wget", bwa_rpm_url, wait = TRUE, stdout = NULL, stderr = NULL, cwd = bwa_dir1)
          system2("wget", args = c(bwa_url1, "-P", bwa_dir1), wait = TRUE, stdout = NULL, stderr = NULL)
          #system2("rpm2cpio", "bwa-0.7.17-lp154.6.1.x86_64.rpm | cpio -id", wait = TRUE)
          system2("rpm2cpio", sprintf("%s/bwa-0.7.17-lp154.6.1.x86_64.rpm | cpio -D %s -idmv", bwa_dir1, bwa_dir1), wait = TRUE)


          dir.create(sprintf("%s/BWA/bwa-0.7.17-lp154.6.1.src", soft_directory))
          #setwd(sprintf("%s/BWA/bwa-0.7.17-lp154.6.1.src", soft_directory))
          bwa_url2 <-"https://download.opensuse.org/repositories/home:/vojtaeus/15.4/src/bwa-0.7.17-lp154.6.1.src.rpm"
          bwa_dir2 <- file.path(soft_directory, "BWA/bwa-0.7.17-lp154.6.1.src")
          #system2("wget", bwa_url2, wait = TRUE, stdout = NULL, stderr = NULL)
          system2("wget", args = c(bwa_url2, "-P", bwa_dir2), wait = TRUE, stdout = NULL, stderr = NULL)
          #system2("rpm2cpio", "bwa-0.7.17-lp154.6.1.src.rpm | cpio -i", wait=TRUE)
          system2("rpm2cpio", sprintf("%s/bwa-0.7.17-lp154.6.1.src.rpm | cpio -D %s -idmv", bwa_dir2, bwa_dir2), wait = TRUE)


          #setwd(sprintf("%s/BWA", soft_directory))
          bwa_url3 <-"https://download.opensuse.org/repositories/home:/vojtaeus/15.4/i586/bwa-0.7.17-lp154.6.1.i586.rpm"
          #system2("wget", bwa_url3, wait = TRUE, stdout = NULL, stderr = NULL)
          system2("wget", args = c(bwa_url3, "-P", bwa_dir1), wait = TRUE, stdout = NULL, stderr = NULL)
          #system2("rpm2cpio", "bwa-0.7.17-lp154.6.1.i586.rpm | cpio -id", wait=TRUE)
          system2("rpm2cpio", sprintf("%s/bwa-0.7.17-lp154.6.1.i586.rpm | cpio -D %s -idmv", bwa_dir1, bwa_dir1), wait = TRUE)

          BWA <<- sprintf('%s/BWA/usr/bin/bwa', soft_directory)

          # En caso de que la descarga haya sido exitosa, agregamos el path al archivo TXT
          if (!file.exists(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))) {
            # Si no existe la carpeta con los softwares, la creamos
            dir.create(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))
            # Guardamos el primer path del ejecutable del archivo txt
            texto <- sprintf("BWA %s", BWA)
            write(texto, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          } else {
            # En caso de ya existir el archivo, solamente agregamos el proximo path
            softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
            if (TRUE %in% grepl("BWA", softwares, ignore.case = TRUE)) {
              # En caso de haber dado error y se descargo de nuevo, tenemos que eliminar la linea del
              # software anterior.
              softwares <- softwares[-grep("BWA", softwares, ignore.case = TRUE)]
            }
            # Agregamos la nueva linea con el software
            softwares_actualizado <- c(softwares, sprintf("BWA %s", BWA))
            # Reescribimos el archivo
            write(softwares_actualizado, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          }

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
