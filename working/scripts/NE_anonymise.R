library(readtext)
hb_test <- readtext(file="~/boxHKW/21S/DH/local/EXC2020/excHB2024/HB2024/HB2024.txt")

install.packages("spacyr")
library("spacyr")

spacy_install(version = "apple")

library("spacyr")
library(reticulate)
#reticulate::use_python("./nlp-env/bin/python")
reticulate::conda_create("nlp-env",python_version = "3.12")
reticulate::use_python("/Users/guhl/Library/r-miniconda/envs/nlp-env/bin/python")

reticulate::use_condaenv("nlp-env")
#reticulate::use_python("/Users/guhl/.virtualenvs/r-spacyr/bin/python3.12")

spacy_download_langmodel("de_core_news_lg")

spacy_initialize(model = "de_core_news_lg")

results <- spacy_parse(hb_test, lemma = FALSE, entity = TRUE)
results_entities <- entity_extract(results)
results_entities # View(results_entities)
ent.u<-data.frame(NE=unique(results_entities$entity),decision=1,remove=0)
entities<-fix(ent.u)
ent.anon<-entities$NE[entities$remove==1]
#wks., 10 out of 86 entity occurences to anonymise



