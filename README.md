# Docker Packaging

## About

This repository creates packages (apk, deb, rpm, static) for various projects
and are published as a Docker image on Docker Hub.

## Usage

`vars.mk` contains variables that will be used by the main `Makefile` and
also across projects in [pkg](pkg) folder. It contains the list of apk,
deb and rpm releases to produce and repos with current versions of projects.

`Makefile` contains targets to build specific or all packages and will output
to `./bin` folder:

```shell
# build debian packages for buildx project
$ make deb-buildx
# build deb and rpm packages for all projects
$ make deb rpm
```

Each [project](pkg) has also its own `Makefile`, `Dockerfile` and bake
definition to build and push packages in two steps:

```shell
# build all packages for buildx v0.9.1 and output to ./bin folder
$ cd pkg/buildx/ 
$ BUILDX_VERSION=v0.9.1 make pkg
# build and push image to dockereng/packaging:buildx-v0.9.1 using bake.
# "release" target will use the "bin" folder as named context to create the
# image with artifacts previously built with make.
$ docker buildx bake --push --set *.tags=dockereng/packaging:buildx-v0.9.1 release
```

Packages are published to Docker Hub as a Docker image. You can use a tool like [Undock](https://github.com/crazy-max/undock)
to extract packages:

```shell
# extract packages for all platforms and output to ./bin/undock folder
$ undock --wrap --rm-dist --all dockereng/packaging:buildx-v0.9.1 ./bin/undock
```

<details>
  <summary>tree ./bin/undock</summary>

```
./bin/undock/
├── alpine
│   ├── 3.14
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin_0.9.1-0_x86_64.apk
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin_0.9.1-0_armhf.apk
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin_0.9.1-0_armv7.apk
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin_0.9.1-0_aarch64.apk
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin_0.9.1-0_ppc64le.apk
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin_0.9.1-0_riscv64.apk
│   │   └── s390x
│   │       └── docker-buildx-plugin_0.9.1-0_s390x.apk
│   ├── 3.15
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin_0.9.1-0_x86_64.apk
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin_0.9.1-0_armhf.apk
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin_0.9.1-0_armv7.apk
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin_0.9.1-0_aarch64.apk
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin_0.9.1-0_ppc64le.apk
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin_0.9.1-0_riscv64.apk
│   │   └── s390x
│   │       └── docker-buildx-plugin_0.9.1-0_s390x.apk
│   └── 3.16
│       ├── amd64
│       │   └── docker-buildx-plugin_0.9.1-0_x86_64.apk
│       ├── arm
│       │   ├── v6
│       │   │   └── docker-buildx-plugin_0.9.1-0_armhf.apk
│       │   └── v7
│       │       └── docker-buildx-plugin_0.9.1-0_armv7.apk
│       ├── arm64
│       │   └── docker-buildx-plugin_0.9.1-0_aarch64.apk
│       ├── ppc64le
│       │   └── docker-buildx-plugin_0.9.1-0_ppc64le.apk
│       ├── riscv64
│       │   └── docker-buildx-plugin_0.9.1-0_riscv64.apk
│       └── s390x
│           └── docker-buildx-plugin_0.9.1-0_s390x.apk
├── centos
│   ├── 7
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│   │   └── s390x
│   │       └── docker-buildx-plugin-0.9.1-0.s390x.rpm
│   ├── 8
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│   │   └── s390x
│   │       └── docker-buildx-plugin-0.9.1-0.s390x.rpm
│   └── 9
│       ├── amd64
│       │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│       ├── arm
│       │   ├── v6
│       │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│       │   └── v7
│       │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│       ├── arm64
│       │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│       ├── ppc64le
│       │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│       ├── riscv64
│       │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│       └── s390x
│           └── docker-buildx-plugin-0.9.1-0.s390x.rpm
├── debian
│   ├── bullseye
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin_0.9.1-0_amd64.deb
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin_0.9.1-0_armel.deb
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin_0.9.1-0_armhf.deb
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin_0.9.1-0_arm64.deb
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin_0.9.1-0_ppc64el.deb
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin_0.9.1-0_riscv64.deb
│   │   └── s390x
│   │       └── docker-buildx-plugin_0.9.1-0_s390x.deb
│   └── buster
│       ├── amd64
│       │   └── docker-buildx-plugin_0.9.1-0_amd64.deb
│       ├── arm
│       │   ├── v6
│       │   │   └── docker-buildx-plugin_0.9.1-0_armel.deb
│       │   └── v7
│       │       └── docker-buildx-plugin_0.9.1-0_armhf.deb
│       ├── arm64
│       │   └── docker-buildx-plugin_0.9.1-0_arm64.deb
│       ├── ppc64le
│       │   └── docker-buildx-plugin_0.9.1-0_ppc64el.deb
│       ├── riscv64
│       │   └── docker-buildx-plugin_0.9.1-0_riscv64.deb
│       └── s390x
│           └── docker-buildx-plugin_0.9.1-0_s390x.deb
├── fedora
│   ├── 35
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│   │   └── s390x
│   │       └── docker-buildx-plugin-0.9.1-0.s390x.rpm
│   ├── 36
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│   │   └── s390x
│   │       └── docker-buildx-plugin-0.9.1-0.s390x.rpm
│   └── 37
│       ├── amd64
│       │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│       ├── arm
│       │   ├── v6
│       │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│       │   └── v7
│       │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│       ├── arm64
│       │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│       ├── ppc64le
│       │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│       ├── riscv64
│       │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│       └── s390x
│           └── docker-buildx-plugin-0.9.1-0.s390x.rpm
├── oraclelinux
│   ├── 7
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│   │   └── s390x
│   │       └── docker-buildx-plugin-0.9.1-0.s390x.rpm
│   ├── 8
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│   │   └── s390x
│   │       └── docker-buildx-plugin-0.9.1-0.s390x.rpm
│   └── 9
│       ├── amd64
│       │   └── docker-buildx-plugin-0.9.1-0.x86_64.rpm
│       ├── arm
│       │   ├── v6
│       │   │   └── docker-buildx-plugin-0.9.1-0.armv6hl.rpm
│       │   └── v7
│       │       └── docker-buildx-plugin-0.9.1-0.armv7hl.rpm
│       ├── arm64
│       │   └── docker-buildx-plugin-0.9.1-0.aarch64.rpm
│       ├── ppc64le
│       │   └── docker-buildx-plugin-0.9.1-0.ppc64le.rpm
│       ├── riscv64
│       │   └── docker-buildx-plugin-0.9.1-0.riscv64.rpm
│       └── s390x
│           └── docker-buildx-plugin-0.9.1-0.s390x.rpm
├── raspbian
│   ├── bullseye
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin_0.9.1-0_amd64.deb
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin_0.9.1-0_armel.deb
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin_0.9.1-0_armhf.deb
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin_0.9.1-0_arm64.deb
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin_0.9.1-0_ppc64el.deb
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin_0.9.1-0_riscv64.deb
│   │   └── s390x
│   │       └── docker-buildx-plugin_0.9.1-0_s390x.deb
│   └── buster
│       ├── amd64
│       │   └── docker-buildx-plugin_0.9.1-0_amd64.deb
│       ├── arm
│       │   ├── v6
│       │   │   └── docker-buildx-plugin_0.9.1-0_armel.deb
│       │   └── v7
│       │       └── docker-buildx-plugin_0.9.1-0_armhf.deb
│       ├── arm64
│       │   └── docker-buildx-plugin_0.9.1-0_arm64.deb
│       ├── ppc64le
│       │   └── docker-buildx-plugin_0.9.1-0_ppc64el.deb
│       ├── riscv64
│       │   └── docker-buildx-plugin_0.9.1-0_riscv64.deb
│       └── s390x
│           └── docker-buildx-plugin_0.9.1-0_s390x.deb
├── static
│   ├── darwin
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin_0.9.1.tgz
│   │   └── arm64
│   │       └── docker-buildx-plugin_0.9.1.tgz
│   ├── linux
│   │   ├── amd64
│   │   │   └── docker-buildx-plugin_0.9.1.tgz
│   │   ├── arm
│   │   │   ├── v6
│   │   │   │   └── docker-buildx-plugin_0.9.1.tgz
│   │   │   └── v7
│   │   │       └── docker-buildx-plugin_0.9.1.tgz
│   │   ├── arm64
│   │   │   └── docker-buildx-plugin_0.9.1.tgz
│   │   ├── ppc64le
│   │   │   └── docker-buildx-plugin_0.9.1.tgz
│   │   ├── riscv64
│   │   │   └── docker-buildx-plugin_0.9.1.tgz
│   │   └── s390x
│   │       └── docker-buildx-plugin_0.9.1.tgz
│   └── windows
│       ├── amd64
│       │   └── docker-buildx-plugin_0.9.1.zip
│       └── arm64
│           └── docker-buildx-plugin_0.9.1.zip
└── ubuntu
    ├── bionic
    │   ├── amd64
    │   │   └── docker-buildx-plugin_0.9.1-0_amd64.deb
    │   ├── arm
    │   │   ├── v6
    │   │   │   └── docker-buildx-plugin_0.9.1-0_armel.deb
    │   │   └── v7
    │   │       └── docker-buildx-plugin_0.9.1-0_armhf.deb
    │   ├── arm64
    │   │   └── docker-buildx-plugin_0.9.1-0_arm64.deb
    │   ├── ppc64le
    │   │   └── docker-buildx-plugin_0.9.1-0_ppc64el.deb
    │   ├── riscv64
    │   │   └── docker-buildx-plugin_0.9.1-0_riscv64.deb
    │   └── s390x
    │       └── docker-buildx-plugin_0.9.1-0_s390x.deb
    ├── focal
    │   ├── amd64
    │   │   └── docker-buildx-plugin_0.9.1-0_amd64.deb
    │   ├── arm
    │   │   ├── v6
    │   │   │   └── docker-buildx-plugin_0.9.1-0_armel.deb
    │   │   └── v7
    │   │       └── docker-buildx-plugin_0.9.1-0_armhf.deb
    │   ├── arm64
    │   │   └── docker-buildx-plugin_0.9.1-0_arm64.deb
    │   ├── ppc64le
    │   │   └── docker-buildx-plugin_0.9.1-0_ppc64el.deb
    │   ├── riscv64
    │   │   └── docker-buildx-plugin_0.9.1-0_riscv64.deb
    │   └── s390x
    │       └── docker-buildx-plugin_0.9.1-0_s390x.deb
    └── jammy
        ├── amd64
        │   └── docker-buildx-plugin_0.9.1-0_amd64.deb
        ├── arm
        │   ├── v6
        │   │   └── docker-buildx-plugin_0.9.1-0_armel.deb
        │   └── v7
        │       └── docker-buildx-plugin_0.9.1-0_armhf.deb
        ├── arm64
        │   └── docker-buildx-plugin_0.9.1-0_arm64.deb
        ├── ppc64le
        │   └── docker-buildx-plugin_0.9.1-0_ppc64el.deb
        ├── riscv64
        │   └── docker-buildx-plugin_0.9.1-0_riscv64.deb
        └── s390x
            └── docker-buildx-plugin_0.9.1-0_s390x.deb

194 directories, 144 files
```
</details>

## Contributing

Want to contribute? Awesome! You can find information about contributing to
this project in the [CONTRIBUTING.md](/.github/CONTRIBUTING.md)
