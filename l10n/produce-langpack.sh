#!/bin/bash

# Pull every locales from Adofex (without en-US)
tx pull -a -f

# The langpack version matching Nightingale version
ver_langpack="1.12.1"

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
