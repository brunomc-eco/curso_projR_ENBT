# script para ler a tabela limpa
# o dado original esta no arquivo ex04.xlsx

data_format <- read.table(file = "data/ex04.csv",
                          sep = ",",
                          header = TRUE)
