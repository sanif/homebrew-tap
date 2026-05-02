class SafesshCli < Formula
  desc "Safe SSH executor with policy-driven approvals and audit logging"
  homepage "https://github.com/sanif/safessh"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.2.0/safessh-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7b7e450bb2c36ae395dcf6b00d526b3e32eacf6aee464e0e8074d5c1d72be0ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.2.0/safessh-cli-x86_64-apple-darwin.tar.xz"
      sha256 "cacbb23d4f357accb32e074c49cfcd4fe454027f168143b9e84c0b96802d1a10"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.2.0/safessh-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d56db07bac72607f8a9ab76a1c1afa58ae6500a48e668f5f07c1b72a57aa56dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.2.0/safessh-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51f4c263a2d691ac6f7d407e8e0e0ed47281d5c4c35bf0e42174fc8999d289fe"
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
