# Pull CDC's github repo from https://github.com/cdcepi/zika
# Place this script in main (top level) directory and run
# Script produces a directory 'data' containing subdir for each country
#   which contains:
#     (1) all individual country csv files, and
#     (2) an all.csv file containing all country data

# make new directory for all final data
mkdir data
# recreate all country directories in this new data directory
for f in *; do
    if [[ -d $f ]]; then
        mkdir data/"$f"
    fi
done

# copy all .csv files from each old company directory into new company directories, filter and flatten
for f in *; do
    if [[ -d $f ]] && [ $f != 'data' ]; then
      # copy over all files
      rsync -av --include='*[0-9].csv' --include='*/' --exclude='*' "$f"/ data/"$f"
      # flatten directory
      find data/"$f" -mindepth 2 -type f -exec mv -i '{}' data/"$f" ';'
      # delete Florida Department of Health data (redundant?)
      find data/"$f" -type f -name '*FDH_Arbovirus*' -delete
    fi
done

# clean up emtpy directories
find data/ -type d -empty -delete

# create final csv, for each country, with all country data
for f in data/*; do
    # first get field names
    for entry in "$f"/*; do
      name="$f"_all
      name=${name#*/}
      head -n 1 "$entry" > "$f"/"$name".csv
      # add head to final csv (anticipating final loop below)
      head -n 1 "$entry" > data/all.csv
    done
    # then add all actual data
    for entry in "$f"/*; do
      if [[ $entry != *'all'* ]]; then
        tail -n +2 "$entry" >> "$f"/"$name".csv
      fi
    done
done


# create final csv with all data
for f in data/*; do
    for entry in "$f"/*; do
      if [[ $entry == *'all'* ]]; then
        tail -n +2 "$entry" >> data/all.csv
      fi
    done
done
