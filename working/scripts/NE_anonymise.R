library(readtext)
library(xml2)
hb_test <- readtext(file="~/boxHKW/21S/DH/local/EXC2020/excHB2024/HB2024/HB2024.txt")
hb_xml.mets<-read_xml("~/boxHKW/21S/DH/local/EXC2020/excHB2024/transkribus/apiexpo-mets.xml")
install.packages("spacyr")
library("spacyr")
spacy_install(version = "apple")
library("spacyr")
library(reticulate)
reticulate::conda_create("nlp-env",python_version = "3.12")
###no reticulate::use_python("/Users/guhl/Library/r-miniconda/envs/nlp-env/bin/python")

reticulate::use_condaenv("nlp-env")
###no reticulate::use_python("/Users/guhl/.virtualenvs/r-spacyr/bin/python3.12")

spacy_download_langmodel("de_core_news_lg")

spacy_initialize(model = "de_core_news_lg")

results <- spacy_parse(hb_test, lemma = FALSE, entity = TRUE)
results_entities <- entity_extract(results)
results_entities # View(results_entities)
ent.u<-data.frame(NE=unique(results_entities$entity),decision=1,remove=0)
#entities<-fix(ent.u)
#write.csv(entities,"~/boxHKW/21S/DH/local/EXC2020/excHB2024/NE_cpt.csv")
#save(entities,file = "~/boxHKW/21S/DH/local/EXC2020/excHB2024/entities.RData")
ent.anon<-entities$NE[entities$remove==1]
save(ent.anon.sep,file = "~/boxHKW/21S/DH/local/EXC2020/excHB2024/NE_anon.RData")
#wks., 10 out of 86 entity occurences to anonymise

text.mets<-xml_text(hb_xml.mets)
text.mets.anon
ent.anon.sep<-unlist(strsplit(ent.anon,"_"))
ent.anon.sep[2]<-""
ent.anon.sep
ent.anon.sep<-gsub("\n|¬","",ent.anon.sep)
ent.anon.sep<-ent.anon.sep[ent.anon.sep!=""]
###
f<-list.files("~/boxHKW/21S/DH/local/EXC2020/excHB2024/export_job_11742159/3781616/HB2024/page")
setwd("~/boxHKW/21S/DH/local/EXC2020/excHB2024/export_job_11742159/3781616/HB2024/page")
#k<-8
#k
anon.NE<-function(file,regex.array){
#for (k in 1:length(f)){
  f.anon<-readLines(f[k])
  for (regx in ent.anon.sep){
    f.anon<-gsub(regx," #anon# ",f.anon)
    
  }
  writeLines(f.anon,f[k])
  cat("written",f[k],"\n")
#}
  return(f.anon)
}