awk -F"\t" -v OFS="\t" '{print $0 FS $5}' $1 | sed 's/^\(.*\)[0-9]\.[0-9][0-9][0-9]$/\1/' | awk -F"\t" -v OFS="\t" '!seen[$13,$30,$123,$NF]++' | awk -F"\t" -v OFS="\t" '{$NF="";$1=$1;print $0}' > $1.clean
mv -f $1.clean $1
