#!/bin/bash

# Fetch the response
response=$(curl 'https://bills.parliament.nz/api/data/search' \
  -K /mnt/dubNAS/Documents/Scripting/proposedBills/headers.txt \
  --data-raw '{"documentPreset":3,"keyword":null,"selectCommittee":null,"itemType":null,"itemSubType":null,"status":[],"documentTypes":[],"beforeCommittee":null,"billStage":null,"billStages":[],"billTab":null,"billId":null,"includeBillStages":null,"subject":null,"person":null,"parliament":null,"dateFrom":null,"dateTo":null,"datePeriod":null,"restrictedFrom":null,"restrictedTo":null,"terminatedReason":null,"terminatedReasons":[],"column":4,"direction":1,"pageSize":100,"page":1}' \
  --compressed)

# Generate a unique filename with timestamp
timestamp=$(date +'%Y%m%d%H%M%S')
filename="/mnt/dubNAS/Documents/Scripting/proposedBills/log/bills_${timestamp}.csv"

# Extract the data while maintaining alignment
echo "$response" | grep -o '{"id":[^}]*}' | while IFS= read -r line; do
  # Decode Unicode sequences and clean line of any control characters
  line=$(echo "$line" | perl -CSD -pe 's/\\u([0-9a-fA-F]{4})/chr(hex($1))/ge' | tr -d '\n' | tr -d '\r' | sed 's/\\n/ /g')

  # Extract fields and sanitize
  id=$(echo "$line" | grep -o '"id":"[^"]*"' | cut -d'"' -f4 | sed 's/^ *//;s/ *$//')
  title=$(echo "$line" | grep -o '"title":"[^"]*"' | cut -d'"' -f4 | sed 's/^ *//;s/ *$//' | sed 's/\\n/ /g')
  partyName=$(echo "$line" | grep -o '"partyName":"[^"]*"' | cut -d'"' -f4 | sed 's/^ *//;s/ *$//' | sed 's/\\n/ /g')
  memberName=$(echo "$line" | grep -o '"memberName":"[^"]*"' | cut -d'"' -f4 | sed 's/^ *//;s/ *$//' | sed 's/\\n/ /g')
  publicationDate=$(echo "$line" | grep -o '"publicationDate":"[^"]*"' | cut -d'"' -f4 | sed 's/^ *//;s/ *$//')
  lastModified=$(echo "$line" | grep -o '"lastModified":"[^"]*"' | cut -d'"' -f4 | sed 's/^ *//;s/ *$//')

  # Append to the CSV file
  echo "$id,\"$title\",\"$partyName\",\"$memberName\",$publicationDate,$lastModified" >> "$filename"
done

# Finds the names of the two newest files in the log directory
newest=$(find /mnt/dubNAS/Documents/Scripting/proposedBills/log/ -type f -printf "%T@ %p\n" | sort -nr | head -1 | awk '{print $2}')
secondNewest=$(find /mnt/dubNAS/Documents/Scripting/proposedBills/log/ -type f -printf "%T@ %p\n" | sort -nr | head -2 | tail -1 | awk '{print $2}')

# Compares the two files using 'cmp'
if [ -n "$secondNewest" ] && ! cmp -s "$newest" "$secondNewest"; then
  # If there is a change, runs spnBills.sh
  /mnt/dubNAS/Documents/Scripting/proposedBills/spnBills.sh
fi
