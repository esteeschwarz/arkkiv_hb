# 20240824(06.37)
# 14351.transkribus page > TEI conversion
#########################################
# Q: https://github.com/biblhertz/trans2tei_workshop

# python setup
 library(reticulate)
# conda_create("trans-env",python_version = "3.12")
# use_miniconda("trans-env")
 use_condaenv("trans-env")
# py_version()
# use_python("/Users/guhl/Library/r-miniconda-arm64/envs/trans-env/bin/python")
# use_python("3.12")
# system("ls /Users/guhl/Library/r-miniconda-arm64/envs/trans-env/bin")
# system("python --version")
# use_mini
# miniconda_python_version()
# conda_python()
# conda_list()
# conda_binary()
# conda_install(packages = "subprocess")
# #system("pip install subprocess")
# no.
#####
python<-"/Users/guhl/Documents/GitHub/fork/trans2tei/simplify.py"
 export<-"exports/HB2024/mets.xml"
 output<-"/Users/guhl/Documents/GitHub/arkkiv_hb/working/TEI/hb09201.tei.xml"
# setwd("/Users/guhl/Documents/GitHub/fork/trans2tei")
system(sprintf("python3 simplify.py -i %s -o %s",export,output))
system("ls")
system("cd /Users/guhl/Documents/GitHub/fork/trans2tei")
#system("python3 simplify.py -i exports/HB2024/mets.xml -o out/HB2024-tei001.xml")
library(clipr)
write_clip(sprintf("python3 %s -i %s -o %s",python,export,output))
run<-"python3 simplify.py -i exports/HB2024/mets.xml -o out/HB2024-tei001.xml"
run.files<-sprintf("")
system("python3 ")
