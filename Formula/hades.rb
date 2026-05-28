# frozen_string_literal: true

class Hades < Formula
  desc "Local-first agentic development orchestrator"
  homepage "https://github.com/cbip-solutions/hades-system"
  url "https://github.com/cbip-solutions/hades-system/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0b913265ac17c9c31aaa4c2155b71110f7f935042f615ad6e553728894aed7c8"
  license "MIT"
  head "https://github.com/cbip-solutions/hades-system.git", branch: "main"

  depends_on "go" => :build
  depends_on "hermes-agent"
  depends_on "tmux" => :recommended

  def install
    system "make", "build"

    bin.install "bin/hades"
    bin.install "bin/hades-ctld"
    bin.install "bin/hades-mcp-audit"
    bin.install "bin/hades-mcp-budget"
    bin.install "bin/hades-mcp-research"
    bin.install "bin/hades-mcp-sshexec"
    bin.install "bin/hades-knowledge-watcher"
    bin.install "bin/hades-docs-cron"

    pkgshare.install "plugin/hades"
    pkgshare.install "configs"
  end

  service do
    run [opt_bin/"hades-ctld"]
    keep_alive true
    log_path var/"log/hades-ctld.log"
    error_log_path var/"log/hades-ctld.error.log"
  end

  test do
    system bin/"hades", "--version"
    system bin/"hades-ctld", "--version"
  end
end
