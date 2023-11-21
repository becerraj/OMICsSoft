#' @title RunTrimgalore
#' @description Corre la funcion TrimGalore para eliminar los adapters y las lecturas (y bases) de baja calidad.
#' @param fileR1 Path donde se encuentra el archivo R1 de formato fasta o fastq
#' @param outdir Path de output donde se guarda el archivo trimeado. En caso de no aportar nignun path, outdir toma el path de entrada R1.
#' @param replace En caso de ser TRUE, se reemplaza el archivo R1 y R2 de entrada por los archivos trimeados.
#' @return ????
RunTrimgalore <- function(fileR1, outdir, replace=FALSE) {
  # Chequeamos que esta descargado TrimGalore. En caso de no estarlo, lo descarga
  TrimGalore <- downloadTrimGalore(mitor_sof)
  
  fileR2 <- stringr::str_replace_all(fileR1, "_R1.","_R2.")
  fileR2 <- stringr::str_replace_all(fileR1, "_1.","_2.")
  
  if (stringr::str_detect(fileR1, "_R1.")) {
    basename <- unlist(stringr::str_split(basename(fileR1),"_R1."))[1]
  } else {
    basename <- unlist(stringr::str_split(basename(fileR1),"_1."))[1]
  }
  
  # Se fija si los archivos de entrada son de formato .gz
  gziped <- ifelse(stringr::str_detect(fileR1,".gz"),"--gzip","--dont_gzip")
  # outdir <- ifelse(missing(outdir), paste0("--output_dir ",dirname(fileR1)),paste0("--output_dir ",file.path(dirname(fileR1),outdir)))
  
  # En caso de no proporcionar path de salida, el output se imprimira en el mismo path de entrada
  if (missing(outdir)) {
    outdir <- ""
  }  
  
  # Trimeado por consola. Guarda el tiempo que tardo en ejecutarse
  t1 <- system.time(system2(command = TrimGalore,
                            args =c("--paired",
                                    gziped,
                                    ifelse(missing(outdir), 
                                           paste0("--output_dir ", dirname(fileR1)), 
                                           paste0("--output_dir ", file.path(dirname(fileR1), outdir))),
                                    fileR1,
                                    fileR2,
                                    paste0("--basename ",basename)), 
                            stderr = file.path(dirname(fileR1), "ErrLog.txt")))
  
  
  # Calculo el tamaño de los archivos de entrada sin trimmear
  of.size1 <- file.info(fileR1)$size
  of.size2 <- file.info(fileR2)$size
  
  # Si el formato era .gz, el output se llamara tambien como .gz, porque TrimGalore asi lo genera
  if (gziped == "--gzip") {
    ofile <- file.path(dirname(fileR1),outdir,paste0(basename,"_val_1.fq.gz"))
  } else {
    ofile <- file.path(dirname(fileR1),outdir,paste0(basename,"_val_1.fq"))
  }
  
  # Tamanos del archivo de salida
  ot.size1 <- file.info(ofile)$size
  ot.size2 <- file.info(stringr::str_replace_all(ofile,"val_1.","val_2."))$size
  
  # No entiendo porque hace de return esta asignacion de variables
  return(c(ifile = fileR1, tfile = ofile , Time = t1, isize1 = of.size1, isize2 = of.size2, 
           tsize1 = ot.size1, tsize2 = ot.size2))
}