#This creates a log of all bills for future use.
response=$(curl 'https://bills.parliament.nz/api/data/search' \
  -K /home/eldubs/waybackMachine/headers.txt \
  --data-raw '{"documentPreset":3,"keyword":null,"selectCommittee":null,"itemType":null,"itemSubType":null,"status":[],"documentTypes":[],"beforeCommittee":null,"billStage":null,"billStages":[],"billTab":null,"billId":null,"includeBillStages":null,"subject":null,"person":null,"parliament":null,"dateFrom":null,"dateTo":null,"datePeriod":null,"restrictedFrom":null,"restrictedTo":null,"terminatedReason":null,"terminatedReasons":[],"column":4,"direction":1,"pageSize":100,"page":1}' \
  --compressed)

ids=$(echo "$response" | grep -o '"id":"[^"]*"')
titles=$(echo "$response" | grep -o '"title":"[^"]*"')
partyNames=$(echo "$response" | grep -o '"partyName":"[^"]*"')
memberNames=$(echo "$response" | grep -o '"memberName":"[^"]*"')
publicationDates=$(echo "$response" | grep -o '"publicationDate":"[^"]*"')
lastModifiedDates=$(echo "$response" | grep -o '"lastModified":"[^"]*"')

timestamp=$(date +'%Y%m%d%H%M%S')
filename="bills_${timestamp}.csv"
for i in $(seq 1 $(echo "$ids" | wc -l)); do
    id=$(echo "$ids" | sed -n "${i}p" | cut -d'"' -f4)
    title=$(echo "$titles" | sed -n "${i}p" | cut -d'"' -f4)
    partyName=$(echo "$partyNames" | sed -n "${i}p" | cut -d'"' -f4)
    memberName=$(echo "$memberNames" | sed -n "${i}p" | cut -d'"' -f4)
    publicationDate=$(echo "$publicationDates" | sed -n "${i}p" | cut -d'"' -f4)
    lastModified=$(echo "$lastModifiedDates" | sed -n "${i}p" | cut -d'"' -f4)
    echo "$id,\"$title\",\"$partyName\",\"$memberName\",$publicationDate,$lastModified" >> "/home/eldubs/waybackMachine/log/$filename"
done

# Finds the names of the two newest files in the log directory
newest=$(find /home/eldubs/waybackMachine/log -type f -printf "%T@ %p\n" | sort -nr | head -1 | awk '{print $2}')
secondNewest=$(find /home/eldubs/waybackMachine/log -type f -printf "%T@ %p\n" | sort -nr | head -2 | tail -1 | awk '{print $2}')

# Compares the two files using 'cmp'
if ! cmp -s "$newest" "$secondNewest"; then
  #If there is a change, runs spnBills.sh
  /home/eldubs/waybackMachine/spnBills.sh
fi
