#!/usr/bin/expect
set timeout -1
eval spawn rsync $argv
expect  "password:" { send "yoursfpassword\n"}
expect "$"
