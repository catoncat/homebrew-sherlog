# This file is a release template, not a tap formula by itself.
# The release workflow replaces every __...__ token with the version and
# SHA-256 digests computed from that release's native archives. It uploads the
# rendered sherlog.rb as a verifiable release asset; it does not mutate a tap.
class Sherlog < Formula
  desc "Progressive local search for agent session logs"
  homepage "https://github.com/catoncat/sherlog"
  version "0.5.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.3/sherlog-v0.5.3-aarch64-apple-darwin.tar.gz"
      sha256 "8c79918efc509ce1667e19113e69a62fe067e9612e0e244538b90b9f801402eb"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.3/sherlog-v0.5.3-x86_64-apple-darwin.tar.gz"
      sha256 "1372a930134198efdfd1346bcaf85e0bffd9c458e04578c325b81f56cea3e096"
    else
      odie "Sherlog does not publish a native archive for this macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.3/sherlog-v0.5.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d9fc51edf67d6e74d3e37b09369e2d8b57e285b0d7c55d6869d0c882c5e723e6"
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
