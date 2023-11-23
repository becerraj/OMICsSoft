#' @title downloadPICARD
#' @description Downloads and decompresses the PICARD software
#' @return The path where the .exe file is located
downloadPICARD <- function(soft_directory = sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER'))) {
  tryCatch(
    expr = {

      if (file.exists(sprintf("%s/OMICsSoft/path_to_softwares.txt", Sys.getenv('R_LIBS_USER')))) {
        softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
        linea_software <- grep("PICARD", softwares, ignore.case = TRUE, value = TRUE)
        PICARD <<- strsplit(linea_software, " ")[[1]][[2]]
      }

      system2(PICARD, "--help")
      return(PICARD)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable,
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/PICARD', soft_directory))) {
        system2("rm", sprintf('-r %s/PICARD', soft_directory))

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
          system2("wget", args = c(URL, "-P", soft_directory), wait = TRUE, stdout = NULL, stderr = NULL)
          system2("gzip" , sprintf("-d %s/2.27.5.tar.gz", soft_directory))
          system2("tar" , sprintf("-xvf %s/2.27.5.tar -C %s", soft_directory, soft_directory))
          #system2("rm", substr(basename(URL), start = 0, stop = (nchar(basename(URL)) - 3)))
          file.remove(sprintf("%s/2.27.5.tar", soft_directory))

          URL2 <- "https://github.com/broadinstitute/picard/releases/download/2.27.5/picard.jar"
          dir2 <- sprintf("%s/picard-2.27.5", soft_directory)
          system2("wget", args = c(URL2, "-P", dir2), wait = TRUE, stdout = NULL, stderr = NULL)

          PICARD <<- sprintf('%s/picard-2.27.5/picard.jar', soft_directory)
          system2(PICARD, "--help")

          # En caso de que la descarga haya sido exitosa, agregamos el path al archivo TXT
          if (!file.exists(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))) {
            # Si no existe la carpeta con los softwares, la creamos
            dir.create(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))
            # Guardamos el primer path del ejecutable del archivo txt
            texto <- sprintf("PICARD %s", PICARD)
            write(texto, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          } else {
            # En caso de ya existir el archivo, solamente agregamos el proximo path
            softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
            if (TRUE %in% grepl("PICARD", softwares, ignore.case = TRUE)) {
              # En caso de haber dado error y se descargo de nuevo, tenemos que eliminar la linea del
              # software anterior.
              softwares <- softwares[-grep("PICARD", softwares, ignore.case = TRUE)]
            }
            # Agregamos la nueva linea con el software
            softwares_actualizado <- c(softwares, sprintf("PICARD %s", PICARD))
            # Reescribimos el archivo
            write(softwares_actualizado, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          }

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
