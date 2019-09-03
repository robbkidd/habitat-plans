$pkg_name="ruby"
$pkg_origin="robbkidd"
$pkg_version="2.6.4"
$pkg_description="A dynamic, open source programming language with a focus on \
  simplicity and productivity. It has an elegant syntax that is natural to \
  read and easy to write."
$pkg_license=("Ruby")
$pkg_maintainer="Robb Kidd <robb@thekidds.org>"
$pkg_source="https://cache.ruby-lang.org/pub/$pkg_name/$pkg_name-$pkg_version.zip"
$pkg_upstream_url="https://www.ruby-lang.org/en/"
$pkg_shasum="8446eaaa633a8d55146df0874154b8eb1e5ea5a000d803503d83fd67d9e9372c"
$pkg_deps=@(
    "core/openssl"
    "core/zlib"
)
$pkg_build_deps=@("core/visual-cpp-build-tools-2015")
$pkg_lib_dirs=@("lib")
$pkg_include_dirs=@("include")
$pkg_bin_dirs=@("bin")
$pkg_interpreters=@("bin/ruby")

function Invoke-Unpack {
    # The Ruby source ZIP has a directory within it that matches Hab's expected $pkg_dirname
    # so override the default PowerShell Unpack that targets $pkg_dirname with this one so the
    # source directory looks like what Hab expects and we avoid Push- and Pop-Location in the build.
    Expand-Archive -Path "$HAB_CACHE_SRC_PATH/$pkg_filename" -DestinationPath "$HAB_CACHE_SRC_PATH"
}

function Invoke-Build {
    ./win32/configure.bat `
        --prefix="$pkg_prefix" `
        --disable-install-doc `
        --target=x64-mswin64
    nmake
    nmake check
}

function Invoke-Install {
    nmake install
    gem update --system --no-document
    gem install rb-readline --no-document
}