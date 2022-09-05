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

set -e

if ! command -v xx-info &> /dev/null; then
  echo >&2 "error: xx cross compilation helper is required"
  exit 1
fi

# TODO: add support for cross comp
if xx-info is-cross; then
  echo >&2 "warning: cross compilation with $(xx-info arch) not supported"
  exit 0
fi

set -x

if command -v yum-builddep &> /dev/null; then
  yum-builddep -y /root/rpmbuild/SPECS/*.spec
elif command -v dnf &> /dev/null; then
  dnf builddep -y /root/rpmbuild/SPECS/*.spec
else
  echo >&2 "unable to detect package manager"
  exit 1
fi
