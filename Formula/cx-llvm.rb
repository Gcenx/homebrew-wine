class CxLlvm < Formula
  desc "CodeWeavers custom compiler for -mwine32 targets"
  homepage "https://codeweavers.com/"
  url "https://media.codeweavers.com/pub/crossover/source/crossover-sources-21.2.0.tar.gz"
  version "8.0" # based on llvm/clang 8.0
  sha256 "138ee0d3c2232b6ef28d50a3efd43c2565e3b813838c6a4e32c8c5c024b5d17f"
  license "NCSA"

  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/cx-llvm-8.0"
    rebuild 1
    sha256 cellar: :any, mojave: "77234e4ffd46aa51d30f79a846530be449a7c31a05bf5e44bffeba18c41ba2c7"
    sha256 cellar: :any, big_sur: "ae871ce3f2dee3e9a45f1d5b6951305f69416ae6d3a9ba6582f07c02f6044f58"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :versioned_formula

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on arch: :x86_64

  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    mv "clang/clang", "clang/llvm/projects/clang"
    mv "clang/llvm", "llvm"

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    args = %W[
      -DLIBOMP_ARCH=x86_64
      -DFFI_INCLUDE_DIR=#{MacOS.sdk_path}/usr/include/ffi
      -DFFI_LIBRARY_DIR=#{MacOS.sdk_path}/usr/lib
    ]

    if MacOS.version >= :mojave
      sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
      args << "-DDEFAULT_SYSROOT=#{sdk_path}"
    end

    cd "llvm" do
      mkdir "build" do
        system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    system "#{bin}/clang", "--version"
  end
end
