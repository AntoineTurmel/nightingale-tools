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

```shell
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

**TODO:**
  * Make the script work on Windows and Mac OS X
  * On Windows we need to provide .zip/.exe (builded with [InnoSetup](http://www.jrsoftware.org/isdl.php))
  * The script should also be able to build public releases

## l10n
It's a bash script to fetch/download latest Songbird langpacks and extract them in separated locale folders.

Be sure to install xsltproc and unzip before (available on Debian/Ubuntu):
```shell
sudo apt-get install xsltproc unzip
```

**How to:**

```shell
chmod +x fetch.sh
./fetch.sh
```

**TODO:**
  * Fetch matching Firefox locales for missing strings in some locales
