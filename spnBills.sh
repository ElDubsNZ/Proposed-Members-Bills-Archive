#Pages
pages=$(lynx -nonumbers -dump https://www.parliament.nz/en/pb/bills-and-laws/proposed-members-bills/?page=1 | grep page=[0-9]$)
printf "$pages" | sort -u > /home/waybackMachine/pages.txt
 
#Bills
while read p; do
  page="$(lynx -nonumbers -dump $p | grep proposed-members-bills/[A-Za-z0-9])"
  bills="${bills}\n${page}"
done </home/waybackMachine/pages.txt
printf "$bills" | sort -u > /home/waybackMachine/bills.txt
sed -i '/./,$!d' /home/waybackMachine/bills.txt
 
#PDFs
while read p; do
  pdf="$(lynx -nonumbers -dump $p | grep https://www.parliament.nz/media/)"
  list="${list}\n${pdf}"
done </home/waybackMachine/bills.txt
printf "$list" | sort -u > /home/waybackMachine/pdfs.txt
sed -i '/./,$!d' /home/waybackMachine/pdfs.txt
 
#Run SPN
/home/waybackMachine/spn.sh /home/waybackMachine/pages.txt
/home/waybackMachine/spn.sh /home/waybackMachine/bills.txt
/home/waybackMachine/spn.sh /home/waybackMachine/pdfs.txt
