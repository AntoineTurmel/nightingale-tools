#!/bin/bash

set -e

# Include the config file
source config.sh
export PATH=$PATH

# Check the OS
case $OSTYPE in
	linux*)   osname='linux' ;;
	msys*)    osname='windows' ;;
	darwin*)  osname='macosx' ;;
	solaris*) osname='solaris' ;;
	bsd*)     osname='bsd' ;;
	*)        osname='unknown' ;;
esac

if [ "$osname" == "macosx" ]; then
	arch="i686"
else
	# Check the architecture platform (eg. i686)
	arch=`uname -m`
fi

# Today date
ngalebuild=`date "+%Y-%m-%d"`

# One day before to get git changes
if [ "$osname" == "macosx" ]; then
	daybefore=`date -v -1d "+%Y-%m-%d"`
else
	daybefore=`date "+%Y-%m-%d" --date '1 days ago'`
fi

# Going to the repo folder
cd "${repo}"

# Clean up
git reset --hard

# Checkout the right branch
git checkout ${branch}

# Fetch changes from GitHub
git fetch origin
# Merge

ngalechange=`git merge origin/${branch}`

# If there are new changes or using -f parameter,
# let's build !
if [ "$ngalechange" != 'Already up-to-date.' ] || [ "$1" = "-f" ]; then
	# Get the buildnumber
	buildnumber=`cat build/sbBuildInfo.mk.in | grep BuildNumber= | sed -e 's/BuildNumber=//g'`
	# Get the version
	version=`cat build/sbBuildInfo.mk.in | grep SB_MILESTONE= | sed 's/SB_MILESTONE=//g'`
	# Get the branchname
	branchname=`cat build/sbBuildInfo.mk.in | grep SB_BRANCHNAME= | sed 's/SB_BRANCHNAME=//g'`

	# Check if we are on trunk
	if [ "$branchname" != 'sb-trunk-oldxul' ]; then
		branchname=`echo $branchname | sed 's/Songbird//g'`
	fi

	# remove old build
	make -f nightingale.mk clobber

	cd ${repo}
	bash ./build.sh |tee "${repo}/buildlog"

	if [ "`cat buildlog|grep 'Succeeded'`" ]; then
		mv compiled/dist compiled/Nightingale
		cd compiled
		changes=`git log --after={${daybefore}}`
		echo "Nightingale "$version" - branch "$branchname" - build "$buildnumber > README.md
		echo "" >> README.md
		echo "Git source: <https://github.com/nightingale-media-player/nightingale-hacking/tree/"$branch">" >> README.md
		echo "" >> README.md
		echo "Changes:" >> README.md
		echo "" >> README.md

		if [ "$changes" = "" ]; then
			echo "none" >> README.md
			cat /dev/null > changes.txt
		else
			echo "$changes" >> README.md
			echo "$changes" > changes.txt
		fi

		if [ "$osname" == "windows" ]; then
			#Zip
			zip -r -9 nightingale-${version}-${buildnumber}_${osname}-${arch}.zip Nightingale
			#Making a md5sum
			md5sum nightingale-${version}-${buildnumber}_${osname}-${arch}.zip > nightingale-${version}-${buildnumber}_${osname}-${arch}.zip.md5
		else
			#Tar then bz2
			tar cvf nightingale-${version}-${buildnumber}_${osname}-${arch}.tar Nightingale
			bzip2 nightingale-${version}-${buildnumber}_${osname}-${arch}.tar

			if [ "$osname" == "macosx" ]; then
				md5 nightingale-${version}-${buildnumber}_${osname}-${arch}.tar.bz2 > nightingale-${version}-${buildnumber}_${osname}-${arch}.tar.bz2.md5
			else
				#Making a md5 sum
				md5sum nightingale-${version}-${buildnumber}_${osname}-${arch}.tar.bz2 > nightingale-${version}-${buildnumber}_${osname}-${arch}.tar.bz2.md5
			fi
		fi

		#Creating a folder and moving the file to be reachable
		mkdir $compiled/$ngalebuild
		mkdir $compiled/$ngalebuild/addons
		mv nightingale-${version}-${buildnumber}_${osname}-${arch}.* $compiled/$ngalebuild
		mv changes.txt $compiled/$ngalebuild
		mv README.md $compiled/$ngalebuild
		mv xpi-stage/7digital/*.xpi $compiled/$ngalebuild/addons
		mv xpi-stage/albumartlastfm/*.xpi $compiled/$ngalebuild/addons
		mv xpi-stage/audioscrobbler/*.xpi $compiled/$ngalebuild/addons
		mv xpi-stage/concerts/*.xpi $compiled/$ngalebuild/addons
		mv xpi-stage/mashTape/*.xpi $compiled/$ngalebuild/addons
		mv xpi-stage/shoutcast-radio/*.xpi $compiled/$ngalebuild/addons

		if [ "$osname" == "windows" ] || [ "$osname" = "macosx" ]; then
			mv _built_installer/* $compiled/$ngalebuild
		fi

		#Uploading on sourceforge.net
		cd "${compiled}"
		rsync -e ssh $ngalebuild ${sfnetuser}@frs.sourceforge.net://home//pfs//project//ngale//${branchname}-Nightlies -r --progress
	else
		echo "Build failed! See buildlog for details"
	fi
else
	echo "Nothing to do, bye !"
fi
