library(jsonlite)
library(dplyr)
library(RCurl)
library(tidyr)
library(stringr)
library(data.table)
library(parsedate)
setwd("~/r-studio-workspace/bitcoin/grin")

load(file="./data/blocks.RData")

START <- 0
if (exists("blocks")) START <- max(blocks$height)+1
STOP <- fromJSON("http://127.0.0.1:3413/v1/chain")$height

for (i in (START:STOP)){
  try({
    print(i)
    tmp <- fromJSON(paste0("http://127.0.0.1:3413/v1/headers/", i))
    data <- data.frame(tmp$height, tmp$hash, tmp$version, tmp$timestamp, tmp$nonce, tmp$edge_bits, tmp$total_difficulty, tmp$secondary_scaling, tmp$total_kernel_offset)
    names(data) <- c("height", "hash", "version", "timestamp_str", "nonce", "edge_bits", "total_difficulty", "secondary_scaling", "total_kernel_offset")
    data$delta <- 0
    data$timestamp <- parse_iso_8601(data$timestamp_str)
    if (exists("blocks")){
      blocks$delta <- 0
      blocks <- rbind(blocks, data)
    } else 
      blocks <- data
  })
}
names(blocks) <- c("height", "hash", "version", "timestamp_str", "nonce", "edge_bits", "total_difficulty", "secondary_scaling", "total_kernel_offset", "timestamp", "delta")
blocks <- unique(blocks)
blocks$timestamp <- parse_iso_8601(blocks$timestamp_str)
#blocks$version <- as.numeric(blocks$version)
#blocks$edge_bits <- as.factor(blocks$edge_bits)
blocks$delta  <- c(0,tail(blocks$timestamp, -1) - head(blocks$timestamp, -1))
save(blocks, file="./data/blocks.RData")
