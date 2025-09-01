class Snapx < Formula
  desc "Screenshot tool that handles images, text, and video (fork of ShareX)"
  homepage "https://github.com/SnapXL/SnapX"
  url "https://github.com/SnapXL/SnapX/archive/refs/tags/homebrew.tar.gz"
  version "0.4.0"
  sha256 "c53bc2070752ccc68b4ed225a35d2a721dfe6365c1d672f328686440bb9cb6c3"
  license "GPL-3.0-or-later"
  head "https://github.com/SnapXL/SnapX.git", branch: "develop"
  # Uncomment to bump the package when still using the same SnapX version. Acts like the release field in snapx.spec
  # revision 1

  depends_on "dotnet" => :build
  depends_on "git" => :build
  # NativeAOT support
  depends_on "llvm" => :build
  depends_on "ffmpeg@7"
  # This requirement is dictated by .NET.
  depends_on macos: :monterey

  on_macos do
    # Screenshotting on macOS is done via a Rust compat layer. We must compile it.
    depends_on "rust" => :build
  end
  on_linux do
    depends_on "dbus"
    depends_on "libsm"
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "libxrandr"
  end

  def install
    ENV["SKIP_MACOS_VERSION_CHECK"] = "1"
    ENV["ELEVATION_NOT_NEEDED"] = "1"
    ENV["PKGTYPE"] = "HOMEBREW"
    ENV["ALLOW_DOTNET_DOWNLOAD"] = "1"
    system "./build.sh", "install", "--prefix", prefix
  end

  def caveats
    <<~EOS
      On Ubuntu, you need to run
        sudo apt install -y xdg-utils
      On Fedora, you need to run
        sudo dnf in -y xdg-utils
      Additionally, SnapX hasn't been able to create the configuration file(s) it expects.
      You should place it in the configuration directory that it expects.
      On Linux, it's
        ~/.config/SnapX
      On macOS, it's
        ~/Library/Application Support/SnapX
    EOS
  end

  test do
    system bin/"snapx", "--version"
  end
end
