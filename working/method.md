# method.info
#### 14345
----
## prerequisites
- import .tiff to mac photos, export .png (big, most compatibel), ca. 150-700 KB each
- upload .png folder (267 items) to transkribus
- edit metadata
- customise tagsystem
## TODO
- [ ] refine tags to applying to finalised TEI scheme according HA
  - [ ] attributes for each
- [x] anonymise names
## process
### OCR
configuration:
![](alii/OCR_conf.png)
### annotation
- assign tags to transcript passages
### export
- get mets.xml via [transkribus rest API](https://readcoop.eu/transkribus/docu/rest-api/) (includes encoded annotations) + page.xml (each page)
- anonymise page.xml
- run python script over page/* folder (cf. this workflow: <https://github.com/biblhertz/trans2tei_workshop>)
- outputs TEI with metadata & annotations (structural, editorial, textual) made in transkribus
### work with text
#### NE anonymisation
- script: [NE_anonymise.R](scripts/NE_anonymise.R) (cf. <https://github.com/lipogg/textanalyse-mit-r/blob/main/10-NER.Rmd>)
#### transkribus rest API
[script](scripts/transkribus-api.R)   
process:   
- make a curl POST request to the auth/login endpoint providing username and password
  - extract the sessionId from the response
- make a curl GET request to the collection/mets endpoint providing collection ID, document ID and the sessionId from the request before
  - response is the mets.xml containing all information to build the document TEI with above mentioned workflow trans2tei

1. 
Shell   
```{Bash}
$ curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "user=sampleuser&pw=samplepw" https://transkribus.eu/TrpServer/rest/auth/login
```

R
```{R}
# Define the URL
  url <- "https://transkribus.eu/TrpServer/rest/auth/login"
  
  # Create a list of parameters (user and pw)
  user.params <- list(user = username, pw = password)
  
  # Send an HTTP POST request
  response <- POST(url, body = user.params, encode = "form",accept_xml())
```

2. 
R
```{R}
mets_url<-sprintf("https://transkribus.eu/TrpServer/rest/collections/%s/%s/mets",collection_id,document_id)
mets_response <- GET(mets_url, add_headers(Authorization = paste("sessionId", access_token)))
```