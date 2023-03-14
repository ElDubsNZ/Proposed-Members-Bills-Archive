#JSON Request - Output URLs of bills
curl 'https://bills.parliament.nz/api/data/search' \
  -K /home/waybackMachine/headers.txt \
  --data-raw '{"documentPreset":3,"keyword":null,"selectCommittee":null,"itemType":null,"itemSubType":null,"status":[],"documentTypes":[],"beforeCommittee":null,"billStage":null,"billStages":[],"billTab":null,"billId":null,"includeBillStages":null,"subject":null,"person":null,"parliament":null,"dateFrom":null,"dateTo":null,"datePeriod":null,"restrictedFrom":null,"restrictedTo":null,"terminatedReason":null,"terminatedReasons":[],"column":4,"direction":1,"pageSize":100,"page":1}' \
  --compressed | grep -o '"id":"[A-Za-z0-9-]*"' | cut -d'"' -f4 | sort -u | sed 's|^|https://bills.parliament.nz/v/1/|' > /home/waybackMachine/bills.txt

#PDFs
while read b; do
url=$(echo $b | sed 's|https://bills.parliament.nz/v/1/|https://bills.parliament.nz/api/data/ProposedMembersBill/|')
pdf=$(curl $url \
  -K /home/waybackMachine/headers.txt \
  --compressed | grep -o '"AttachmentId":"[A-Za-z0-9-]*"' | cut -d'"' -f4 | sort -u | sed 's|^|https://bills.parliament.nz/download/ProposedMembersBill/|')
  list="${list}\n${pdf}"
done </home/waybackMachine/bills.txt
printf "$list" | sort -u > /home/waybackMachine/pdfs.txt
sed -i '/./,$!d' /home/waybackMachine/pdfs.txt

#Run SPN
/home/waybackMachine/spn.sh https://bills.parliament.nz/proposed-members-bills
/home/waybackMachine/spn.sh /home/waybackMachine/bills.txt
/home/waybackMachine/spn.sh /home/waybackMachine/pdfs.txt
