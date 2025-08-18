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

variable "DISTROS" {
  description = "List of supported distros. Don't forget to update _distro-* target if you add/remove a distro."
  default = [
    "static",

    "debian13",
    "debian14",

    "anolis23",
    "loongnix23",
    "kylin11",
    "opencloudos9",
    "opencloudos23",
    "openeuler24"
  ]
}

variable "PKGS" {
  description = "List of packages to build from ./pkg directory. Don't forget to update _pkg-* target if you add/remove a package."
  default = [
    "buildx",
    "compose",
    "containerd",
    "credential-helpers",
    "docker-cli",
    "docker-engine",
    "model",
    "cagent"
  ]
}

variable "DISTRO_NAME" {
  description = "Name of the distro."
  default = null
}
variable "DISTRO_TYPE" {
  description = "Type of the distro. One of deb, rpm, static."
  default = null
}
variable "DISTRO_RELEASE" {
  description = "Distro release name."
  default = null
}
variable "DISTRO_ID" {
  description = "Distro ID, e.g. 11 for debian11, 12 for debian12, etc."
  default = null
}
variable "DISTRO_SUITE" {
  description = "Distro suite name, e.g. bullseye for debian11, bookworm for debian12, etc."
  default = null
}
variable "DISTRO_IMAGE" {
  description = "Distro image to use for building packages."
  default = null
}

variable "PKG_NAME" {
  description = "Name of the package to build."
  default = null
}
variable "PKG_REPO" {
  description = "Repository URL of the package to build."
  default = null
}
variable "PKG_REF" {
  description = "Reference (branch, tag, commit) of the package to build."
  default = null
}
variable "PKG_VENDOR" {
  description = "Name of the vendor/maintainer of the package (only for linux packages)."
  default = "Docker"
}

variable "PKG_PACKAGER" {
  description = "Name of the company that produced the package (only for linux packages)."
  default = "Docker <support@docker.com>"
}

variable "PKG_DEB_BUILDFLAGS" {
  description = "Flags to pass to dpkg-buildpackage."
  default = "-b -uc"
}
variable "PKG_DEB_REVISION" {
  description = "Revision of the package to build, used for debian packages. Include an extra .0 in the version, in case we ever would have to re-build an already published release with a packaging-only change."
  default = "1"
}
variable "PKG_DEB_EPOCH" {
  description = "Epoch of the package to build, used for debian packages. This is used to allow mistakes in the version numbers of older versions of a package, and also a package's previous version numbering schemes, to be left behind. Should be enforced per package and not globally."
  default = null
}

variable "PKG_RPM_BUILDFLAGS" {
  description = "Flags to pass to rpmbuild."
  default = "-bb"
}
# rpm "Release:" field ($rpmRelease) is used to set the "_release" macro, which
# is an incremental number for builds of the same release (Version: / #rpmVersion)
# - Version: 0   : Package was built, but no matching upstream release (e.g., can be used for "nightly" builds)
# - Version: 1   : Package was built for an upstream (pre)release version
# - Version: > 1 : Only to be used for packaging-only changes (new package built for a version for which a package was already built/released)
variable "PKG_RPM_RELEASE" {
  description = "Release of the package to build, used for rpm packages. This to set the _release macro, which is an incremental number for builds of the same release (Version: / #rpmVersion)."
  default = null
}

variable "RUNC_REF" {
  description = "Reference (branch, tag, commit) of runc to build. Only used for containerd package. If not set, defaults to the version specified in containerd's script/setup/runc-version file."
  default = null
}

variable "NIGHTLY_BUILD" {
  description = "Set to 1 to enforce nightly build."
  default = null
}

variable "GO_IMAGE" {
  description = "Go image to use for building packages."
  default = "golang"
}
variable "GO_VERSION" {
  description = "Go version to use for building packages."
  default = null
}
variable "GO_IMAGE_VARIANT" {
  description = "Go image variant to use for building packages."
  default = "trixie"
}

variable "LOCAL_PLATFORM" {
  description = "Set to the current platform's default platform specification to build only for the local platform. If null, all platforms for the distro and package will be built."
  default = null
}

variable "BUILD_CACHE_REGISTRY_SLUG" {
  description = "Slug for the registry cache exporter."
  default = "ghcr.io/loong64/dockereng/packaging-cache"
}
variable "BUILD_CACHE_REGISTRY_PUSH" {
  description = "Set to 1 to enable pushing to the registry cache exporter."
  default = ""
}

#
# distros configurations
#

target "_distro-static" {
  args = {
    DISTRO_NAME = ""
    DISTRO_TYPE = "static"
    DISTRO_RELEASE = "static"
    DISTRO_ID = ""
    DISTRO_SUITE = ""
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/debian:trixie"
    TEST_ONLY = "0"
  }
}

target "_distro-debian13" {
  args = {
    DISTRO_NAME = "debian13"
    DISTRO_TYPE = "deb"
    DISTRO_RELEASE = "debian"
    DISTRO_ID = "13"
    DISTRO_SUITE = "trixie"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/debian:trixie"
    TEST_ONLY = "0"
  }
}

target "_distro-debian14" {
  args = {
    DISTRO_NAME = "debian14"
    DISTRO_TYPE = "deb"
    DISTRO_RELEASE = "debian"
    DISTRO_ID = "14"
    DISTRO_SUITE = "forky"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/debian:forky"
    TEST_ONLY = "0"
  }
}

target "_distro-anolis23" {
  args = {
    DISTRO_NAME = "anolis23"
    DISTRO_TYPE = "rpm"
    DISTRO_RELEASE = "anolis"
    DISTRO_ID = "23"
    DISTRO_SUITE = "23"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/anolis:23"
    TEST_ONLY = "0"
  }
}

target "_distro-loongnix23" {
  args = {
    DISTRO_NAME = "loongnix23"
    DISTRO_TYPE = "rpm"
    DISTRO_RELEASE = "loongnix"
    DISTRO_ID = "23"
    DISTRO_SUITE = "23"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/loongnix:23"
    TEST_ONLY = "0"
  }
}

target "_distro-kylin11" {
  args = {
    DISTRO_NAME = "kylin11"
    DISTRO_TYPE = "rpm"
    DISTRO_RELEASE = "kylin"
    DISTRO_ID = "11"
    DISTRO_SUITE = "11"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/kylin:11"
    TEST_ONLY = "0"
  }
}

target "_distro-opencloudos9" {
  args = {
    DISTRO_NAME = "opencloudos9"
    DISTRO_TYPE = "rpm"
    DISTRO_RELEASE = "opencloudos"
    DISTRO_ID = "9"
    DISTRO_SUITE = "9"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/opencloudos:9"
    TEST_ONLY = "0"
  }
}

target "_distro-opencloudos23" {
  args = {
    DISTRO_NAME = "opencloudos23"
    DISTRO_TYPE = "rpm"
    DISTRO_RELEASE = "opencloudos"
    DISTRO_ID = "23"
    DISTRO_SUITE = "23"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/opencloudos:23"
    TEST_ONLY = "0"
  }
}

target "_distro-openeuler24" {
  args = {
    DISTRO_NAME = "openeuler24"
    DISTRO_TYPE = "rpm"
    DISTRO_RELEASE = "openeuler"
    DISTRO_ID = "24"
    DISTRO_SUITE = "24"
    DISTRO_IMAGE = DISTRO_IMAGE != null && DISTRO_IMAGE != "" ? DISTRO_IMAGE : "ghcr.io/loong64/openeuler:24"
    TEST_ONLY = "0"
  }
}

# Returns the list of supported platforms for a given distro and package.
# The result is the intersection of the platforms supported by the distro
# and the platforms supported by the package. Except for static distro,
# where we return all the platforms supported by the package as we are
# doing cross-compilation.
function "distroPlatforms" {
  params = [distro, pkg]
  result = distro == "static" ? pkgPlatforms(pkg) : setsubtract(
    setintersection(
      lookup({
        static = pkgPlatforms(pkg)

        debian13 = ["linux/loong64", "linux/ppc64le","linux/s390x"]
        debian14 = ["linux/loong64", "linux/ppc64le","linux/s390x"]

        anolis23 = ["linux/amd64", "linux/arm64", "linux/loong64"]
        loongnix23 = ["linux/loong64"]
        kylin11 = ["linux/amd64", "linux/arm64", "linux/loong64"]
        opencloudos9 = ["linux/amd64", "linux/arm64", "linux/loong64"]
        opencloudos23 = ["linux/amd64", "linux/arm64", "linux/loong64"]
        openeuler24 = ["linux/amd64", "linux/arm64", "linux/loong64"]
      }, distro, []),
      pkgPlatforms(pkg)
    ),
    # FIXME: add linux/ppc64le when a remote PowerPC instance is available (too slow with QEMU)
    # FIXME: add linux/riscv64 when a remote RISC-V instance is available (too slow with QEMU)
    # FIXME: add linux/s390x when a remote LinuxONE instance is reachable again (too slow with QEMU)
    # ["linux/loong64", "linux/ppc64le", "linux/riscv64", "linux/s390x"]
    []
  )
}

# Returns the list of secrets to use for a given distro.
function "distroSecrets" {
  params = [distro]
  result = length(regexall("^rhel", distro)) > 0 ? ["type=env,id=RH_USER,env=RH_USER", "type=env,id=RH_PASS,env=RH_PASS"] : []
}

#
# pkgs configurations
#

target "_pkg-buildx" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "docker-buildx-plugin"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/docker/buildx.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "master"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.25" # https://github.com/docker/buildx/blob/master/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : ""
    PKG_REMOTE_DOCKERFILE = "Dockerfile"
  }
}

target "_pkg-compose" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "docker-compose-plugin"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/docker/compose.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "main"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.25.7" # https://github.com/docker/compose/blob/main/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : ""
    PKG_REMOTE_DOCKERFILE = "Dockerfile"
  }
}

target "_pkg-containerd" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "containerd.io"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/containerd/containerd.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "main"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.24.13" # https://github.com/containerd/containerd/blob/main/.github/workflows/release/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : ""
    RUNC_REF = RUNC_REF != null && RUNC_REF != "" ? RUNC_REF : null
    PKG_REMOTE_DOCKERFILE = ".github/workflows/release/Dockerfile"
  }
}

target "_pkg-credential-helpers" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "docker-credential-helpers"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/docker/docker-credential-helpers.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "main"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.25.7" # https://github.com/docker/docker-credential-helpers/blob/main/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : ""
    PKG_REMOTE_DOCKERFILE = "Dockerfile"
  }
}

target "_pkg-docker-cli" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "docker-ce-cli"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/docker/cli.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "master"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.25.7" # https://github.com/docker/cli/blob/master/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : "5"
    PKG_REMOTE_DOCKERFILE = "Dockerfile"
  }
}

target "_pkg-docker-engine" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "docker-ce"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/docker/docker.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "master"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.25.7" # https://github.com/moby/moby/blob/master/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : "5"
    PKG_REMOTE_DOCKERFILE = "Dockerfile"
  }
}

target "_pkg-model" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "docker-model-plugin"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/docker/model-runner.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "main"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.25" # https://github.com/docker/model-runner/blob/main/cmd/cli/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : ""
    PKG_REMOTE_DOCKERFILE = "Dockerfile"
  }
}

target "_pkg-cagent" {
  args = {
    PKG_NAME = PKG_NAME != null && PKG_NAME != "" ? PKG_NAME : "cagent"
    PKG_REPO = PKG_REPO != null && PKG_REPO != "" ? PKG_REPO : "https://github.com/docker/cagent.git"
    PKG_REF = PKG_REF != null && PKG_REF != "" ? PKG_REF : "main"
    GO_VERSION = GO_VERSION != null && GO_VERSION != "" ? GO_VERSION : "1.26.0" # https://github.com/docker/cagent/blob/main/Dockerfile
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT != null && GO_IMAGE_VARIANT != "" ? GO_IMAGE_VARIANT : "trixie"
    PKG_DEB_EPOCH = PKG_DEB_EPOCH != null && PKG_DEB_EPOCH != "" ? PKG_DEB_EPOCH : ""
    PKG_REMOTE_DOCKERFILE = "Dockerfile"
  }
}

# Returns the list of supported platforms for a given package.
function "pkgPlatforms" {
  params = [pkg]
  result = lookup({
    # https://github.com/docker/buildx/blob/0c747263ef1426f5fa217fcdb616eddf33da6c2d/docker-bake.hcl#L156-L174
    buildx = ["linux/amd64", "linux/arm64", "linux/loong64", "linux/ppc64le", "linux/s390x"]
    # https://github.com/docker/compose/blob/c626befee1596abcc74578cb10dd96ae1667f76f/docker-bake.hcl#L112-L124
    compose = ["linux/amd64", "linux/arm64", "linux/loong64", "linux/ppc64le", "linux/s390x"]
    # https://github.com/containerd/containerd/blob/87742bd35f6ddc47c638a448c271b7ccf8df9010/.github/workflows/ci.yml#L145-L165
    # https://github.com/containerd/containerd/blob/87742bd35f6ddc47c638a448c271b7ccf8df9010/.github/workflows/ci.yml#L135-L137
    containerd = ["linux/amd64", "linux/arm64", "linux/loong64", "linux/ppc64le", "linux/s390x"]
    # https://github.com/docker/docker-credential-helpers/blob/f9d3010165b642df37215b1be945552f2c6f0e3b/docker-bake.hcl#L56-L66
    credential-helpers = []
    # https://github.com/docker/cli/blob/84038691220e7ba3329a177e4e3357b4ee0e3a52/docker-bake.hcl#L30-L42
    docker-cli = ["linux/amd64", "linux/arm64", "linux/loong64", "linux/ppc64le", "linux/s390x"]
    # https://github.com/moby/moby/blob/83264918d3e1c61341511e360a7277150b914b3f/docker-bake.hcl#L82-L91
    docker-engine = ["linux/amd64", "linux/arm64", "linux/loong64", "linux/ppc64le", "linux/s390x"]
    # https://github.com/docker/model-runner/blob/039f7a31c0365f9161c9b9b6bb3888161d16e388/cmd/cli/Makefile#L39-L43
    model = []
    # https://github.com/docker/cagent/blob/1a83a28df2b0769e8cb14d54ac409bdbb98e254c/Taskfile.yml#L66
    cagent = []
  }, pkg, [])
}

#
#
#

target "_common" {
  args = {
    BUILDKIT_MULTI_PLATFORM = 1
    NIGHTLY_BUILD = NIGHTLY_BUILD
    GO_IMAGE = GO_IMAGE
    GO_VERSION = GO_VERSION
    GO_IMAGE_VARIANT = GO_IMAGE_VARIANT
    PKG_NAME = PKG_NAME
    PKG_REPO = PKG_REPO
    PKG_REF = PKG_REF
    PKG_VENDOR = PKG_VENDOR
    PKG_PACKAGER = PKG_PACKAGER
    PKG_DEB_BUILDFLAGS = PKG_DEB_BUILDFLAGS
    PKG_DEB_REVISION = PKG_DEB_REVISION
    PKG_DEB_EPOCH = PKG_DEB_EPOCH
    PKG_RPM_BUILDFLAGS = PKG_RPM_BUILDFLAGS
    PKG_RPM_RELEASE = PKG_RPM_RELEASE
    RUNC_REF = RUNC_REF
  }
}

# Special target: https://github.com/docker/metadata-action#bake-definition
target "meta-helper" {
  tags = ["dockereng/packaging:local"]
}

group "default" {
  targets = ["validate"]
}

target "pkg" {
  name = "pkg-${pkg}-${distro}"
  description = "Build ${pkg} package for ${distro}"
  inherits = ["_common", "_distro-${distro}", "_pkg-${pkg}"]
  matrix = {
    pkg = PKGS
    distro = DISTROS
  }
  context = "./pkg/${pkg}"
  contexts = {
    scripts = "./hack/scripts"
  }
  output = ["type=local,dest=./bin/pkg/${pkg}/${distro}"]
  # BAKE_LOCAL_PLATFORM is a built-in var returning the current platform's
  # default platform specification: https://docs.docker.com/build/customize/bake/file-definition/#built-in-variables
  platforms = LOCAL_PLATFORM != null ? [BAKE_LOCAL_PLATFORM] : distroPlatforms(distro, pkg)
  secret = distroSecrets(distro)
  attest = [
    "type=sbom",
    "type=provenance,mode=max"
  ]
}

target "verify" {
  name = "verify-${pkg}-${distro}"
  description = "Verify ${pkg} package for ${distro}"
  inherits = ["_common", "_distro-${distro}", "_pkg-${pkg}"]
  matrix = {
    pkg = PKGS
    distro = DISTROS
  }
  context = "./pkg/${pkg}"
  dockerfile = "verify.Dockerfile"
  contexts = {
    scripts = "./hack/scripts"
    bin = "./bin/pkg/${pkg}/${distro}"
  }
  no-cache = true
  output = ["type=cacheonly"]
}

# Create release image by using ./bin folder as named context. Make sure all
# pkg targets are called before releasing
target "release" {
  name = "release-${pkg}"
  description = "Release ${pkg} package"
  inherits = ["_common", "meta-helper", "_pkg-${pkg}"]
  matrix = {
    pkg = PKGS
  }
  dockerfile = "./hack/release.Dockerfile"
  contexts = {
    bin = "./bin/pkg/${pkg}"
  }
  platforms = pkgPlatforms(pkg)
}

target "metadata" {
  name = "metadata-${pkg}"
  description = "Generate metadata for ${pkg} package"
  inherits = ["_common", "_pkg-${pkg}"]
  matrix = {
    pkg = PKGS
  }
  context = "./pkg/${pkg}"
  contexts = {
    scripts = "./hack/scripts"
  }
  target = "metadata"
  output = ["./bin/pkg/${pkg}"]
  args = {
    BUILDKIT_MULTI_PLATFORM = 0
  }
}

group "validate" {
  targets = ["license-validate"]
}

target "license-validate" {
  target = "license-validate"
  output = ["type=cacheonly"]
}

target "license-update" {
  target = "license-update"
  output = ["."]
}
