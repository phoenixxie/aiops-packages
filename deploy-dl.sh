#!/bin/bash

set -e

ROOTDIR=$(pwd)

source $ROOTDIR/list.sh

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
    echo "Failed to download $file"
    exit 1
  fi
}

check_file $debootstrap_url $debootstrap_file $debootstrap_sha256
check_file $packages_url $packages_file $packages_sha256
check_file $debs_url $debs_file $debs_sha256
check_file $pip_url $pip_file $pip_sha256
