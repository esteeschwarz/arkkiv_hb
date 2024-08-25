# 20240824(06.37)
# 14351.transkribus page > TEI conversion
#########################################
# Q: https://github.com/biblhertz/trans2tei_workshop

### from functions()
source("~/Documents/GitHub/arkkiv_hb/working/scripts/functions.R")
# initialise
## python
#conda_create("trans-env",python_version = "3.12")
use_condaenv("trans-env")
###
#setwd("/Users/guhl/Documents/GitHub/fork/trans2tei")
basefolder<-"/Users/guhl/Documents/GitHub/fork/trans2tei"
exports<-"exports/HB2024/mets.xml"
mets.ns<-paste(basefolder,exports,sep = "/")
output<-"/Users/guhl/Documents/GitHub/arkkiv_hb/working/TEI/hb09201.tei.xml"
pagefolder<-"exports/HB2024/page"
collection_id<-989514
document_id <- 3781616
page.range<-c(1:8)
api.init<-init.api(collection_id,document_id)
###
# anonymise for each transcribed page:
#k<-8
#k
fun.obs<-function(){
for (k in page.range){
response<-get.transcript(api.init,k,page.xml = T,mets.xml = T)
page.xml<-read_xml(response$page)
#xml_text(page.xml)
xml.temp<-tempfile("page.xml")
write_xml(page.xml,xml.temp)
#unlist(response$mets)
#mets.lines<-readLines(unlist(response$mets))
# mets.xml<-read_xml(response$mets)
# write_xml(mets.xml,"/Users/guhl/boxHKW/21S/DH/local/EXC2020/excHB2024/page2tei/exports/HB2024/mets.xml")
#writeLines(mets.lines,"~/temp/testapimets.xml")
#writeLines(mets.lines,"/Users/guhl/boxHKW/21S/DH/local/EXC2020/excHB2024/page2tei/exports/HB2024/mets.xml")
#writeLines(mets.lines,"/Users/guhl/boxHKW/21S/DH/local/EXC2020/excHB2024/page2tei/exports/HB2024/mets.xml")
# to be written to page2tei export folder !!!!
page.lines<-readLines(xml.temp)
#############################
### > this is useless since the page2tei python script fetches the page resources according to the 
# .mets file where the href of all ressources is on the transkribus server, so the local copies of the
# page files are obsolete, you only need the .mets file to build the TEI
xml.anon<-anon.NE(page.lines)
#############################
### get ns for original export files in export folder
f<-list.files(paste(basefolder,pagefolder,sep = "/"))
out.ns<-paste(basefolder,pagefolder,f[k],sep = "/")
out.ns
writeLines(xml.anon,out.ns)
#xml.lines<-readLines(output)
}
}
### fetch mets.xml
response<-get.transcript(api.init,get_page =F,get_mets= T)
mets.xml<-read_xml(response$mets)
mets.ns
write_xml(mets.xml,mets.ns)
getwd()
cat("all ressources fetched...\nnow performing TEI transformation\n")
make.tei(exports,output)
### anon:
tei.xml<-readLines(output)
tei.anon<-anon.NE(tei.xml)
writeLines(tei.anon,output)
