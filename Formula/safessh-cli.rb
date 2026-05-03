class SafesshCli < Formula
  desc "Safe SSH executor with policy-driven approvals and audit logging"
  homepage "https://github.com/sanif/safessh"
  version "0.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.4.4/safessh-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c257d12c938583304a0ad617cc8957d924074c901392c3cc05607408bfaf0813"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.4.4/safessh-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f47177f5c053b8c4fa1b0253ccfff83a697707c396269dac233b47536a2b3ae0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sanif/safessh/releases/download/v0.4.4/safessh-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6dcc3a0c09f6ac35c50a8563e13d05dab893a98ab781fba4889663f7f03d3b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sanif/safessh/releases/download/v0.4.4/safessh-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa1fa17979b4093ae71e6936fed99c610bc7b14a2304e16ff01f80b96d309722"
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
