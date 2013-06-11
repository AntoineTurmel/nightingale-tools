#!/bin/bash

# Songbird/Nightingale version
version='2.2.0'

# Remove locales folder
rm -rf locales
# Remove langpacks folder
rm -rf langpacks
# Make a folder for locales
mkdir locales
# Make a folder for langpacks
mkdir langpacks
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
      unzip $file/langpack-* -d $file
      # Remove the langpack xpi
      rm $file/langpack-*
      wget "http://translate.songbirdnest.com/languages/"${file}"/translators" -O $file/translators.html
      cd $file
      # Adding Nightingale compatibility to the install.rdf
      sed '11a\    <!-- Nightingale -->' install.rdf > fdr.llatsni
      sed '12a\    <em:targetApplication>' fdr.llatsni > install.rdf
      sed '13a\      <Description>' install.rdf > fdr.llatsni
      sed '14a\        <em:id>nightingale@getnightingale.com</em:id>' fdr.llatsni > install.rdf
      sed '15a\        <em:minVersion>1.12.0</em:minVersion>' install.rdf > fdr.llatsni
      sed '16a\        <em:maxVersion>1.12.*</em:maxVersion>' fdr.llatsni > install.rdf
      sed '17a\      </Description>' install.rdf > fdr.llatsni
      sed '18a\    </em:targetApplication>\n' fdr.llatsni > install.rdf
      # Remove the temporary file
      rm fdr.llatsni
      # Prepare the new langpack xpi
      zip -r -9 ../../langpacks/langpack-${file}-1.12.xpi *
      cd ..

   fi
done
