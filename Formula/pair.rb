class Pair < Formula
  include Language::Python::Virtualenv

  desc "Neovim-backed input field for any TUI coding agent (Claude Code, Codex, Gemini)"
  homepage "https://github.com/xianxu/pair"
  url "https://github.com/xianxu/pair/archive/refs/tags/v1.15.tar.gz"
  sha256 "d57b64b16a775d782cc9120554e0f2bfd39b7f2d5189f207e57f30708f2924ae"
  license "Apache-2.0"
  version "1.15"

  depends_on "zellij"
  depends_on "neovim"
  depends_on "fzf"
  depends_on "jq"
  depends_on "par"
  # python@3 hosts both pair-wrap (PTY proxy, stdlib-only) and the
  # private venv built below for pair-scrollback-render's pyte dep.
  # `python@3` is Homebrew's alias for the current default python@3.X
  # keg and auto-follows bumps.
  depends_on "python@3"

  # pair-scrollback-render (Alt+/ viewer) depends on pyte. Vendoring
  # via Homebrew's resource pattern keeps `brew install pair` turnkey
  # without forcing users to fight PEP 668 with `pip3 install --user
  # --break-system-packages pyte`. wcwidth is pyte's own runtime dep.
  resource "pyte" do
    url "https://files.pythonhosted.org/packages/ab/ab/b599762933eba04de7dc5b31ae083112a6c9a9db15b01d3109ad797559d9/pyte-0.8.2.tar.gz"
    sha256 "5af970e843fa96a97149d64e170c984721f20e52227a2f57f0a54207f08f083f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    # Install the repo's bin/, nvim/, zellij/ trees verbatim under libexec.
    # bin/pair derives PAIR_HOME from its own real path: dirname(SOURCE)/..
    # which lands on libexec/, with bin/ nvim/ zellij/ as siblings — exactly
    # the layout the launcher expects.
    libexec.install "bin"
    libexec.install "nvim"
    libexec.install "zellij"

    # Build a private venv at libexec/venv/ for pyte (and any future
    # Python deps). pair-scrollback-open detects this venv via
    # $PAIR_HOME/venv/bin/python3 and prefers it over the system
    # python3. Falls back to system python3 + user-installed pyte for
    # the git-clone path.
    venv = virtualenv_create(libexec/"venv", "python3")
    venv.pip_install resources

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
