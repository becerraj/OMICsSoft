#' @title indexGenomeBWA
#' @description Genera el indice con anotaciones del genoma de referencia necesarios para BWA.
#' Dentro de la carpeta va a generarse varios archivos ademas de la referencia en formato
#' .fasta. A priori parece desordenado, pero es necesario que quede asi, porque varios softwares
#' necesitan encontrar el archivo .fasta y el resto de archivos de anotaciones dentro del mismo 
#' directorio 
#' @return Devuelve un mensaje diciendo que se ha logrado indexar correctamente.
indexGenomeBWA <- function(mitor_sof, path_to_reference) {
  # Dentro de la carpeta inicial van a quedar varios archivos ademas de la referencia en formato
  # .fasta. A priori parece desordenado, pero es preferible que quede asi, porque varios softwares
  # necesitan encontrar el archivo .fasta y el resto de archivos de anotaciones dentro del mismo 
  # directorio
  BWA <- downloadBWA(mitor_sof)
  GATK <- downloadGATK(mitor_sof)
  SAMTOOLS <- downloadSamtools(mitor_sof)
  
  tryCatch(
    expr = {
      system2(BWA, sprintf("index -a is %s", path_to_reference))
      system2("java", sprintf("-jar %s CreateSequenceDictionary -R %s", GATK, path_to_reference))
      system2(SAMTOOLS, sprintf("faidx %s", path_to_reference))
    }, error = function(e) {
      message("Los softwares necesarios se encuentran disponibles. No hay fallas de instalacion en ellos.
          El error surge del proceso de uno de los softwares. 
          Porfavor chequee las condiciones computacionales del propio software para el proceso de indexado del genoma.")
      
      print(e)
    }, warning = function(e) {
      message("Los softwares necesarios se encuentran disponibles. No hay fallas de instalacion en ellos.
          El error surge del proceso de uno de los softwares. 
          Porfavor chequee las condiciones computacionales del propio software para el proceso de indexado del genoma.")
      
      print(e)
    }, finally = 
      print("Softwares utilizados: BWA, GATK, Samtools.")
  )
}