#!/bin/bash

# Songbird/Nightingale version
version='2.2.0'

# Make a folder for locales
mkdir locales
# Remove locales.xml first
rm locales.xml
# Download locales.xml
wget https://locales.songbirdnest.com/bundles/3/Songbird/${version}/timestamp/osarch/en-US/release/os/default/default/locales.xml
# Generate a list of downloadable files with wget
xsltproc locales.xsl locales.xml > locales/getlangpacks.sh
cd locales
# Make the script executable
chmod +x getlangpacks.sh
# Launch it to wget all langpacks
./getlangpacks.sh

# Unzip each langpack to have files
for file in *; do
   if [ -d $file ]; then
      #mkdir $file/test;
      unzip $file/langpack-* -d $file
      rm $file/langpack-*
      unzip $file/songbird.jar -d $file/songbird
      rm $file/songbird.jar
      rm $file/install.rdf
      rm $file/chrome.manifest
      rm -Rf $file/chrome
   fi
done
