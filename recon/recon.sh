#!/bin/bash
read -p "Enter your target domain: " target
echo -e "Running subfinder against the target domain - $target \n"
subfinder -silent -d $target -o "$target-subfinder.txt" > /dev/null
sub_count=$(wc -l < "$target-subfinder.txt") 
echo "Enumerated $sub_count domains for $target"

echo -e "Running permutations to the subdomains... \n"

curl -s https://gist.githubusercontent.com/six2dez/ffc2b14d283e8f8eff6ac83e20a3c4b4/raw?ref=rashahacks.com -o $perm.txt > /dev/null
#curl -s https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt -o $resolver_list.txt > /dev/null

altdns -i $target-subfinder.txt -o $target-altdns.txt -w $perm.txt
echo -e "permutation done ✓ \n\n Resolving live hosts... \n"

curl -s https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt -o $resolver_list.txt > /dev/null
massdns -r $resolver_list.txt -o S -t A $target-altdns.txt > dns-resolved.txt

sed 's/A.*//' dns-resolved.txt | sed 's/CN.*//' | sed 's/\..$//' > final.txt

echo "You are all done ✓"
