
# Load libraries ----------------------------------------------------------

library(tidyverse)
library(rtracklayer)
library(R.utils)

# Main --------------------------------------------------------------------

gtf_path <- file.path(tempdir(), "Homo_sapiens.GRCh38.105.chr.gtf.gz")

# download ens 105 gtf
download.file(
    stringr::str_c(
        "http://ftp.ensembl.org/pub/release-105/gtf/homo_sapiens/",
        "Homo_sapiens.GRCh38.105.chr.gtf.gz"
    ),
    destfile = gtf_path
)

# unzip gtf
R.utils::gunzip(gtf_path)

gtf_path <- gtf_path %>%
    stringr::str_remove("\\.gz$")

gtf <- rtracklayer::import(gtf_path)

# extract example gene transcripts
# convert to tibble()
sod1_annotation <-
    gtf[!is.na(gtf$gene_name) & gtf$gene_name == "SOD1"] %>%
    as.data.frame() %>%
    dplyr::as_tibble() %>%
    dplyr::select(
        seqnames,
        start,
        end,
        strand,
        type,
        gene_name,
        transcript_name,
        transcript_biotype
    )

pknox1_annotation <-
    gtf[!is.na(gtf$gene_name) & gtf$gene_name == "PKNOX1"] %>%
    as.data.frame() %>%
    dplyr::as_tibble() %>%
    dplyr::select(
        seqnames,
        start,
        end,
        strand,
        type,
        gene_name,
        transcript_name,
        transcript_biotype
    )

# Save data ---------------------------------------------------------------

usethis::use_data(
    sod1_annotation,
    compress = "gzip",
    overwrite = TRUE
)

usethis::use_data(
    pknox1_annotation,
    compress = "gzip",
    overwrite = TRUE
)
