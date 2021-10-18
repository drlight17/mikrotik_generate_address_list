#!/bin/sh
#Simple script to convert list of addresses to
#Mikrotik import file (address list feature)
#Can also parse IPs from any text file (ie csv)
#SETTINGS
#url of input file
#url="http://api.antizapret.info/group.php"
#url="https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv"
#address list in mikrotik
list="Allow"
#Where to download source file
downfile="./allow_list.txt"
#File with cleaned & formatted ip addresses
infile="./allow_list_formatted.txt"
#Where to put rsc script
outfile="./allow_list_mikrotik.rsc"
#wget $url -O $downfile --no-check-certificate
#This will extract all IPs from file (ie works with .csv russian blocklist)
#sed -n 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/\nip&\n/gp' $downfile | grep ip | sed 's/ip//'| sort | uniq >> $infile
#grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' $downfile | sort | uniq >> $infile
while read line; do
echo $line | sed -e 's|^[^/]*//||' -e 's|/.*$||' >> $infile
done < $downfile

#We need to drop all IPs in address list because mikrotik does not check for duplicates (and they may be removed from file)
echo "#" >> $outfile
echo "#" >> $outfile
echo "#" >> $outfile

echo /ip firewall address-list remove [find list=$list] >> $outfile
#Build rsc file...
for line in $(cat $infile)
do
echo /ip firewall address-list add address="$line" list="$list" >> $outfile
done
#rm $downfile $infile
