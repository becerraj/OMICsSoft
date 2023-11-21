#' @title downloadHG38_MT
#' @description Downloads and decompresses the HG38 mitochondrial DNA reference.
#' Recomendamos continuar su pipeline con la funcion indexGenomeBWA() para generar el indexado y anotacion del genoma
#' que servira para futuros alineamientos del genoma con el software BWA.
#' @return The path where the .fasta reference file is located
downloadHG38_MT <- function(mitor_sof) {
  tryCatch(
    expr = {
      path_HG38_MT <- sprintf('%s/HG38-MT/Homo_sapiens.GRCh38.dna.chromosome.MT.fasta', mitor_sof)
      if (!file.exists(path_HG38_MT)) {
        stop("Comenzara automaticamente la descarga del HG30 mitocondrial.")
      }

      return(path_HG38_MT)
    },
    error = function(e) {
      # En caso de haberlo descargado y hay algun problema con el ejecutable, 
      # eliminamos y descargamos de nuevo
      if (file.exists(sprintf('%s/PICARD', mitor_sof))) {
        system2("rm", sprintf('-r %s/PICARD', mitor_sof))
        
        print("There is a problem with the PICARD .exe file. It will be removed and download again")
      }
      
      message("HG38-MT download and installation is about to begin...
              Please be patient, it may take a while.")
      print(e)
      
      tryCatch(
        expr = {
          # Proceso de Descarga de PICARD
          dir.create(sprintf("%s/RefHG38", mitor_sof))
          URL <- "https://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.MT.fa.gz"
          dir <- sprintf("%s/RefHG38", mitor_sof)
          system2("wget", args = c(URL, "-P", dir), wait = TRUE, stdout = NULL, stderr = NULL)
          system2("gzip" , sprintf("-d %s/%s", dir, basename(URL)))
          
          reference <- substr(basename(URL), 1, nchar(basename(URL)) - 3)
          referenceN <- stringr::str_replace(reference, "fa", "fasta")
          referenceN <- sprintf("%s/%s", dir, referenceN)
          reference <- sprintf("%s/%s", dir, reference)
          
          system2("mv", sprintf("%s %s", reference, referenceN))
          
          return(referenceN)
        },
        
        error = function(e) {
          message("An error occured while performing the HG38-MT download and installation.
      Please remember that some packages are required and you must download them by yourself.
On the Linux command-line print:
------------------------------------------------------
    sudo apt install wget gzip
------------------------------------------------------")
          print(e)
        },
        
        finally = {
          message("-.Message from Ensembl")
        }
      )
    },
    finally = {
      message("HG38-MT from Ensembl was downloaded successfully")
    }
  )
}