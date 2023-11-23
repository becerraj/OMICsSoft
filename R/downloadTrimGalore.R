#' @title downloadTrimGalore
#' @description Downloads and decompresses the TrimGalore software
#' @return The path where the .exe file is located
downloadTrimGalore <- function(soft_directory = sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER'))) {
  tryCatch(
    expr = {

      if (file.exists(sprintf("%s/OMICsSoft/path_to_softwares.txt", Sys.getenv('R_LIBS_USER')))) {
        softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
        linea_software <- grep("TrimGalore", softwares, ignore.case = TRUE, value = TRUE)
        TrimGalore <<- strsplit(linea_software, " ")[[1]][[2]]
      }

      system2(TrimGalore, "--help")
      return(TrimGalore)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable,
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/TrimGalore', soft_directory))) {
        system2("rm", sprintf('-r %s/TrimGalore', soft_directory))

        print("There is a problem with the TrimGalore exe file. It will be removed and download again")
      }

      message("TrimGalore download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)

      tryCatch(
        expr = {
          # Primero hay que verificar que este descargado FastQC y Cutadapt.
          downloadFastQC(soft_directory)

          # Proceso de Descarga de TrimGalore
          dir.create(sprintf("%s/TrimGalore", soft_directory))
          URL <- "https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz"
          setwd(sprintf("%s/TrimGalore", soft_directory))
          system2("wget" ,sprintf("https://github.com/FelixKrueger/TrimGalore/archive/0.6.10.tar.gz -O trim_galore.tar.gz"), wait = TRUE, stdout = NULL, stderr = NULL)
          system2("tar", "xvzf trim_galore.tar.gz")

          TrimGalore <<- sprintf("%s/TrimGalore/TrimGalore-0.6.10/trim_galore", soft_directory)
          system2(TrimGalore, "--help")

          # En caso de que la descarga haya sido exitosa, agregamos el path al archivo TXT
          if (!file.exists(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))) {
            # Si no existe la carpeta con los softwares, la creamos
            dir.create(sprintf("%s/OMICsSoft", Sys.getenv('R_LIBS_USER')))
            # Guardamos el primer path del ejecutable del archivo txt
            texto <- sprintf("TrimGalore %s", TrimGalore)
            write(texto, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          } else {
            # En caso de ya existir el archivo, solamente agregamos el proximo path
            softwares <- readLines(sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
            if (TRUE %in% grepl("TrimGalore", softwares, ignore.case = TRUE)) {
              # En caso de haber dado error y se descargo de nuevo, tenemos que eliminar la linea del
              # software anterior.
              softwares <- softwares[-grep("TrimGalore", softwares, ignore.case = TRUE)]
            }
            # Agregamos la nueva linea con el software
            softwares_actualizado <- c(softwares, sprintf("TrimGalore %s", TrimGalore))
            # Reescribimos el archivo
            write(softwares_actualizado, file = sprintf("%s/OMICsSoft/path_to_soft.txt", Sys.getenv('R_LIBS_USER')))
          }

          return(TrimGalore)
        },

        error = function(e) {
          message("An error occured while performing the TrimGalore download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install cutadapt wget tar
------------------------------------------------------")
          print(e)
        },

        finally = {
          message("-.Message from TrimGalore")
        }
      )
    },
    finally = {
      message("TrimGalore download and installation completed successfully")
    }
  )
}
