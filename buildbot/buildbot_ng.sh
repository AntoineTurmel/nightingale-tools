#!/bin/bash
source config.sh
# Check the architecture platform (eg. i686)
arch=`uname -m`
ngalebuild=`date +%Y-%m-%d-%H-%M-%S`
daybefore=`date +%Y-%m-%d --date '1 days ago'`
# Going to the repo folder
cd "${repo}"
# Checkout the right branch
git checkout ${branch}
# Fetch changes from GitHub
git fetch origin
# Merge
ngalechange=`git merge origin/${branch}`

# If there are new changes or using -f parameter,
# let's build !
if [ "$ngalechange" != 'Already up-to-date.' ] || [ "$1" = "-f" ]
 then

make -f nightingale.mk clobber

./build.sh > buildlog
ngalebuildstatus=`cat buildlog | tail --lines=1`

# If ngale was successfully builded, package it
if [ "$ngalebuildstatus" = 'Build finished!' ]
 then

mv compiled/dist compiled/Nightingale
cd compiled
git log --after={${daybefore}} > changes.txt
#Tar then bz2
tar cvf nightingale-${version}_${osname}-${arch}.tar Nightingale
bzip2 nightingale-${version}_${osname}-${arch}.tar
#Making a md5 sum
md5sum nightingale-${version}_${osname}-${arch}.tar.bz2 > nightingale-${version}_${osname}-${arch}.tar.bz2.md5
#Creating a folder and moving the file to be reachable
mkdir $compiled/$ngalebuild
mkdir $compiled/$ngalebuild/addons
mv nightingale-${version}_${osname}-${arch}.tar.bz2* $compiled/$ngalebuild
mv changes.txt $compiled/$ngalebuild
mv xpi-stage/7digital/*.xpi $compiled/$ngalebuild/addons
mv xpi-stage/albumartlastfm/*.xpi $compiled/$ngalebuild/addons
mv xpi-stage/audioscrobbler/*.xpi $compiled/$ngalebuild/addons
mv xpi-stage/concerts/*.xpi $compiled/$ngalebuild/addons
mv xpi-stage/mashTape/*.xpi $compiled/$ngalebuild/addons
mv xpi-stage/shoutcast-radio/*.xpi $compiled/$ngalebuild/addons

#Uploading on sourceforge.net
${rsync} -e ssh $compiled/$ngalebuild ${sfnet}@frs.sourceforge.net:/home/pfs/project/ngale/1.11-Nightlies/GNU-${osname}/${arch} -r --progress

 else
echo "Build fail, see buildlog for more info"
fi

 else
echo "Nothing to do, bye !"
fi
