#' @title downloadHG38
#' @description Downloads and decompresses the HG38 mitochodnrial DNA reference.
#' @return The path where the .fasta reference file is located
downloadHG38 <- function(mitor_sof) {
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
  
  BWA <- sprintf("%s/BWA/usr/bin/bwa", mitor_sof)
  GATK <- sprintf("%s/gatk-4.3.0.0/gatk-package-4.3.0.0-local.jar", mitor_sof)
  SAMTOOLS <- sprintf("%s/Samtools/samtools-1.16.1/samtools", mitor_sof)
  
  system2(BWA, sprintf("index -a is %s", referenceN))
  system2("java", sprintf("-jar %s CreateSequenceDictionary -R %s", GATK, referenceN))
  system2(SAMTOOLS, sprintf("faidx %s", referenceN))
  return(referenceN)
}