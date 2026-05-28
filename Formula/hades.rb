# frozen_string_literal: true

class Hades < Formula
  desc "Autonomous agentic development orchestrator"
  homepage "https://github.com/cbip-solutions/hades-system"
  url "https://github.com/cbip-solutions/hades-system/archive/refs/tags/v1.0.3.tar.gz"
  version "1.0.3"
  sha256 "7c5bb7dfedc0bf9cfb80011fd239391a126770af239696a008cad62e9ae1f549"
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

      Verify Hermes Agent first:
        hermes --version

      Link the Hermes plugin after install:
        mkdir -p ~/.hermes/plugins
        ln -sfn #{opt_pkgshare}/hades ~/.hermes/plugins/hades

      Restart Hermes or refresh its plugin registry if it was already running.

      Verify local readiness:
        hades doctor hermes
        hades status

      HADES uses Caronte, its in-tree code-graph engine. No external
      code-graph service is required.

      Configure provider rosters with:
        hades providers init
        hades providers add openrouter --type openai-compat --endpoint https://openrouter.ai/api --model deepseek/deepseek-chat --family deepseek --keychain hades/openrouter

      Set provider credentials with environment variables on Linux/source
      installs before starting the daemon:
        export HADES_KEYCHAIN_OPENROUTER="$OPENROUTER_API_KEY"
        export HADES_KEYCHAIN_GOOGLE_AI="$GEMINI_API_KEY"

      On macOS, environment variables work too; alternatively run:
        hades providers rotate openrouter

      License: MIT. Commercial use is permitted by the project license.
    EOS
  end

  test do
    system "#{bin}/hades", "--version"
    system "#{bin}/hades-ctld", "--version"
    system "#{bin}/hades-mcp-research", "--help"
  end
end
