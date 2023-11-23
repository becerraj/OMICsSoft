#' @title downloadGATK
#' @description Downloads and decompresses the GATK software
#' @return The path where the .exe file is located
downloadGATK <- function(soft_directory = sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER'))) {
  tryCatch(
    expr = {

      if (file.exists(sprintf("%s/OMICsSoft/path_to_softwares.txt", Sys.getenv('R_LIBS_USER')))) {
        softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
        linea_software <- grep("GATK", softwares, ignore.case = TRUE, value = TRUE)
        GATK <<- strsplit(linea_software, " ")[[1]][[2]]
      }

      system2(GATK, "--help")
      return(GATK)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable,
      # eliminamos y descargamos de nuevo en el directorio provisto por el usuario
      if (file.exists(sprintf('%s/GATK', soft_directory))) {
        system2("rm", sprintf('-r %s/GATK', soft_directory))

        print("There is a problem with the GATK .exe file. It will be removed and download again")
      }

      message("GATK download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)

      tryCatch(
        expr = {
          # Proceso de Descarga de GATK
          URL <- 'https://github.com/broadinstitute/gatk/releases/download/4.3.0.0/gatk-4.3.0.0.zip'

          system2("wget", args = c(URL, "-P", soft_directory), wait = TRUE, stdout = NULL, stderr = NULL)
          file <- basename(URL)
          file_dir <- file.path(soft_directory, file)
          filedc <- substr(file, start = 0, stop = (nchar(file) - 4))

          system2(sprintf("unzip %s -d %s", file_dir, soft_directory), wait = TRUE)
          unzip(zipfile = file_dir, exdir = soft_directory)

          GATK <<- sprintf('%s/%s/gatk-package-4.3.0.0-local.jar', soft_directory, filedc)
          system2(GATK, "--help")

          # En caso de que la descarga haya sido exitosa, agregamos el path al archivo TXT
          if (!file.exists(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))) {
            # Si no existe la carpeta con los softwares, la creamos
            dir.create(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))
            # Guardamos el primer path del ejecutable del archivo txt
            texto <- sprintf("GATK %s", GATK)
            write(texto, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          } else {
            # En caso de ya existir el archivo, solamente agregamos el proximo path
            softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
            if (TRUE %in% grepl("GATK", softwares, ignore.case = TRUE)) {
              # En caso de haber dado error y se descargo de nuevo, tenemos que eliminar la linea del
              # software anterior.
              softwares <- softwares[-grep("GATK", softwares, ignore.case = TRUE)]
            }
            # Agregamos la nueva linea con el software
            softwares_actualizado <- c(softwares, sprintf("GATK %s", GATK))
            # Reescribimos el archivo
            write(softwares_actualizado, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          }

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
