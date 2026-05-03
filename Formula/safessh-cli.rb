class SafesshCli < Formula
  desc "Safe SSH executor with policy-driven approvals and audit logging"
  homepage "https://github.com/sanif/safessh"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.5.0/safessh-cli-aarch64-apple-darwin.tar.xz"
      sha256 "44cfd72fc7096acd9dbecb35751a55ae5280246145cf295f302595d06a928dd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.5.0/safessh-cli-x86_64-apple-darwin.tar.xz"
      sha256 "495c0ee81c36b8b261b5b0ad5e8125e586171877b793f5fb2ed2bfdd47bff439"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.5.0/safessh-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9d1177278aa74e21d4a2dbd64583975131b8eb1c5196adbae2280b09f2ae4e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.5.0/safessh-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc74792540c1de228c8efbfb2d0431618099dcef37d77d619a54f60aa50fd9ad"
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
