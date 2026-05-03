# homebrew-pair

A Homebrew tap for [pair](https://github.com/xianxu/pair) — a Neovim-backed input field for any TUI coding agent (Claude Code, Codex, Gemini CLI).

## Install

```sh
brew tap xianxu/pair
brew install pair
```

That pulls in pair's runtime deps automatically (`zellij`, `neovim`, `fzf`, `jq`, `par`). The agent itself (`claude`, `codex`, `gemini`) you install separately.

## Update

```sh
brew update
brew upgrade pair
```

## What this tap is

A single formula at `Formula/pair.rb` that points at pair's tagged GitHub releases. Updating to a new pair version: bump `url` to the new tag, recompute `sha256`, push.
