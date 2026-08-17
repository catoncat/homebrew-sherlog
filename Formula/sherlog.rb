# This file is a release template, not a tap formula by itself.
# The release workflow replaces every __...__ token with the version and
# SHA-256 digests computed from that release's native archives. It uploads the
# rendered sherlog.rb as a verifiable release asset; it does not mutate a tap.
class Sherlog < Formula
  desc "Progressive local search for agent session logs"
  homepage "https://github.com/catoncat/sherlog"
  version "0.5.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.2/sherlog-v0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "418f53a9864d9c5421de9ba191518c174b1dd983a3c10648febecfcc97716eab"
    elsif Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.2/sherlog-v0.5.2-x86_64-apple-darwin.tar.gz"
      sha256 "9b4a279a6a640756a24e61d0654b56cc86be83a5c45590731b2493221826ea5a"
    else
      odie "Sherlog does not publish a native archive for this macOS architecture"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/catoncat/sherlog/releases/download/v0.5.2/sherlog-v0.5.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "520390934d7f1fd5b3082dc129cb012d55e26679c9fdbf1ae7e7a274f0a1403a"
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
