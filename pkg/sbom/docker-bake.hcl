// Copyright 2022 Docker Packaging authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# Sets the sbom repo. Will be used to clone the repo at
# SBOM_REF ref to include the README.md and LICENSE for the
# static packages and also create version string.
variable "SBOM_REPO" {
  default = "https://github.com/docker/sbom-cli-plugin.git"
}

# Sets the sbom ref.
variable "SBOM_REF" {
  default = "v0.6.1"
}

# Sets Go image, version and variant to use for building
variable "GO_IMAGE" {
  default = "golang"
}
variable "GO_VERSION" {
  default = "1.18.5"
}
variable "GO_IMAGE_VARIANT" {
  default = "bullseye"
}

# Sets the pkg name.
variable "PKG_NAME" {
  default = "docker-sbom-plugin"
}

# Sets the list of package types to build: apk, deb, rpm or static
variable "PKG_TYPE" {
  default = "static"
}

# Sets release flavor. See packages.hcl and packages.mk for more details.
variable "PKG_RELEASE" {
  default = "static"
}
target "_pkg-static" {
  args = {
    PKG_RELEASE = ""
    PKG_TYPE = "static"
  }
}

# Sets the vendor/maintainer name (only for linux packages)
variable "PKG_VENDOR" {
  default = "Docker"
}

# Sets the name of the company that produced the package (only for linux packages)
variable "PKG_PACKAGER" {
  default = "Docker <support@docker.com>"
}

# deb specific, see vars.mk for more details
variable "PKG_DEB_BUILDFLAGS" {
  default = "-b -uc"
}
variable "PKG_DEB_REVISION" {
  default = "0"
}
variable "PKG_DEB_EPOCH" {
  default = "5"
}

# rpm specific, see vars.mk for more details
variable "PKG_RPM_BUILDFLAGS" {
  default = "-bb"
}
variable "PKG_RPM_RELEASE" {
  default = ""
}

# Defines the output folder
variable "DESTDIR" {
  default = ""
}
function "bindir" {
  params = [defaultdir]
  result = DESTDIR != "" ? DESTDIR : "./bin/${defaultdir}"
}

# Defines if we just want to build for the local platform
variable "LOCAL_PLATFORM" {
  default = ""
}

# Defines reference for registry cache exporter
variable "BUILD_CACHE_REGISTRY_SLUG" {
  default = "dockereng/packaging-cache"
}
variable "BUILD_CACHE_REGISTRY_PUSH" {
  default = ""
}

group "default" {
  targets = ["pkg"]
}

target "_common" {
  inherits = ["_pkg-${PKG_RELEASE}"]
  args = {
    BUILDKIT_MULTI_PLATFORM = 1
    SBOM_REPO = SBOM_REPO
    SBOM_REF = SBOM_REF
    GO_IMAGE = GO_IMAGE
    GO_VERSION = GO_VERSION
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT
    PKG_NAME = PKG_NAME
    PKG_VENDOR = PKG_VENDOR
    PKG_PACKAGER = PKG_PACKAGER
    PKG_DEB_BUILDFLAGS = PKG_DEB_BUILDFLAGS
    PKG_DEB_REVISION = PKG_DEB_REVISION
    PKG_DEB_EPOCH = PKG_DEB_EPOCH
    PKG_RPM_BUILDFLAGS = PKG_RPM_BUILDFLAGS
    PKG_RPM_RELEASE = PKG_RPM_RELEASE
  }
  platforms = [
    # BAKE_LOCAL_PLATFORM is a built-in var returning the current platform's
    # default platform specification: https://docs.docker.com/build/customize/bake/file-definition/#built-in-variables
    LOCAL_PLATFORM != "" ? BAKE_LOCAL_PLATFORM : ""
  ]
  cache-from = [
    BUILD_CACHE_REGISTRY_SLUG != "" ? "type=registry,ref=${BUILD_CACHE_REGISTRY_SLUG}:sbom-${PKG_TYPE}-${PKG_RELEASE}" : "",
  ]
  cache-to = [
    BUILD_CACHE_REGISTRY_SLUG != "" && BUILD_CACHE_REGISTRY_PUSH != "" ? "type=registry,ref=${BUILD_CACHE_REGISTRY_SLUG}:sbom-${PKG_TYPE}-${PKG_RELEASE},mode=max" : "",
  ]
}

# $ PKG_RELEASE=debian11 docker buildx bake pkg
# $ docker buildx bake --set *.platform=linux/amd64 --set *.output=./bin pkg
target "pkg" {
  inherits = ["_common"]
  target = "pkg"
  output = [bindir(PKG_RELEASE)]
  contexts = {
    common-scripts = "../../common/scripts"
  }
}

# Special target: https://github.com/docker/metadata-action#bake-definition
target "meta-helper" {
  tags = ["dockereng/packaging:sbom-local"]
}

# Create release image by using ./bin folder as named context. Make sure all
# pkg targets are called before releasing
target "release" {
  inherits = ["meta-helper"]
  dockerfile = "../../common/release.Dockerfile"
  target = "release"
  # same as PKG_PLATFORMS in Makefile
  platforms = [
    "darwin/amd64",
    "darwin/arm64",
    "linux/amd64",
    "linux/arm64",
    "windows/amd64",
    "windows/arm64"
  ]
  contexts = {
    bin-folder = "./bin"
  }
}

# Verify packages
target "verify" {
  inherits = ["_pkg-${PKG_RELEASE}"]
  dockerfile = "verify.Dockerfile"
  output = ["type=cacheonly"]
  contexts = {
    bin-folder = "./bin"
  }
}

# Output metadata
target "metadata" {
  inherits = ["_pkg-${PKG_RELEASE}"]
  args = {
    SBOM_REPO = SBOM_REPO
    SBOM_REF = SBOM_REF
  }
  target = "metadata"
  output = ["./bin"]
  contexts = {
    common-scripts = "../../common/scripts"
  }
}