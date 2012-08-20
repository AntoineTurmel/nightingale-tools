#!/bin/bash
# Check the architecture platform (eg. i686)
arch=`uname -m`
# The branch to build
branch='nightingale-1.11'
# Version of Nightingale
version='1.11.1'
ngalebuild=`date +%Y-%m-%d-%H-%M-%S`
daybefore=`date +%Y-%m-%d --date '1 days ago'`
# Sourceforge.net username
sfnet='geekshadow'
# rsync binary (rsyncp allow password to be store
# insted of using public/private keys)
rsync='/home/serveur/./rsyncp'

# Going to the repo folder
cd ~/dev/nightingale-hacking
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
tar cvf nightingale-${version}_linux-${arch}.tar Nightingale
bzip2 nightingale-${version}_linux-${arch}.tar
#Making a md5 sum
md5sum nightingale-${version}_linux-${arch}.tar.bz2 > nightingale-${version}_linux-${arch}.tar.bz2.md5
#Creating a folder and moving the file to be reachable
mkdir /var/www/ngale/$ngalebuild
mkdir /var/www/ngale/$ngalebuild/addons
mv nightingale-${version}_linux-${arch}.tar.bz2* /var/www/ngale/$ngalebuild
mv changes.txt /var/www/ngale/$ngalebuild
mv xpi-stage/7digital/*.xpi /var/www/ngale/$ngalebuild/addons
mv xpi-stage/albumartlastfm/*.xpi /var/www/ngale/$ngalebuild/addons
mv xpi-stage/audioscrobbler/*.xpi /var/www/ngale/$ngalebuild/addons
mv xpi-stage/concerts/*.xpi /var/www/ngale/$ngalebuild/addons
mv xpi-stage/mashTape/*.xpi /var/www/ngale/$ngalebuild/addons
mv xpi-stage/shoutcast-radio/*.xpi /var/www/ngale/$ngalebuild/addons

#Uploading on sourceforge.net
${rsync} -e ssh /var/www/ngale/$ngalebuild ${sfnet}@frs.sourceforge.net:/home/pfs/project/ngale/1.11-Nightlies/GNU-Linux/${arch} -r --progress

 else
echo "Build fail, see buildlog for more info"
fi

 else
echo "Nothing to do, bye !"
fi

