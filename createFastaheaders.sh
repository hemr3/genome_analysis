for file in *.fa
do
  awk -v species="species1" -v individual="individual1" -v allele="${file%-*}" '/^>/ {gsub(/^>/,">" $2 "|" species "|" individual "|" allele); printf "%s\n",$0;next} {print}' $file > ${file%.fa}.new.fa
  mv ${file%.fa}.new.fa $file
done
