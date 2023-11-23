#' @title downloadSTAR
#' @description Downloads and decompresses the GATK software
#' @return The path where the .exe file is located
downloadSTAR <- function(soft_directory = sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER'))) {
  tryCatch(
    expr = {

      if (file.exists(sprintf("%s/OMICsSoft/path_to_softwares.txt", Sys.getenv('R_LIBS_USER')))) {
        softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
        linea_software <- grep("STAR", softwares, ignore.case = TRUE, value = TRUE)
        STAR <<- strsplit(linea_software, " ")[[1]][[2]]
      }

      system2(STAR, "--help")
      return(STAR)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable,
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/STAR', soft_directory))) {
        system2("rm", sprintf('-r %s/STAR', soft_directory))

        print("There is a problem with the STAR exe file. It will be removed and download again")
      }

      message("STAR download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)

      tryCatch(
        expr = {
          # Proceso de Descarga de STAR
          dir.create(sprintf("%s/STAR", soft_directory))
          URL <- "https://github.com/alexdobin/STAR/archive/2.7.11a.tar.gz"
          version <- sub("\\.tar\\.gz$", "", basename(URL))
          dir <- sprintf("%s/STAR", soft_directory)
          setwd(dir)
          # Get latest STAR source from releases
          system2("wget", args = c(URL, "-P", dir), wait = TRUE, stdout = NULL, stderr = NULL)
          system2("tar", sprintf("-xzf %s.tar.gz", version))
          # Compile
          setwd(sprintf("%s/STAR-%s/source", dir, version))
          system2("make", "STAR")

          # Definimos la variable de STAR con su ejecutable
          STAR <<- sprintf("%s/STAR/STAR-2.7.11a/bin/Linux_x86_64_static/STAR", soft_directory)
          system2(STAR, "--help")

          # En caso de que la descarga haya sido exitosa, agregamos el path al archivo TXT
          if (!file.exists(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))) {
            # Si no existe la carpeta con los softwares, la creamos
            dir.create(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))
            # Guardamos el primer path del ejecutable del archivo txt
            texto <- sprintf("STAR %s", STAR)
            write(texto, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          } else {
            # En caso de ya existir el archivo, solamente agregamos el proximo path
            softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
            if (TRUE %in% grepl("STAR", softwares, ignore.case = TRUE)) {
              # En caso de haber dado error y se descargo de nuevo, tenemos que eliminar la linea del
              # software anterior.
              softwares <- softwares[-grep("STAR", softwares, ignore.case = TRUE)]
            }
            # Agregamos la nueva linea con el software
            softwares_actualizado <- c(softwares, sprintf("STAR %s", STAR))
            # Reescribimos el archivo
            write(softwares_actualizado, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          }

          return(STAR)
        },

        error = function(e) {
          message("An error occured while performing the STAR download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install wget tar
------------------------------------------------------")
          print(e)
        },

        finally = {
          message("-.Message from STAR")
        }
      )
    },
    finally = {
      message("STAR download and installation completed successfully")
    }
  )
}
