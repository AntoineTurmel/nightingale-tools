#!/bin/bash

#l10n script folder
l10n_folder='/home/serveur/dev/nightingale-tools/l10n'

# Go the directory
cd $l10n_folder

# Pull every locales from Adofex (without en-US)
tx pull -a -f

if [ $? -eq 0 ]
then

# The langpack version matching Nightingale version
ver_langpack="1.12.2a"

# Minimum version
ver_min="1.12.0"

# Maximal version
ver_max="1.13.0"

# Mozilla Firefox version strings
moz_version="3.6.28"

# URL where langpacks are uploaded
langpacks_url="http://locales.getnightingale.com/langpacks/"

wd=`pwd`

cd locales

rm langpack-*

# We make langpack for shipped locales
for lang_code in $(cat $wd/shipped-locales)
do
  echo $lang_code
  lang_name=`cat $wd/languages.json | jq '.["'$lang_code'"].English' -r`
  cd $lang_code
  cd songbird
  zip -r -9 songbird.jar *
  mv songbird.jar ..
  cd ..
  rm -rf songbird

  # Getting the langpack from Mozilla
  wget_output=$(wget -q "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$moz_version/linux-i686/xpi/$lang_code.xpi")

  # If there is no mozilla string available the chrome.manifest is only two lines
  if [ $? -ne 0 ]; then
    echo "No Mozilla strings";
    
    # Writing the chrome.manifest file
    echo '# Nightingale strings:
locale songbird '$lang_code' jar:songbird.jar!/' > chrome.manifest

  else
    # iCook better, get a new Jobs!
    if [ "$lang_code" == "ja" ]; then
      wget -q "http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$moz_version/mac/xpi/ja-JP-mac.xpi"
      unzip -o ja.xpi
      unzip -o ja-JP-mac.xpi
      rm ja.xpi
      rm ja-JP-mac.xpi

      echo '# Nightingale strings:
locale  songbird  ja  jar:songbird.jar!/
# platform: linux
locale mozapps ja jar:chrome/ja.jar!/locale/ja/mozapps/ os!=WINNT os!=Darwin
locale pipnss ja jar:chrome/ja.jar!/locale/ja/pipnss/ os!=WINNT os!=Darwin
locale browser ja jar:chrome/ja.jar!/locale/browser/ os!=WINNT os!=Darwin
locale necko ja jar:chrome/ja.jar!/locale/ja/necko/ os!=WINNT os!=Darwin
locale reporter ja jar:chrome/ja.jar!/locale/ja/reporter/ os!=WINNT os!=Darwin
locale browser-region ja jar:chrome/ja.jar!/locale/browser-region/ os!=WINNT os!=Darwin
locale places ja jar:chrome/ja.jar!/locale/ja/places/ os!=WINNT os!=Darwin
locale cookie ja jar:chrome/ja.jar!/locale/ja/cookie/ os!=WINNT os!=Darwin
locale global-region ja jar:chrome/ja.jar!/locale/ja/global-region/ os!=WINNT os!=Darwin
locale pippki ja jar:chrome/ja.jar!/locale/ja/pippki/ os!=WINNT os!=Darwin
locale passwordmgr ja jar:chrome/ja.jar!/locale/ja/passwordmgr/ os!=WINNT os!=Darwin
locale alerts ja jar:chrome/ja.jar!/locale/ja/alerts/ os!=WINNT os!=Darwin
locale global-platform ja jar:chrome/ja.jar!/locale/ja/global-platform/ os!=WINNT os!=Darwin
locale autoconfig ja jar:chrome/ja.jar!/locale/ja/autoconfig/ os!=WINNT os!=Darwin
locale global ja jar:chrome/ja.jar!/locale/ja/global/ os!=WINNT os!=Darwin
# platform: win32
locale mozapps ja jar:chrome/ja.jar!/locale/ja/mozapps/ os=WINNT
locale pipnss ja jar:chrome/ja.jar!/locale/ja/pipnss/ os=WINNT
locale browser ja jar:chrome/ja.jar!/locale/browser/ os=WINNT
locale necko ja jar:chrome/ja.jar!/locale/ja/necko/ os=WINNT
locale reporter ja jar:chrome/ja.jar!/locale/ja/reporter/ os=WINNT
locale browser-region ja jar:chrome/ja.jar!/locale/browser-region/ os=WINNT
locale places ja jar:chrome/ja.jar!/locale/ja/places/ os=WINNT
locale cookie ja jar:chrome/ja.jar!/locale/ja/cookie/ os=WINNT
locale global-region ja jar:chrome/ja.jar!/locale/ja/global-region/ os=WINNT
locale pippki ja jar:chrome/ja.jar!/locale/ja/pippki/ os=WINNT
locale passwordmgr ja jar:chrome/ja.jar!/locale/ja/passwordmgr/ os=WINNT
locale alerts ja jar:chrome/ja.jar!/locale/ja/alerts/ os=WINNT
locale global-platform ja jar:chrome/ja.jar!/locale/ja/global-platform/ os=WINNT
locale autoconfig ja jar:chrome/ja.jar!/locale/ja/autoconfig/ os=WINNT
locale global ja jar:chrome/ja.jar!/locale/ja/global/ os=WINNT
# platform: osx
locale autoconfig ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/autoconfig/ os=Darwin
locale global-region ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/global-region/ os=Darwin
locale mozapps ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/mozapps/ os=Darwin
locale cookie ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/cookie/ os=Darwin
locale pippki ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/pippki/ os=Darwin
locale reporter ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/reporter/ os=Darwin
locale places ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/places/ os=Darwin
locale global-platform ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/global-platform/ os=Darwin
locale alerts ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/alerts/ os=Darwin
locale browser ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/browser/ os=Darwin
locale necko ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/necko/ os=Darwin
locale pipnss ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/pipnss/ os=Darwin
locale browser-region ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/browser-region/ os=Darwin
locale global ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/global/ os=Darwin
locale passwordmgr ja-JP-mac jar:chrome/ja-JP-mac.jar!/locale/ja-JP-mac/passwordmgr/ os=Darwin' > chrome.manifest
    else
      unzip -o $lang_code.xpi
      rm $lang_code.xpi

      # Writing the chrome.manifest file
      echo '# Nightingale strings:
locale songbird '$lang_code' jar:songbird.jar!/
# Mozilla strings:
locale browser-region '$lang_code' jar:chrome/'$lang_code'.jar!/locale/browser-region/
locale pipnss '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/pipnss/
locale cookie '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/cookie/
locale reporter '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/reporter/
locale necko '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/necko/
locale global '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/global/
locale mozapps '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/mozapps/
locale browser '$lang_code' jar:chrome/'$lang_code'.jar!/locale/browser/
locale global-platform '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/global-platform/
locale pippki '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/pippki/
locale passwordmgr '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/passwordmgr/
locale places '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/places/
locale global-region '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/global-region/
locale alerts '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/alerts/
locale autoconfig '$lang_code' jar:chrome/'$lang_code'.jar!/locale/'$lang_code'/autoconfig/ ' > chrome.manifest 
    fi
  fi

  # Writing the install.rdf file
  echo '<?xml version="1.0"?>
<RDF xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:em="http://www.mozilla.org/2004/em-rdf#">
<Description about="urn:mozilla:install-manifest"
em:id="langpack-'$lang_code'@getnightingale.com"
em:name="'$lang_name' ('$lang_code') Language Pack"
em:version="'$ver_langpack'"
em:type="8"
em:creator="Nightingale and Songbird Translators">
 
<!-- Nightingale -->
<em:targetApplication>
<Description>
<em:id>nightingale@getnightingale.com</em:id>
<em:minVersion>'$ver_min'</em:minVersion>
<em:maxVersion>'$ver_max'</em:maxVersion>
</Description>
</em:targetApplication>
 
</Description>
</RDF>' > install.rdf

  zip -r -9 langpack-$lang_code-$ver_langpack.xpi *
  mv langpack-$lang_code-$ver_langpack.xpi ..
  cd ..

done

# Writing the locales.xml file
echo '<?xml version="1.0" encoding="UTF-8"?>' > locales.xml
echo '<SongbirdInstallBundle version="2">' >> locales.xml

for lang_code in $(cat $wd/shipped-locales)
do
  echo $lang_code
  lang_name_native=`cat $wd/languages.json | jq '.["'$lang_code'"].Native' -r`

  echo '  <XPI name="'$lang_name_native'" id="langpack-'$lang_code'@getnightingale.com" languageTag="'$lang_code'" url="http://locales.getnightingale.com/langpacks/'$ver_langpack'/langpack-'$lang_code'-'$ver_langpack'.xpi"/>' >> locales.xml

done

echo '</SongbirdInstallBundle>' >> locales.xml

if [ "$1" = "-u" ]; then
  mkdir $ver_langpack
  mv locales.xml $ver_langpack
  mv langpack* $ver_langpack
  rsync -e ssh $ver_langpack ngaleoss@getnightingale.com://home//ngaleoss//locales.getnightingale.com//langpacks -r --progress
  rm -rf $ver_langpack
  cd ..
  rm -rf locales
else
  echo "Manual upload required"
fi

else
    echo "tx failed"
fi
