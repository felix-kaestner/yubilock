class Yubilock < Formula
  desc "Automatically lock macOS when a YubiKey is detached"
  homepage "https://github.com/felix-kaestne/yubilock"

  url "https://github.com/felix-kaestner/yubilock.git", # url "ssh://git@github.com/felix-kaestner/yubilock.git"
      tag:      "v0.0.1",
      revision: "da6bbddb6d2085a86d6603be551d593eed9c0b9f"

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
