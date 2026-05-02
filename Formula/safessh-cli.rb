class SafesshCli < Formula
  desc "Safe SSH executor with policy-driven approvals and audit logging"
  homepage "https://github.com/sanif/safessh"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.4.3/safessh-cli-aarch64-apple-darwin.tar.xz"
      sha256 "852912d919410c9b824a62963365891ecbb0196ed878adb89fde7c9a65e5812b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.4.3/safessh-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ff6c416c7c11ec933fb319e9dba16b585a2c0a527e424441d4d9633a3620af03"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.4.3/safessh-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f308eaf1398ae34381765a31afe2880e94781250f4429bdbc04a8322d6a60fbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.4.3/safessh-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d6f0ed92f14b0abbe768b36d65cd65a6ad423c1af24606e313a0d5965281063"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "safessh" if OS.mac? && Hardware::CPU.arm?
    bin.install "safessh" if OS.mac? && Hardware::CPU.intel?
    bin.install "safessh" if OS.linux? && Hardware::CPU.arm?
    bin.install "safessh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
