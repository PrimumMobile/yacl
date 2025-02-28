# Copyright 2023 Ant Group Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

SECRETFLOW_GIT = "https://github.com/secretflow"

IC_COMMIT_ID = "e9a64bfe1ae57f358b41790a1bdd82c390dd50da"

SIMPLEST_OT_COMMIT_ID = "4e39b7c35721c7fd968da6e047f59c0ac92e8088"

def yacl_deps():
    _rule_proto()
    _rule_python()
    _rules_foreign_cc()
    _com_github_madler_zlib()
    _com_google_protobuf()
    _com_github_gflags_gflags()
    _com_google_googletest()
    _com_google_absl()
    _com_github_google_leveldb()
    _com_github_brpc_brpc()
    _com_github_fmtlib_fmt()
    _com_github_gabime_spdlog()
    _com_github_google_benchmark()
    _com_github_google_cpu_features()
    _com_github_dltcollab_sse2neon()
    _com_github_msgpack_msgpack()
    _com_github_greendow_hash_drbg()

    # crypto related
    _com_github_openssl_openssl()
    _com_github_blake3team_blake3()
    _com_github_libsodium()
    _com_github_libtom_libtommath()
    _com_github_herumi_mcl()

    maybe(
        git_repository,
        name = "simplest_ot",
        commit = SIMPLEST_OT_COMMIT_ID,
        recursive_init_submodules = True,
        remote = "{}/simplest-ot.git".format(SECRETFLOW_GIT),
    )

    maybe(
        git_repository,
        name = "org_interconnection",
        commit = IC_COMMIT_ID,
        remote = "{}/interconnection.git".format(SECRETFLOW_GIT),
    )

    # Add homebrew openmp for macOS, somehow..homebrew installs to different location on Apple Silcon/Intel macs.. so we need two rules here
    native.new_local_repository(
        name = "macos_omp_x64",
        build_file = "@yacl//bazel:local_openmp_macos.BUILD",
        path = "/usr/local/opt/libomp",
    )

    native.new_local_repository(
        name = "macos_omp_arm64",
        build_file = "@yacl//bazel:local_openmp_macos.BUILD",
        path = "/opt/homebrew/opt/libomp/",
    )

def _com_github_brpc_brpc():
    maybe(
        http_archive,
        name = "com_github_brpc_brpc",
        sha256 = "48668cbc943edd1b72551e99c58516249d15767b46ea13a843eb8df1d3d1bc42",
        strip_prefix = "brpc-1.7.0",
        type = "tar.gz",
        patch_args = ["-p1"],
        patches = [
            "@yacl//bazel:patches/brpc.patch",
            "@yacl//bazel:patches/brpc_m1.patch",
        ],
        urls = [
            "https://github.com/apache/brpc/archive/refs/tags/1.7.0.tar.gz",
        ],
    )

def _com_github_gflags_gflags():
    maybe(
        http_archive,
        name = "com_github_gflags_gflags",
        strip_prefix = "gflags-2.2.2",
        sha256 = "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf",
        type = "tar.gz",
        urls = [
            "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz",
        ],
    )

def _com_github_google_leveldb():
    maybe(
        http_archive,
        name = "com_github_google_leveldb",
        strip_prefix = "leveldb-1.23",
        sha256 = "9a37f8a6174f09bd622bc723b55881dc541cd50747cbd08831c2a82d620f6d76",
        type = "tar.gz",
        build_file = "@yacl//bazel:leveldb.BUILD",
        patch_args = ["-p1"],
        patches = ["@yacl//bazel:patches/leveldb.patch"],
        urls = [
            "https://github.com/google/leveldb/archive/refs/tags/1.23.tar.gz",
        ],
    )

def _com_github_madler_zlib():
    maybe(
        http_archive,
        name = "zlib",
        build_file = "@yacl//bazel:zlib.BUILD",
        strip_prefix = "zlib-1.3",
        sha256 = "b5b06d60ce49c8ba700e0ba517fa07de80b5d4628a037f4be8ad16955be7a7c0",
        type = ".tar.gz",
        patch_args = ["-p1"],
        patches = ["@yacl//bazel:patches/zlib.patch"],
        urls = [
            "https://github.com/madler/zlib/archive/refs/tags/v1.3.tar.gz",
        ],
    )

def _com_google_protobuf():
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "ba0650be1b169d24908eeddbe6107f011d8df0da5b1a5a4449a913b10e578faf",
        strip_prefix = "protobuf-3.19.4",
        type = "tar.gz",
        urls = [
            "https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protobuf-all-3.19.4.tar.gz",
        ],
    )

def _com_google_absl():
    maybe(
        http_archive,
        name = "com_google_absl",
        sha256 = "987ce98f02eefbaf930d6e38ab16aa05737234d7afbab2d5c4ea7adbe50c28ed",
        type = "tar.gz",
        strip_prefix = "abseil-cpp-20230802.1",
        urls = [
            "https://github.com/abseil/abseil-cpp/archive/refs/tags/20230802.1.tar.gz",
        ],
    )

def _com_github_openssl_openssl():
    maybe(
        http_archive,
        name = "com_github_openssl_openssl",
        sha256 = "9a7a7355f3d4b73f43b5730ce80371f9d1f97844ffc8c4b01c723ba0625d6aad",
        type = "tar.gz",
        strip_prefix = "openssl-openssl-3.0.12",
        urls = [
            "https://github.com/openssl/openssl/archive/refs/tags/openssl-3.0.12.tar.gz",
        ],
        build_file = "@yacl//bazel:openssl.BUILD",
    )

def _com_github_fmtlib_fmt():
    maybe(
        http_archive,
        name = "com_github_fmtlib_fmt",
        strip_prefix = "fmt-10.1.1",
        sha256 = "78b8c0a72b1c35e4443a7e308df52498252d1cefc2b08c9a97bc9ee6cfe61f8b",
        build_file = "@yacl//bazel:fmtlib.BUILD",
        urls = [
            "https://github.com/fmtlib/fmt/archive/refs/tags/10.1.1.tar.gz",
        ],
    )

def _com_github_gabime_spdlog():
    maybe(
        http_archive,
        name = "com_github_gabime_spdlog",
        strip_prefix = "spdlog-1.12.0",
        type = "tar.gz",
        sha256 = "4dccf2d10f410c1e2feaff89966bfc49a1abb29ef6f08246335b110e001e09a9",
        build_file = "@yacl//bazel:spdlog.BUILD",
        urls = [
            "https://github.com/gabime/spdlog/archive/refs/tags/v1.12.0.tar.gz",
        ],
    )

def _com_google_googletest():
    maybe(
        http_archive,
        name = "com_google_googletest",
        sha256 = "ad7fdba11ea011c1d925b3289cf4af2c66a352e18d4c7264392fead75e919363",
        type = "tar.gz",
        strip_prefix = "googletest-1.13.0",
        urls = [
            "https://github.com/google/googletest/archive/refs/tags/v1.13.0.tar.gz",
        ],
    )

def _com_github_google_benchmark():
    maybe(
        http_archive,
        name = "com_github_google_benchmark",
        type = "tar.gz",
        strip_prefix = "benchmark-1.8.2",
        sha256 = "2aab2980d0376137f969d92848fbb68216abb07633034534fc8c65cc4e7a0e93",
        urls = [
            "https://github.com/google/benchmark/archive/refs/tags/v1.8.2.tar.gz",
        ],
    )

def _com_github_blake3team_blake3():
    maybe(
        http_archive,
        name = "com_github_blake3team_blake3",
        strip_prefix = "BLAKE3-1.4.1",
        sha256 = "33020ac83a8169b2e847cc6fb1dd38806ffab6efe79fe6c320e322154a3bea2c",
        build_file = "@yacl//bazel:blake3.BUILD",
        urls = [
            "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.4.1.tar.gz",
        ],
    )

def _rule_proto():
    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
        strip_prefix = "rules_proto-5.3.0-21.7",
        urls = [
            "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
        ],
    )

# Required by protobuf
def _rule_python():
    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "0a8003b044294d7840ac7d9d73eef05d6ceb682d7516781a4ec62eeb34702578",
        strip_prefix = "rules_python-0.24.0",
        urls = [
            "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.24.0.tar.gz",
        ],
    )

def _rules_foreign_cc():
    maybe(
        http_archive,
        name = "rules_foreign_cc",
        sha256 = "476303bd0f1b04cc311fc258f1708a5f6ef82d3091e53fd1977fa20383425a6a",
        strip_prefix = "rules_foreign_cc-0.10.1",
        urls = [
            "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/0.10.1.tar.gz",
        ],
    )

def _com_github_libsodium():
    maybe(
        http_archive,
        name = "com_github_libsodium",
        type = "tar.gz",
        strip_prefix = "libsodium-1.0.18",
        sha256 = "6f504490b342a4f8a4c4a02fc9b866cbef8622d5df4e5452b46be121e46636c1",
        build_file = "@yacl//bazel:libsodium.BUILD",
        urls = [
            "https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz",
        ],
    )

def _com_github_google_cpu_features():
    maybe(
        http_archive,
        name = "com_github_google_cpu_features",
        strip_prefix = "cpu_features-0.9.0",
        type = "tar.gz",
        build_file = "@yacl//bazel:cpu_features.BUILD",
        sha256 = "bdb3484de8297c49b59955c3b22dba834401bc2df984ef5cfc17acbe69c5018e",
        urls = [
            "https://github.com/google/cpu_features/archive/refs/tags/v0.9.0.tar.gz",
        ],
    )

def _com_github_dltcollab_sse2neon():
    maybe(
        http_archive,
        name = "com_github_dltcollab_sse2neon",
        sha256 = "66e3d92571bfc9ce05dc1737421ba2f68e1fcb4552def866055676619955bdaa",
        strip_prefix = "sse2neon-fb160a53e5a4ba5bc21e1a7cb80d0bd390812442",
        type = "tar.gz",
        urls = [
            "https://github.com/DLTcollab/sse2neon/archive/fb160a53e5a4ba5bc21e1a7cb80d0bd390812442.tar.gz",
        ],
        build_file = "@yacl//bazel:sse2neon.BUILD",
    )

def _com_github_libtom_libtommath():
    maybe(
        http_archive,
        name = "com_github_libtom_libtommath",
        sha256 = "dbfdafbaeb51ff92fdd3f2505ec0490f8a9badc2a71b378219856b68d470f0aa",
        type = "tar.gz",
        strip_prefix = "libtommath-8ce69f7b5e2f34620633f4fb5c231045a8dc2f54",
        patch_args = ["-p1"],
        patches = [
            "@yacl//bazel:patches/libtommath.patch",
        ],
        urls = [
            "https://github.com/libtom/libtommath/archive/8ce69f7b5e2f34620633f4fb5c231045a8dc2f54.tar.gz",
        ],
        build_file = "@yacl//bazel:libtommath.BUILD",
    )

def _com_github_msgpack_msgpack():
    maybe(
        http_archive,
        name = "com_github_msgpack_msgpack",
        type = "tar.gz",
        strip_prefix = "msgpack-c-cpp-6.1.0",
        sha256 = "5e63e4d9b12ab528fccf197f7e6908031039b1fc89cd8da0e97fbcbf5a6c6d3a",
        urls = [
            "https://github.com/msgpack/msgpack-c/archive/refs/tags/cpp-6.1.0.tar.gz",
        ],
        build_file = "@yacl//bazel:msgpack.BUILD",
    )

def _com_github_greendow_hash_drbg():
    maybe(
        http_archive,
        name = "com_github_greendow_hash_drbg",
        sha256 = "c03a3da5742d0f0c40232817d84f21d8eed4c4af498c4dff3a51b3bcadcb3787",
        type = "tar.gz",
        strip_prefix = "Hash-DRBG-2411fa9d0de81c69dce2a48555c30298253db15d",
        urls = [
            "https://github.com/greendow/Hash-DRBG/archive/2411fa9d0de81c69dce2a48555c30298253db15d.tar.gz",
        ],
        build_file = "@yacl//bazel:hash_drbg.BUILD",
    )

def _com_github_herumi_mcl():
    maybe(
        http_archive,
        name = "com_github_herumi_mcl",
        strip_prefix = "mcl-1.84.0",
        sha256 = "dc655c2eb5b2426736d8ab92ed501de0ac78472f1ee7083919a98a8aca3e76a3",
        type = "tar.gz",
        build_file = "@yacl//bazel:mcl.BUILD",
        patch_args = ["-p1"],
        patches = [
            "@yacl//bazel:patches/mcl.patch",
        ],
        urls = ["https://github.com/herumi/mcl/archive/refs/tags/v1.84.0.tar.gz"],
    )
