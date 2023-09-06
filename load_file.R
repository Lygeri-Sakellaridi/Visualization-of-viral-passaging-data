load_file <- function(name, path) {
  ext <- tools::file_ext(name)
  switch(ext,
         csv = arrow::read_csv_arrow(path),
         tsv = arrow::read_tsv_arrow(path),
         validate("Invalid file; Please upload a .csv or .tsv file")
  )
}