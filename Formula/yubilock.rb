class Yubilock < Formula
  desc "Automatically lock macOS when a YubiKey is detached"
  homepage "https://github.com/felix-kaestne/yubilock"

  url "https://github.com/felix-kaestner/yubilock.git", # url "ssh://git@github.com/felix-kaestner/yubilock.git"
      tag:      "v0.0.2",
      revision: "5a082bca3d88d69c8e1a323b5a23a6c08f1ddef0"

  license "MIT"

  depends_on :xcode => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"yubilock"]
    run_at_load true
    keep_alive true
    log_path var/"log/yubilock.log"
    error_log_path var/"log/yubilock.log"
  end

  test do
    assert_predicate bin/"yubilock", :exist?
    assert_predicate bin/"yubilock", :executable?
    assert_match "Usage: yubilock", shell_output("#{bin}/yubilock --help", 2)
  end
end
