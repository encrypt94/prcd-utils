#!/bin/sh

curl "http://papuasia.org/prcd/prcd_cri.txt" | awk '{
     gsub(/\"/, "\\\"", $0)
     print "\t\""$0"\\n\","
}' > prcd_cri.txt

n_bestemmie=$(cat prcd_cri.txt | wc -l)

echo "#define N_BESTEMMIE $n_bestemmie" > bestemmie.h
echo "const char *bestemmie[] = {" >> bestemmie.h
cat prcd_cri.txt >> bestemmie.h
echo "};" >> bestemmie.h
rm prcd_cri.txt
