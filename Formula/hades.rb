# frozen_string_literal: true

class Hades < Formula
  desc "Autonomous agentic development orchestrator"
  homepage "https://github.com/cbip-solutions/hades-system"
  url "https://github.com/cbip-solutions/hades-system/archive/refs/tags/v1.0.1.tar.gz"
  version "1.0.1"
  sha256 "f5b108a4627e3575c3964c60d9334a725e9bfc287a9b2b756c942058be5d7b0a"
  license "MIT"
  head "https://github.com/cbip-solutions/hades-system.git", branch: "main"

  depends_on "go" => :build
  depends_on "hermes-agent" => :required
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
    (etc/"hades-system").mkpath
  end

  service do
    run [opt_bin/"hades-ctld", "-http", "127.0.0.1:8080"]
    keep_alive true
    log_path var/"log/hades-ctld.log"
    error_log_path var/"log/hades-ctld.error.log"
  end

  def caveats
    <<~EOS
      HADES requires Hermes Agent (MIT) as its substrate. Hermes Agent is
      installed automatically as a required dependency.

      Link the Hermes plugin after install:
        mkdir -p ~/.hermes/plugins
        ln -sfn #{opt_pkgshare}/hades ~/.hermes/plugins/hades

      Verify local readiness:
        hades doctor hermes
        hades status

      HADES uses Caronte, its in-tree code-graph engine. No external
      code-graph service is required.

      Configure providers with:
        hades providers add anthropic --key $ANTHROPIC_API_KEY
        hades providers add gemini --key $GEMINI_API_KEY
        hades providers add openrouter --key $OPENROUTER_API_KEY

      License: MIT. Commercial use is permitted by the project license.
    EOS
  end

  test do
    system "#{bin}/hades", "--version"
    system "#{bin}/hades-ctld", "--version"
    system "#{bin}/hades-mcp-research", "--help"
  end
end
