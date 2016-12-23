#!/bin/bash

# Database setup script


# Download csvs from internet and store in local
echo "Deleting old PISA files and downloading new PISA data from internet"
rm school_data.csv parents_data.csv 'Pisa_dataset 10%.csv' country.csv
wget https://www.dropbox.com/sh/36g85axzriuvdjp/AABHk4JhO4ysvOqB7r0g5cZEa/Pisa_dataset%2010%25.csv
wget https://www.dropbox.com/sh/36g85axzriuvdjp/AADOSTWC9a0AkjB_0V2Fd08qa/parents_data.csv
wget https://www.dropbox.com/sh/36g85axzriuvdjp/AAAqgaq32vOx3TRvHF1T2hg9a/school_data.csv
wget https://www.dropbox.com/sh/36g85axzriuvdjp/AABZdECmPYSfYo1LUo-QfeX5a/country.csv
echo "Done"

# mysql username and password
echo "Enter mysql username:"
read user
echo "Enter mysql password:"
read pswd

# call the mysql script that will generate and populate the schema in mysql
echo "Creating mysql schema and loading data"
mysql -u $user -p$pswd --local-infile < schema2.sql
echo "Done"
# delete csvs from local directory
echo "Removing csv files"
#rm school_data.csv?dl=0 parents_data.csv?dl=0 final_ds.csv?dl=0
echo "Done"

# call the r script to carry out regression and create html output for app
Rscript r_script.R
