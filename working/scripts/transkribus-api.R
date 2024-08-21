library(httr)
library(xml2)
getwd()
# Set your Transkribus credentials
cred<-read.csv("~/boxHKW/21S/DH/local/R/cred_gener.csv")
m<-grep("transkribus",cred$q)
username <- "your_username"
password <- "your_password"
username<-cred$bn[m]
password<-cred$pwd[m]

# lateiner
collection_id <- 411671
document_id <- 2917647

# HB2024:
collection_id<-989514
document_id <- 3781616

# wks. in shell:
#curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "user=sampleuser&pw=samplepw" https://transkribus.eu/TrpServer/rest/auth/login

####
library(httr)

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
access_token
###
# transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/411671/list"
# transcript_url<-"https://transkribus.eu/TrpServer/rest/user/listMyDocs"
# transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/411671/2917647/fulldoc.xml"
###
# POST:
export_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/export",collection_id,document_id)
export_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/export",collection_id,document_id)
export_url
curl<-sprintf('curl -X POST -H "Content-Type: application/json" -H "sessionId: %s" -d "doWriteTei:true" https://transkribus.eu/TrpServer/rest/collections/%s/%s/export',
              access_token,collection_id,document_id)
curl<-sprintf('curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "username: %s" -d "pw: %s" -d "doWriteTei:true" https://transkribus.eu/TrpServer/rest/collections/%s/%s/export',
              username,password,collection_id,document_id)
curl<-sprintf('curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "%s" https://transkribus.eu/TrpServer/rest/collections/%s/%s/export',
              jsonparams,collection_id,document_id)
curl
system(curl)              
params <- list(doWriteTei = TRUE,pages="1-8",doWriteAlto=FALSE)
tei.res<-POST(export_url, json='
                "doWriteTei": TRUE')
jsonparams<-sprintf('{"user":"%s",
                "pw":"%s",
        "doWriteTei": true,
        "pages":      "1-8",
        "doWriteAlto":false
        }',username,password)
json
tei.res<-POST(export_url, params='
                "doWriteTei": TRUE')
export_response <- POST(export_url,encode = "json",
                            body=params,
                        add_headers(Authorization = paste("sessionId", access_token)))
export_response <- POST(export_url, encode = "json",
                        json=json,
                        add_headers(Authorization = paste("sessionId", access_token)))
###################################################
# wks., but >
export_response <- POST(export_url,encode = "json",
                        body=params,
                        add_headers(Authorization = paste("sessionId", access_token)))
# only releases export download but wo respect to parameters
############################################################
export_response <- POST(export_url,
                        add_headers(Authorization = paste("sessionId", access_token)))
#tei.res<-POST(export_url, body =json)
exportkey<-content(export_response,"text")
exportkey
content(tei.res,"text")
transcript_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/4/text",collection_id,document_id)
transcript_url
transcript_url<-"https://transkribus.eu/TrpServer/rest/collections/411671/2917647/5/curr"
transcript_url<-"https://files.transkribus.eu/Get?id=RDKCGHQCNKBZZQOJWZBSTWBZ"
transcript_url<-"https://files.transkribus.eu/Get?id=UIUHMGJUABGKAGCABJFMEJJB" #HB2024 pg.3
transcript_response <- GET(transcript_url, add_headers(Authorization = paste("sessionId", access_token)))
#cat(content(transcript_response,"text"))
# Save the transcript to a file
#writeLines(content(transcript_response, "text"), "TEI/api-export_transcript.xml")
xml<-content(transcript_response,"text")
writeLines(xml,"~/boxHKW/21S/DH/local/EXC2020/excHB2024/transkribus/apiexpo-p03.xml")
xml
