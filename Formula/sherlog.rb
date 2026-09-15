# This file is a release template, not a tap formula by itself.
# The release workflow replaces every __...__ token with the version and
# SHA-256 digests computed from that release's native archives. It uploads the
# rendered sherlog.rb as a verifiable release asset; it does not mutate a tap.
class Sherlog < Formula
  desc "Progressive local search for agent session logs"
  homepage "https://github.com/catoncat/sherlog"
  version "0.5.4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.4/sherlog-v0.5.4-aarch64-apple-darwin.tar.gz"
      sha256 "0d9c718f31ebcca0a6bb62eef3042b5ee0bdfeba3bae3f9a4e59959851c7acbe"
    else
      odie "Sherlog only publishes a native archive for Apple Silicon macOS"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.4/sherlog-v0.5.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "febfc094f8f4a671b4cbbcb6a71d322cc76c7c4083b3193d7678a6e89ee072ad"
    else
      odie "Sherlog does not publish a native archive for this Linux architecture"
    end
  end

  def install
    bin.install "shlog"
    bin.install_symlink "shlog" => "sherlog"
  end

  test do
    reported_version = shell_output("#{bin}/shlog --version").strip.split.last.delete_prefix("v")
    assert_equal version.to_s, reported_version
    assert_match "Usage", shell_output("#{bin}/shlog --help")
    assert_match version.to_s, shell_output("#{bin}/sherlog --version")
  end
end
