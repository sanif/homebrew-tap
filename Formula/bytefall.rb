class Bytefall < Formula
  desc "Real-time network traffic visualization with Matrix-style aesthetics"
  homepage "https://github.com/sanif/bytefall"
  url "https://github.com/sanif/bytefall/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "eea069935a914233b2181be2095db323db86e2c9a13136e64ec5e0119b779719"
  license "MIT"
  head "https://github.com/sanif/bytefall.git", branch: "main"

  depends_on "go" => :build
  depends_on "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/bytefall"

    # Generate and install shell completions
    generate_completions_from_executable(bin/"bytefall", "-completion")
  end

  def caveats
    <<~EOS
      bytefall requires root privileges for packet capture.
      Run with: sudo bytefall

      Or use demo mode without privileges:
        bytefall -demo
    EOS
  end

  test do
    assert_match "bytefall version #{version}", shell_output("#{bin}/bytefall -version")
    assert_match "Available interfaces", shell_output("#{bin}/bytefall -list 2>&1")
  end
end
