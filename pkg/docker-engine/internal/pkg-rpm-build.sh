#!/usr/bin/env bash

# Copyright 2022 Docker Packaging authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

: "${DOCKER_ENGINE_VERSION=}"

: "${PKG_NAME=}"
: "${PKG_RELEASE=}"
: "${PKG_DISTRO=}"
: "${PKG_SUITE=}"
: "${PKG_PACKAGER=}"
: "${PKG_VENDOR=}"

: "${PKG_RPM_RELEASE=}"

: "${SOURCE_DATE_EPOCH=}"
: "${SRCDIR=/work/src}"
: "${OUTDIR=/out}"

set -e

if [ -z "$PKG_RELEASE" ]; then
  echo >&2 "error: PKG_RELEASE is required"
  exit 1
fi
if [ -z "$OUTDIR" ]; then
  echo >&2 "error: OUTDIR is required"
  exit 1
fi

mkdir -p "$OUTDIR"

if ! command -v xx-info &> /dev/null; then
  echo >&2 "error: xx cross compilation helper is required"
  exit 1
fi

# TODO: add support for cross comp
if xx-info is-cross; then
  echo >&2 "warning: cross compilation with $(xx-info arch) not supported"
  exit 0
fi

if [ -d "${SRCDIR}" ]; then
  commit="$(git --git-dir ${SRCDIR}/.git rev-parse HEAD)"
fi

set -x

tilde='~'
rpmVersion="${DOCKER_ENGINE_VERSION#v}"
rpmVersion="${rpmVersion//-/$tilde}"
rpmDefine=(
  --define "_version ${rpmVersion}"
  --define "_origversion ${DOCKER_ENGINE_VERSION#v}"
  --define "_release $PKG_RPM_RELEASE"
  --define "_commit $commit"
)

pkgoutput="${OUTDIR}/${PKG_DISTRO}/${PKG_SUITE}/$(xx-info arch)"
if [ -n "$(xx-info variant)" ]; then
  pkgoutput="${pkgoutput}/$(xx-info variant)"
fi

case "$PKG_RELEASE" in
  centos8|centos9|oraclelinux*)
    rpmDefine+=(--define "_without_btrfs 1")
    export DOCKER_BUILDTAGS="exclude_graphdriver_btrfs $DOCKER_BUILDTAGS"
    ;;
esac

rpmbuild $PKG_RPM_BUILDFLAGS "${rpmDefine[@]}" /root/rpmbuild/SPECS/*.spec
mkdir -p "${pkgoutput}"
cp ./RPMS/*/*.* "${pkgoutput}"/
if [ "$(ls -A ./SRPMS)" ]; then
  cp ./SRPMS/* "${pkgoutput}"/
fi