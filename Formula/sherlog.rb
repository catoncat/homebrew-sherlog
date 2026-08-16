# This file is a release template, not a tap formula by itself.
# The release workflow replaces every __...__ token with the version and
# SHA-256 digests computed from that release's native archives. It uploads the
# rendered sherlog.rb as a verifiable release asset; it does not mutate a tap.
class Sherlog < Formula
  desc "Progressive local search for agent session logs"
  homepage "https://github.com/catoncat/sherlog"
  version "0.5.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.1/sherlog-v0.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "93436d843c1e12a8450448564fdada180cba64272c387935d4ff8ce9c85cc848"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.1/sherlog-v0.5.1-x86_64-apple-darwin.tar.gz"
      sha256 "b377e8db881d33087561d739e39ab011b9284310c5f7eaad2a68ece2a2861fcb"
    else
      odie "Sherlog does not publish a native archive for this macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.1/sherlog-v0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6696507ea597aef130297cab959c1dc183f96e7e7a87c94985eb3ae670046b12"
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
