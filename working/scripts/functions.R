### global functions
library(httr)
library(xml2)
library(reticulate)

init.api<-function(collection_id,document_id){
  # Set your Transkribus credentials
  cred<-read.csv("~/boxHKW/21S/DH/local/R/cred_gener.csv")
  m<-grep("transkribus",cred$q)
  username <- "your_username"
  password <- "your_password"
  username<-cred$bn[m]
  password<-cred$pwd[m]
  
  # lateiner
  # collection_id <- 411671
  # document_id <- 2917647
  # 
  # # HB2024:
  # collection_id<-989514
  # document_id <- 3781616
  
  # Define the URL
  url <- "https://transkribus.eu/TrpServer/rest/auth/login"
  
  # Create a list of parameters (user and pw)
  user.params <- list(user = username, pw = password)
  
  # Send an HTTP POST request
  response <- POST(url, body = user.params, encode = "form",accept_xml())
  
  # Extract the content from the response
  content <- content(response, "text")
  
  # Print the content (or handle it as needed)
  cat(content)
  library(xml2)
  ###
  # Extract the access token
  xml<-read_xml(content)
  access_token <- xml_text(xml_find_first(read_xml(content), "//sessionId"))
  return(list(collection_id=collection_id,document_id=document_id,sessionId=access_token))
  
}

get.transcript<-function(api.init,page,mets.xml,page.xml){
collection_id<-api.init$collection_id
document_id<-api.init$document_id
access_token<-api.init$sessionId
### endpoints:
# transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/411671/list"
# transcript_url<-"https://transkribus.eu/TrpServer/rest/user/listMyDocs"
#transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/411671/2917647/fulldoc.xml"
#  transcript_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/fulldoc.xml",collection_id,document_id)
#  ###
# # POST:
# export_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/export",collection_id,document_id)
# export_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/export",collection_id,document_id)
# export_url
# curl_url<-sprintf('https://transkribus.eu/TrpServer/rest/collections/%s/%s/export',collection_id,document_id)
# curl<-sprintf('curl -X POST -H "Content-Type: application/json" -H "sessionId: %s" -d "doWriteTei:true" %s',
#               access_token,curl_url)
# curl<-sprintf('curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "sessionId: %s" -d "doWriteTei:true" %s',
#               access_token,curl_url)
# curl<-sprintf('curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "username: %s -d "pw: %s" -d "doWriteTei:true" %s',
#               username,password,curl_url)
# curl<-sprintf('curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "username: %s" -d "pw: %s" -d "doWriteTei:true" https://transkribus.eu/TrpServer/rest/collections/%s/%s/export',
#               username,password,collection_id,document_id)
# curl<-sprintf('curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "%s" https://transkribus.eu/TrpServer/rest/collections/%s/%s/export',
#               jsonparams,collection_id,document_id)
# curl
pages<-1:267
#page<-8
page_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/%s/text",collection_id,document_id,page)
page_url
# transcript_url
mets_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/mets",collection_id,document_id)
# transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/411671/2917647/5/curr"
# transcript_url<-"https://files.transkribus.eu/Get?id=RDKCGHQCNKBZZQOJWZBSTWBZ"
# transcript_url<-"https://files.transkribus.eu/Get?id=UIUHMGJUABGKAGCABJFMEJJB" #HB2024 pg.3
"UIUHMGJUABGKAGCABJFMEJJB"
page_response <- GET(page_url, add_headers(Authorization = paste("sessionId", access_token)))
mets_response <- GET(mets_url, add_headers(Authorization = paste("sessionId", access_token)))
#cat(content(transcript_response,"text"))
# Save the transcript to a file
#writeLines(content(transcript_response, "text"), "TEI/api-export_transcript.xml")
page.xml<-content(page_response,"text")
mets.xml<-content(mets_response,"text")
#writeLines(xml,"~/boxHKW/21S/DH/local/EXC2020/excHB2024/transkribus/apiexpo-p03.xml")
#out.page<-"~/boxHKW/21S/DH/local/EXC2020/excHB2024/transkribus/apiexpo-page.xml"
#out.mets<-"~/boxHKW/21S/DH/local/EXC2020/excHB2024/transkribus/apiexpo-mets.xml"
#writeLines(page.xml,out.page)
#writeLines(mets.xml,out.mets)
return.list<-list(mets=mets.xml,page=page.xml)
return(return.list)
}

get.pg.number<-function(mets.lines){
  xml.mets<-read_xml(paste0(mets.lines,collapse = ""))
  all.files<-xml_find_all(xml.mets,"//ns3:FLocat")
}
anon.NE<-function(xml.lines){
  load("~/boxHKW/21S/DH/local/EXC2020/excHB2024/NE_anon.RData")
  #for (k in 1:length(f)){
  f.anon<-xml.lines
  for (regx in ent.anon.sep){
    f.anon<-gsub(regx," #anon# ",f.anon)
    
  }
 # writeLines(f.anon,f[k])
 # cat("written",f[k],"\n")
  #}
  return(f.anon)
}


make.tei<-function(exports,output){
 # export<-"exports/HB2024/mets.xml"
  #output<-"/Users/guhl/Documents/GitHub/arkkiv_hb/working/TEI/hb09201.tei.xml"
  setwd("/Users/guhl/Documents/GitHub/fork/trans2tei")
  system(sprintf("python3 simplify.py -i %s -o %s",exports,output))
}