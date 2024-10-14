# shiki.nvim

Use `:Shiki` to effortlessly get a syntax-highlighted HTML code snippet of a selected text or a provided range.

Powered by [Shiki](https://shiki.style/).

> [!IMPORTANT]
> The HTML snippet requires [an additional CSS code](https://blog.tymek.dev/html-code-snippets-with-syntax-highlighting/#the-css-to-enable-the-dual-theme) to work.

## Demo

[demo.webm](https://github.com/user-attachments/assets/78fdacba-f792-4290-bf06-fac2cb7bcbed)

## Requirements

- `node`

## Setup

### [lazy.nvim](https://github.com/folke/lazy.nvim)

shiki.nvim has a default plugin spec (see [`lazy.lua`](./lazy.lua)). It lazy loads by default!

```lua
---@module "lazy"
---@type LazySpec
{
  "TymekDev/shiki.nvim"
}
```

> [!TIP]
> Annotations above are optional. Use [lazydev.nvim](https://github.com/folke/lazydev.nvim) to get completions based on them.

## Usage

### `Shiki` Command

- `:Shiki` command works either on a selection or on a range
- `:Shiki` has a single optional argument&mdash;a language to highlight
  - For example, run `:Shiki css` inside an HTML file to get CSS properly highlighted
  - If the language argument is not specified, then filetype is passed to Shiki[^1]
- Use `:%Shiki` to generate a snippet from an entire file
- Use `:Shiki` to generate a snippet from the current line
- Use `:Shiki` with an active selection to generate a snippet from the selection

[^1]:
    This won't always work.
    There might be filetypes that don't translate to Shiki's lang argument.
    If you find one, then please [raise an issue](https://github.com/TymekDev/shiki.nvim/issues/new/choose).

### Lua

```lua
-- List supported languages
require("shiki").langs()

-- List supported themes
require("shiki").themes()

-- Rebuild Node a shiki.nvim's internal directory
require("shiki").setup({ install = { rebuild = true } })

-- Execute JS code in the shiki.nvim's internal directory
requie("shiki.node").exec('import { bundledThemes } from "shiki/themes"; console.log(bundledThemes)')
```

## Configuration

```lua
---@type shiki.Config
{
  -- Create Shiki command?
  cmd = true,
  highlight = {
    -- Shiki configuration (passed to `codeToHTML`)
    shiki = {
      defaultColor = false,
      themes = {
        dark = "github-dark",
        light = "github-light",
      },
    },
  },
  install = {
    -- Node package manager to install with
    cmd = "npm",
    -- Addtional arguments to the package manager
    args = { "install", "--save-dev" },
    -- Shiki version
    version = "1.12.0",
    -- Remove and reinitialize a shiki.nvim's internal directory?
    rebuild = false,
  },
}
```

> [!IMPORTANT]
> If you want to change Shiki version, then run `setup()` with `rebuild = true` **once** or run `require("shiki.node").purge()`.

## Motivation

Recently, I have switched to writing blog posts directly in HTML (see [_A New Post Layout_](https://blog.tymek.dev/a-new-post-layout/)).
I wanted to keep code snippets with syntax highlighting, though.
That's how I came up with a script to create syntax-highlighted code snippets using Shiki:

```js
// Usage:
//    node highlight.js FILE [LANG] | pbcopy
import { readFileSync } from "node:fs";
import { codeToHtml } from "shiki";

const fileName = process.argv[2];
const lang = process.argv[3] ?? "text";
const code = readFileSync(fileName, { encoding: "utf-8" }).replace(/\n$/, "");

const result = await codeToHtml(code, {
  lang: lang,
  themes: {
    light: "github-light",
    dark: "github-dark",
  },
  defaultColor: false,
});

console.log(result);
```

You can read more about it in my _[HTML Code Snippets with Syntax Highlighting](https://blog.tymek.dev/html-code-snippets-with-syntax-highlighting/)_ post.

This script is not ideal.
It requires the code to be in a file and it does not detect a language.
I realized that for the most part, the code I want to share lives in my editor.

_Why should it be any more effort than selecting the relevant part and running a single command?_&mdash;I asked myself.

...and that's how shiki.nvim came to be.
