# frozen_string_literal: true

class Hades < Formula
  desc "Local-first agentic development orchestrator"
  homepage "https://github.com/cbip-solutions/hades-system"
  url "https://github.com/cbip-solutions/hades-system/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "97dee8fa2896aee2be680bc4fa2499ea009be9223f13375bb7f29c37e5a81953"
  license "MIT"
  head "https://github.com/cbip-solutions/hades-system.git", branch: "main"

  depends_on "go" => :build
  depends_on "hermes-agent"
  depends_on "tmux" => :recommended

  def install
    system "make", "build"

    bin.install "bin/hades"
    bin.install "bin/zen"
    bin.install "bin/zen-swarm-ctld"
    bin.install "bin/zen-mcp-audit"
    bin.install "bin/zen-mcp-budget"
    bin.install "bin/zen-mcp-research"
    bin.install "bin/zen-mcp-sshexec"

    pkgshare.install "plugin/hades"
    pkgshare.install "configs"
  end

  service do
    run [opt_bin/"zen-swarm-ctld"]
    keep_alive true
    log_path var/"log/zen-swarm-ctld.log"
    error_log_path var/"log/zen-swarm-ctld.error.log"
  end

  test do
    system bin/"hades", "--version"
    system bin/"zen", "--version"
    system bin/"zen-swarm-ctld", "--version"
  end
end
