#!/bin/bash

vs_link_get() {
c="$1";fp="$2";while read i; do d=$(echo $i | grep -E -o '[0-9]+-7' | cut -f1 -d'-'); echo $d; curl -A 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' -L "https://imagebank.sweden.se/search?q=$d" -o "$fp"/link-"$c"-"$d".html; sleep 2; done <<<$(head -n20 "$fp"/filenames.tsv)
}

vs_page_get() {
c="$1";fp="$2";for i in "$fp"/link-*.html; do bn=$(basename $i); echo $bn; d=$(grep -E -z -o '<a href="/[^>]*data-mediaid="' "$i" | cut -f2 -d'"' | head -n1); echo $d; curl -A 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' -L "https://imagebank.sweden.se$d" -o "$fp"/page-"$bn"; sleep 1; done
}

vs_text_get() {
c="$1";fp="$2";for i in "$fp"/page-*.html; do bn=$(basename $i); echo $i; cat "$i" | grep -E -z -o 'detail-info-content.*show-less' | grep -E -a -v '<|>' | tr -s '[:space:]' > "$fp"/text-"$bn"; done
}

vs_ids_get() {
c="$1";fp="$2";for i in "$fp"/text-*.html; do bn=$(basename $i); d=$(echo $i | grep -E -o '[0-9]+'); echo $d; cat <(cat $i) <(echo -e) | sed -E 's/^[[:space:]]//g' | tr '\n' ' ' | sed -E -e "s/^/$d\t/" -e 's/$/\n/' | tr -s '[:space:]' > "$fp"/ids-"$bn"; done
}

vs_imgs_get() {
c="$1";fp="$2";for i in "$fp"/page-*.html; do bn=$(basename $i); d=$(cat "$i" | grep -E -e 'meta property' | grep -E -e 'deployedFiles.*\.jpg' | grep -E -o 'https.*\.jpg'); echo $d; curl -A 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' -L "$d" -o "$fp"/imgs-"$bn".jpg; sleep 2; done
}

# 230531: visit sweden
vs_content_get() {
# image category
c="$1"
if true; then

# get link
#for i in /tmp/gpols/*.jpg; do d=$(echo $i | grep -E -o '[0-9]+-7\.jpg' | cut -f1 -d'-'); echo $d; curl -A 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' -L "https://imagebank.sweden.se/search?q=$d" -o /tmp/gpols/link/"$c"-"$d".html; sleep 2; done
# get link from filename list
while read i; do d=$(echo $i | grep -E -o '[0-9]+-7' | cut -f1 -d'-'); echo $d; curl -A 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' -L "https://imagebank.sweden.se/search?q=$d" -o /tmp/gpols/link/"$c"-"$d".html; sleep 2; done <<<$(head -n2000 tmp/filenames.tsv)

# get html
for i in /tmp/gpols/link/*.html; do bn=$(basename $i); echo $bn; d=$(grep -E -z -o '<a href="/[^>]*data-mediaid="' "$i" | cut -f2 -d'"' | head -n1); echo $d; curl -A 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' -L "https://imagebank.sweden.se$d" -o /tmp/gpols/html/"$bn"; sleep 1; done

# get text
for i in /tmp/gpols/html/*.html; do echo $i; bn=$(basename $i); cat "$i" | grep -E -z -o 'detail-info-content.*show-less' | grep -E -a -v '<|>' | tr -s '[:space:]' > /tmp/gpols/text/"$bn"; done

# get id, text
#for i in /tmp/gpols/text/*.html; do bn=$(basename $i); d=$(echo $i | grep -E -o '[0-9]+'); echo $d; cat $i | sed -E -z "s/^/$d/" > csv/text/"$bn"; done
for i in /tmp/gpols/text/*.html; do bn=$(basename $i); d=$(echo $i | grep -E -o '[0-9]+'); echo $d; cat <(cat $i) <(echo -e) | sed -E 's/^[[:space:]]//g' | tr '\n' ' ' | sed -E -e "s/^/$d\t/" -e 's/$/\n/' | tr -s '[:space:]' > csv/text/"$bn"; done

# get imgs
for i in tmp/html/*.html; do bn=$(basename $i); d=$(cat "$i" | grep -E -e 'meta property' | grep -E -e 'deployedFiles.*\.jpg' | grep -E -o 'https.*\.jpg'); echo $d; curl -A 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' -L "$d" -o tmp/imgs/"$bn".jpg; sleep 2; done
#
fi
#
}














