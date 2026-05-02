class SafesshCli < Formula
  desc "Safe SSH executor with policy-driven approvals and audit logging"
  homepage "https://github.com/sanif/safessh"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.3.0/safessh-cli-aarch64-apple-darwin.tar.xz"
      sha256 "320cf36488bb089be6e170cca64ece2cf46fe9ccd4237031989d80e982c2bc1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.3.0/safessh-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e4ecbea4dbab06dd37a0c870119613765c473c8552096b90516c258927bfd3cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.3.0/safessh-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c180b8f2088a526eb16f41b17783b93b81e1b2b761dd2c52ab34e1e0ce262eb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.3.0/safessh-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "182d6fe59ae3df34f2a4ca0d554d1770906840002db6b41d799e412e6e7e4b14"
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
