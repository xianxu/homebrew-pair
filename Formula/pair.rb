class Pair < Formula
  desc "Neovim-backed input field for any TUI coding agent (Claude Code, Codex, Gemini)"
  homepage "https://github.com/xianxu/pair"
  url "https://github.com/xianxu/pair/archive/refs/tags/v1.1.tar.gz"
  sha256 "23dddc2c222049f410de183e1b09adba906aa512b68aac0c6fa97b9ccc0a8b2e"
  license "Apache-2.0"
  version "1.1"

  depends_on "zellij"
  depends_on "neovim"
  depends_on "fzf"
  depends_on "jq"
  depends_on "par"

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
