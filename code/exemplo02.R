library(cepespR)
library(rvest)
library(dplyr)
candidatos <- candidates(year = 2014, position = "President")

candidatos <- candidatos %>%
  rename(titulo = NUM_TITULO_ELEITORAL_CANDIDATO, nome = NOME_URNA_CANDIDATO, partido = SIGLA_PARTIDO) %>%
  select(titulo, nome, partido)

vetor_titulos <- candidatos$titulo

titulo <- vetor_titulos[1]

filiaweb_url <- "http://filiaweb.tse.jus.br/filiaweb/filiacao/certidao/consulta.seam"

filiaweb_session <- html_session(filiaweb_url)
filiaweb_session$url <- filiaweb_url

filiaweb_form_list <- filiaweb_url %>%
  read_html() %>%
  html_form() 

filiaweb_form_list

filiaweb_form <- filiaweb_form_list[[1]]

filiaweb_form

filiaweb_form_filled <- set_values(filiaweb_form,
                                   'j_id206:inscricao:inscricaoInput' = titulo)

filiaweb_form_filled

filiaweb_submission <- submit_form(session = filiaweb_session, 
                                   form = filiaweb_form_filled, 
                                   submit =  "j_id206:gerarCertidao")

filiacoes <- html_table(filiaweb_submission)[[1]]

filiacoes
