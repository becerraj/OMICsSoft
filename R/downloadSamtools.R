#' @title downloadSamtools
#' @description Downloads and decompresses the Samtools software
#' @return The path where the .exe file is located
downloadSamtools <- function(soft_directory = sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER'))) {
  tryCatch(
    expr = {
      if (file.exists(sprintf("%s/OMICsSoft/path_to_softwares.txt", Sys.getenv('R_LIBS_USER')))) {
        softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
        linea_software <- grep("SAMTOOLS", softwares, ignore.case = TRUE, value = TRUE)
        SAMTOOLS <<- strsplit(linea_software, " ")[[1]][[2]]
      }

      system2(SAMTOOLS, "help")
      return(SAMTOOLS)
      },

    error = function(e) {
      message("Samtools download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)

      tryCatch(
        expr = {
          # En caso de existir el software pero no funciona por algun motivo, lo borramos y
          # lo volvemos a descargar
          if (file.exists(sprintf("%s/Samtools", soft_directory))) {
            system2("rm", "-r %s", sprintf("%s/Samtools", soft_directory))
          }
          # Proceso de Descarga de Samtools
          dir.create(sprintf("%s/Samtools", soft_directory))
          dir <- sprintf("%s/Samtools", soft_directory)
          URL <- "https://github.com/samtools/samtools/releases/download/1.16.1/samtools-1.16.1.tar.bz2"
          system2("wget", args = c(URL, "-P", dir), wait = TRUE, stdout = NULL, stderr = NULL)

          #system2("bzip2", c("-d", basename(URL)), wait = TRUE)
          system2("bzip2", sprintf("-d %s/Samtools/samtools-1.16.1.tar.bz2", soft_directory))
          system2("tar", c("-xvf", sprintf("%s/Samtools/%s -C %s", soft_directory, list.files(sprintf("%s/Samtools", soft_directory)), dir)))

          #file.remove(list.files(sprintf("%s/Samtools", soft_directory))[stringr::str_detect(list.files(sprintf("%s/Samtools", soft_directory)), ".tar")])
          file.remove(sprintf("%s/samtools-1.16.1.tar", dir))

          #setwd(sprintf("%s", list.files(sprintf("%s/Samtools", soft_directory))))
          #system2("./configure")
          #system2("make")

          samtools_dir <- sprintf("%s/samtools-1.16.1", dir)
          system(paste("cd", shQuote(samtools_dir), "&& ./configure"))
          system(paste("cd", shQuote(samtools_dir), "&& make"))

          # Definicion de la variable Samtools con el ejecutable
          SAMTOOLS <<- sprintf("%s/Samtools/samtools-1.16.1/samtools", soft_directory)

          system2(SAMTOOLS, "help")

          # En caso de que la descarga haya sido exitosa, agregamos el path al archivo TXT
          if (!file.exists(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))) {
            # Si no existe la carpeta con los softwares, la creamos
            dir.create(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))
            # Guardamos el primer path del ejecutable del archivo txt
            texto <- sprintf("SAMTOOLS %s", SAMTOOLS)
            write(texto, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          } else {
            # En caso de ya existir el archivo, solamente agregamos el proximo path
            softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
            if (TRUE %in% grepl("SAMTOOLS", softwares, ignore.case = TRUE)) {
              # En caso de haber dado error y se descargo de nuevo, tenemos que eliminar la linea del
              # software anterior.
              softwares <- softwares[-grep("SAMTOOLS", softwares, ignore.case = TRUE)]
            }
            # Agregamos la nueva linea con el software
            softwares_actualizado <- c(softwares, sprintf("SAMTOOLS %s", SAMTOOLS))
            # Reescribimos el archivo
            write(softwares_actualizado, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          }

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

