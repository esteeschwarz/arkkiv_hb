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
- get mets.xml via transkribus rest API (includes encoded annotations) + page.xml (each page)
- anonymise page.xml
- run python script over page/* folder (cf. this workflow: <https://github.com/biblhertz/trans2tei_workshop>)
- outputs TEI with metadata & annotations (structural, editorial, textual) made in transkribus
### work with text
#### NE anonymisation
- script: [NE_anonymise.R](scripts/NE_anonymise.R) (cf. <https://github.com/lipogg/textanalyse-mit-r/blob/main/10-NER.Rmd>)