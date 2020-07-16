#!/bin/zsh
# Address parameter for the version 63.1
param_631[0]="0x4a2a50"
param_631[1]="0x4a1724"
param_631[2]="0x4a1738"
param_631[3]="0x4a173e"
param_631[4]="0x4a1879"
param_631[5]="0x4a1896"
# Address parameter for the version 64
param_640[0]="0x4cde70"
param_640[1]="0x4ccb44"
param_640[2]="0x4ccb58"
param_640[3]="0x4ccb5e"
param_640[4]="0x4ccc99"
param_640[5]="0x4cccb6"
# Address parameter for the version 65.1
param_651[0]="0x4db500"
param_651[1]="0x4da1d4"
param_651[2]="0x4da1e8"
param_651[3]="0x4da1ee"
param_651[4]="0x4da329"
param_651[5]="0x4da346"
# Address parameter for the version 66.1
param_661[0]="0x4f3750"
param_661[1]="0x4f2424"
param_661[2]="0x4f2438"
param_661[3]="0x4f243e"
param_661[4]="0x4f2579"
param_661[5]="0x4f2596"
# Address parameter for the version 67.1
param_671[0]="0x50a6d0"
param_671[1]="0x509394"
param_671[2]="0x5093a8"
param_671[3]="0x5093ae"
param_671[4]="0x5094e9"
param_671[5]="0x509506"
#Version Selector
case "$version" in
  "63.1")
    echo "select 63.1"
    ;;
  "64")
    echo "select 64"
    ;;
  "65.1")
    echo "select 65.1"
    ;;
  "66.1")
    echo "select 66.1"
    ;;
  "67.1")
    echo "select 67.1"
    ;;
  *)
    echo "not supported."
esac