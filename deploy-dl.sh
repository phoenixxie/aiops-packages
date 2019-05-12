#!/bin/bash

set -e

ROOTDIR=$(pwd)

debootstrap_url=https://github.com/phoenixxie/dl/releases/download/debootstrap/bionic-firststage.tar.xz
debootstrap_file=bionic-firststage.tar.xz
debootstrap_sha256=4d90ff82306a1dc4d39f739e08629995ffed388892f08635f6d7c2d6528b792e

packages_url=https://github.com/phoenixxie/dl/releases/download/deploy-packages/deploy-packages.tar.gz
packages_file=deploy-packages.tar.gz
packages_sha256=5f4dc4ddaf335234cc11731c2b3a6e5affd2e704996a3d4292ec9190bc12c110

debs_url=https://github.com/phoenixxie/dl/releases/download/deploy-debs/deploy-debs.tar.gz
debs_file=deploy-debs.tar.gz
debs_sha256=a1886804deea252ec76b70e2e7b502a75756b3c19dc5d8849f34e69929df84a7

pip_url=https://github.com/phoenixxie/dl/releases/download/deploy-pip/deploy-pip.tar.gz
pip_file=deploy-pip.tar.gz
pip_sha256=f0e99d93bdef444ab0dfb6b0ea6f23863035fededce703eeef1f1c1e1d90fc51

check_sha256()
{
  file=$1
  sha256=$2

  comp=$(sha256sum $file | awk '{ print $1 }')
  if [ "$comp" != "$sha256" ]; then
    return 1
  else
    return 0
  fi
}

check_file()
{
  url=$1
  file=$2
  sha256=$3

  if [ -f $file ]; then
    if check_sha256 $file $sha256; then
      return 0
    else
      rm -f $file
    fi
  fi

  wget "$url" -O $file

  if check_sha256 $file $sha256; then
    return 0
  else
    rm -f $file
    return 1
  fi
}

check_file $debootstrap_url $debootstrap_file $debootstrap_sha256
check_file $packages_url $packages_file $packages_sha256
check_file $debs_url $debs_file $debs_sha256
check_file $pip_url $pip_file $pip_sha256
