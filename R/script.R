# script para ler a tabela limpa
# o dado original esta no arquivo ex04.xlsx

data_format <- read.csv(file = "./data/data_format.csv")
colnames(data_format) <- c("sp", "sep_comp", "sep_larg", "pet_comp", "pet_larg")
