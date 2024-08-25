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

get.transcript<-function(api.init,get_mets=T,get_page=F){
collection_id<-api.init$collection_id
document_id<-api.init$document_id
access_token<-api.init$sessionId
### endpoints:
# transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/411671/list"
# transcript_url<-"https://transkribus.eu/TrpServer/rest/user/listMyDocs"
# transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/%s/%s/fulldoc.xml",collection_id,document_id)
# transcript_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/fulldoc.xml",collection_id,document_id)
####
# POST:
# /export endpoint: you receive a link via email to a zip containing the document as page, alto format and the mets.xml
# export_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/export",collection_id,document_id)
# export_url
page_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/%s/text",collection_id,document_id,get_page)
mets_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/mets",collection_id,document_id)
####
mets.xml<-NULL
page.xml<-NULL
if(get_page){
  page_response <- GET(page_url, 
                       add_headers(Authorization = paste("sessionId", access_token)))
  page.xml<-content(page_response,"text")
}
if(get_mets){
  mets_response <- GET(mets_url, add_headers(Authorization = paste("sessionId", access_token)))
  mets.xml<-content(mets_response,"text")
}
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
    f.anon<-gsub(regx,"#anon#",f.anon)
    
  }
  return(f.anon)
}

make.tei<-function(exports,output){
  setwd("/Users/guhl/Documents/GitHub/fork/trans2tei")
  # calls python script and builds TEI of mets.xml in repo/exports folder
  system(sprintf("python3 simplify.py -i %s -o %s",exports,output))
}