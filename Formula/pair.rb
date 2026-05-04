class Pair < Formula
  desc "Neovim-backed input field for any TUI coding agent (Claude Code, Codex, Gemini)"
  homepage "https://github.com/xianxu/pair"
  url "https://github.com/xianxu/pair/archive/refs/tags/v1.7.tar.gz"
  sha256 "d5d19a4eb8de55b1af293f070622ed0c4975cab0dfbf9384691b93bb4a66def9"
  license "Apache-2.0"
  version "1.7"

  depends_on "zellij"
  depends_on "neovim"
  depends_on "fzf"
  depends_on "jq"
  depends_on "par"
  # bin/pair-wrap is a Python PTY proxy (stdlib-only — no pip install).
  # `python@3` is Homebrew's alias for the current default python@3.X keg,
  # which auto-follows Homebrew's bumps. Any 3.x works at runtime — the
  # script's `#!/usr/bin/env python3` shebang picks up whatever's on PATH.
  depends_on "python@3"

  def install
    # Install the repo's bin/, nvim/, zellij/ trees verbatim under libexec.
    # bin/pair derives PAIR_HOME from its own real path: dirname(SOURCE)/..
    # which lands on libexec/, with bin/ nvim/ zellij/ as siblings — exactly
    # the layout the launcher expects.
    libexec.install "bin"
    libexec.install "nvim"
    libexec.install "zellij"

    # Surface the launcher on PATH via a symlink (auto-resolved by the
    # launcher's symlink-following SOURCE loop).
    bin.install_symlink libexec/"bin/pair"
  end

  def caveats
    <<~EOS
      pair drives a TUI agent that you install separately. Common ones:
        brew install --cask claude-code   # not in homebrew-core; or:
        npm install -g @openai/codex
        # gemini-cli per Google instructions

      Drafts and prompt history live under ${XDG_DATA_HOME:-~/.local/share}/pair/.
      Internal caches (quit marker, clipboard debug log) live under ~/.cache/pair/.

      Run `pair --help` for keybindings.
    EOS
  end

  test do
    assert_match "pair", shell_output("#{bin}/pair --help")
  end
end
