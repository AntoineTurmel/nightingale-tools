#!/bin/bash
sb_version="2.1.0" #latest on fly compiled langpack
sb_user_agent='Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.3) Gecko/20101201 Songbird/'$sb_version

# Path of songbird-l10n
l10n_path='/home/antoine/Dev/songbird-l10n'

cd $l10n_path

# Makes the list of missing locales
diff all-locales shipped-locales | grep "<" | cut -d' ' -f2 > missing-locales

cd locales

for lang_code in $(cat $l10n_path/missing-locales)
do

wget -O "langpack-"$lang_code"-"$sb_version".xpi" http://translate.songbirdnest.com/languages/$lang_code/langpack --user-agent="$sb_user_agent"
sleep 60

done

cd ..
rm missing-locales
