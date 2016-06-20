#! /bin/bash

# Pull CDC's github repo from https://github.com/cdcepi/zika
# Place this script in United_States/CDC_Report/data
# Script combines all csv files into a single file for easy processing

head -n 1 CDC_Report-2016-02-24.csv > US_data_all.csv
for fname in CDC*.csv
do
    echo 	$fname
    tail -n +2 $fname >> US_data_all.csv
done