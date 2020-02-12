# aula 5: Manipulação de dados em bases relacionais, 12 Feb 2020
# parte do curso Projetos de análise de dados em R
# dados originais extraídos de Jeliazkov et al 2020 Sci Data
# (https://doi.org/10.1038/s41597-019-0344-7)

library("tidyr")

# carregando os dados

files.path <- list.files(path = "./data/cestes/",
                         pattern = ".csv",
                         full.names = TRUE)

comm <- read.csv(files.path[1])
coord <- read.csv(files.path[2])
envir <- read.csv(files.path[3])
splist <- read.csv(files.path[4])
traits <- read.csv(files.path[5])

# qual é a riqueza de cada site?

## teste lógico para ver se as células são maiores que 0
comm.pa <- comm[, -1] > 0

## nomear as linhas das planilhas com o id dos sites
row.names(comm.pa) <- envir$Sites

## riqueza do site 1 corresponde à soma dos valores da primeira linha de comm.pa
sum(comm.pa[1, ])

## aplicar a soma a todas as linhas de comm.pa (97 sites)
rich <- apply(X = comm.pa,
              MARGIN = 1, # sendo X uma matriz, 1 = linhas, 2 = colunas
              FUN = sum)
summary(rich)

## a riqueza média é 6.6, mínimo 1 e máximo 15


# juntar coordenadas (coord) às variáveis ambientais (environ)

## corrigindo a classe das variaveis categóricas
coord$Sites <- as.factor(coord$Sites)
envir$Sites <- as.factor(envir$Sites)

envir.coord <- merge(x = envir,
                     y = coord,
                     by = "Sites")
dim(envir)
dim(coord)
dim(envir.coord)
head(envir.coord)

## a tabela nova (coord.envir) contem 11 colunas. foram adicionadas duas colunas à envir, X e Y


# transformar uma matriz espécie/sites em uma tabela de dados

## vetor contendo todos os Sites
Sites <- envir$Sites
length(Sites)

## vetor com o número de espécies
n.sp <- nrow(splist)
n.sp

## criando tabela com cada especie em cada area especies em linhas
comm.df <- gather(comm[, -1])

## modificando os nomes das colunas
colnames(comm.df) <-  c("TaxCode", "Abundance")

## criando a sequência de nomes de sites para adicionar a comm.df
seq.site <- rep(Sites,
                times = n.sp) # times repete a sequencia inteira x vezes. each repete cada valor da sequência x vezes

## adicionando os nomes ao objeto comm.df
comm.df$Sites <- seq.site

## checando como ficou
head(comm.df)
tail(comm.df)

# juntando todas as variáveis a comm.df, par a par
head(comm.df)

## primeiro comm.df e splist
comm.sp <- merge(comm.df,
                 splist,
                 by = "TaxCode")

## segundo, comm.sp e traits
## renomeando a coluna que vai ligar as duas planilhas
colnames(traits)[1] <- "TaxCode"

## merging
comm.traits <- merge(comm.sp,
                     traits,
                     by = "TaxCode")

## terceiro, comm.traits e envir.coord
comm.total <- merge(comm.traits,
                    envir.coord,
                    by = "Sites")

# salvando a planilha completa para análise
write.csv(x = comm.total,
          file = "data/01_data_format_combined.csv",
          row.names = FALSE)
