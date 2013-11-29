nightingale-tools
=================

This repo is a set of tools for Nightingale.

## buildbot
It's a bash script to compile Nightingale and upload nightlies if there are changes on a branch of the repo.
You have to configure it by editing config.sh

rsync is used to upload files on sourceforge.net, so first be sure to generate keys, and upload your public key on your sf.net account:
https://sourceforge.net/apps/trac/sourceforge/wiki/SSH%20keys

(Be sure to avoid passphrase if you want the script to run automatically)

**How to:**

```bash
cp config-sample.sh config.sh #copy the sample to the config file
nano config.sh #edit config file using your favorite text editor
chmod +x buildbot_ng.sh #to make the script executable
./buildbot_ng.sh #to launch the build process
./buildbot_ng.sh -f #to force build even if there are no changes in the branch
```
You can put an entry in cron (/etc/crontab) to build it everyday:

```cron
# m h dom mon dow user     command
  0 0   *   *   * youruser /home/youruser/./buildbot_ng.sh
```

**Linux/Mac users:**

Be sure to have rsync and git installed

**Windows users:**

* You should [retrieve a copy of rsync](https://www.itefix.no/i2/sites/default/files/cwRsync_4.0.5_Installer.zip) then copy rsync.exe, ssh.exe and other .dll in your mozilla-build\msys\bin folder.
* You should [install Git](http://git-scm.com/)


## l10n

  * **produce-langpack.sh** is a bash script to produce langpacks xpi files for Nightingale based on strings from [Adofex](http://beta.babelzilla.org/projects/p/Nightingale/) and Mozilla strings it also generates a locales.xml file

Be sure to install [tx](http://blog.babelzilla.org/2012/11/09/beta-babelzilla-live/) and [jq](http://stedolan.github.io/jq/download/) before.

The following scripts were developped to fetch Songbird langpacks, they are not working anymore since Songbird servers are down :

  * **fetch.sh** is a bash script to fetch/download latest Songbird langpacks and extract them in separated locale folders.

Be sure to install xsltproc and unzip before (available on Debian/Ubuntu):
```bash
sudo apt-get install xsltproc unzip
```

  * **repack.sh** is quite the same script but it repack langpacks to be compatible with Nightingale.
  * **fetch-missing.sh** is a bash script to download Songbird langpacks which are not shipped by default (less than 50% strings translated)


## TODO
Look at [issues](https://github.com/GeekShadow/nightingale-tools/issues?state=open) on GitHub.

