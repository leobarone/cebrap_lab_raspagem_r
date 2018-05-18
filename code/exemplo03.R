rm(list=ls())
library(cepespR)
library(rvest)
library(dplyr)

candidatos <- candidates(year = 2014, position = "Federal Deputy")

candidatos <- candidatos %>%
  rename(titulo = NUM_TITULO_ELEITORAL_CANDIDATO, 
         nome = NOME_URNA_CANDIDATO, 
         partido = SIGLA_PARTIDO,
         status = COD_SIT_TOT_TURNO) %>%
  select(titulo, nome, partido, status) %>%
  filter(status ==  2 |
           status == 3)

vetor_titulos <- candidatos$titulo

filiaweb_url <- "http://filiaweb.tse.jus.br/filiaweb/filiacao/certidao/consulta.seam"

filiacoes <- data.frame()
j <- 1
for (titulo in vetor_titulos){
  
  print(j)
  j <- j + 1
  
  
  filiaweb_session <- html_session(filiaweb_url)
  filiaweb_session$url <- filiaweb_url
  
  filiaweb_form_list <- filiaweb_url %>%
    read_html() %>%
    html_form() 
  
  filiaweb_form <- filiaweb_form_list[[1]]
  
  filiaweb_form_filled <- set_values(filiaweb_form,
                                     'j_id206:inscricao:inscricaoInput' = titulo)
  
  filiaweb_submission <- submit_form(session = filiaweb_session, 
                                     form = filiaweb_form_filled, 
                                     submit =  "j_id206:gerarCertidao")
  
  tabela <- html_table(filiaweb_submission)[[1]]
  
  if (nrow(tabela) > 0){
    
    filiacoes <- rbind(filiacoes,
                       data.frame(titulo, 
                                  tabela))
  }
  
}

candidatos <- candidatos %>%
  left_join(filiacoes, "titulo")
