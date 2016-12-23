# PISA-Motivation-Analysis
A project to determine factors that have most effect on student motivation through exploration of PISA 2012 dataset

schema2.sql launches the process of downloading raw data from the dropbox, creates a schema to a database, launches an r script and processes with calcilation and map creation. 
Google vis has been utilised for interactive maps. 

Website is based on flask backend and is launched using pisa.py with number of webpages linked through the templates folder. 


##Database Design
PISA dataset has been cleaned and sampled, after which schools, students and parents data sets have been created. 
Additionally Macro economic factors have been imported as an additional table for the purpose of running regression 

##Regression analysis
Regression has been run through R, by selecting variables based on literature review and combining features representing similar entropy, which was identified using covarience analysis. 

##Application implementation
Application is run through python based FLASK framework, using Google vis for interactive graphing. 



