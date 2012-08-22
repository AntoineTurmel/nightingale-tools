nightingale-tools
=================

This repo is a set of tools for Nightingale.

buildbot: It's a bash script to compile Nightingale and upload nightlies if there are changes on a branch of the repo.
You have to configure it by editing config.sh

Be sure to install expect if you want to use stored password for sftp/rsync

It's available on Debian/Ubuntu :
```shell
sudo apt-get install expect
```

On Windows : http://www.cis.usouthal.edu/share/fcw23/lynn/program/expect-5.21r1b1-setup.exe

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

