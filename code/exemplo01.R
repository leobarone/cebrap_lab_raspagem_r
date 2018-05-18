# 0 - carregar pacote rvest
library(rvest)

# 1 - anotar o url da pagina sem numero
url_portal <- "http://www.portaldatransparencia.gov.br/servidores/Servidor-ListaServidores.asp?bogus=1&Pagina="

# 5 - passar para a página seguinte
# 6 - repetir 3,4 e 5 até 70 mil ou até quando for impossível ou até a última
dados <- data.frame()
for (indice_pagina in 1:5){
  # 2 - construir url completo da pagina
  url_completo <- paste0(url_portal, indice_pagina)
  
  # 3 - extrair a informação da pagina atual
  pagina <- read_html(url_completo)
  tabela <- html_table(pagina)[[1]]
  
  # 4 - armazenar informação
  dados <- rbind(dados, tabela)  
}

