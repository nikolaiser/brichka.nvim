# brichka.nvim

Neovim plugin for [brichka](https://github.com/nikolaiser/brichka) - run code on Databricks clusters directly from your editor.

## Prerequisites

* [brichka CLI](https://github.com/nikolaiser/brichka) installed
* [visidata](https://www.visidata.org/) installed (default table rendering)
* (Optional) Authenticated [databricks-cli](https://github.com/databricks/cli)

## Installation

### Lazy.nvim

```lua
{
    "nikolaiser/brichka.nvim",
    dependencies = {
        "folke/snacks.nvim", -- Used for the default renderers
    },
    opts = {},
    keys = {
        {
            "<leader>bs",
            function()
                require("brichka.cluster").select()
            end,
            desc = "Brichka select cluster",
        },
        {
            "<leader>br",
            function()
                require("brichka.run").run(vim.api.nvim_buf_get_lines(0, 0, -1, false), vim.bo.filetype)
            end,
            desc = "Brichka run current buffer",
        },
    },
}
```

## Usage

1. **Select a cluster for the current working directory**: `<leader>bs` - Opens a list of available Databricks clusters
2. **Run code**: `<leader>br` - Executes the current buffer on the selected cluster

The plugin automatically detects the file type and runs it with the appropriate language (SQL, Scala, Python, R).

## Configuration

Default configuration:

```lua
{
    cmd = {
        brichka = "brichka", -- Path to brichka executable
    },
    ui = {
        icons = {
            cluster = {
                running = "🟢",
                pending = "🔵",
                restarting = "♻️",
                resizing = "⚙️",
                terminating = "🔻",
                terminated = "🔴",
                error = "⚠️",
                unknown = "❔",
            },
        },
        render = {
            table = function(path)
                Snacks.terminal("vd --wrap " .. path, { win = { position = "bottom" } })
            end,
            text = function(value)
                Snacks.win({ text = value, width = 0.6, height = 0.6 })
            end,
            error = function(message, cause)
                Snacks.win({ text = message, width = 0.6, height = 0.6 })
            end,
        },
    },
    run = {
        start = false,  -- Auto-start cluster if stopped
        init = false,   -- Auto create shared execution context (notebook mode)
        spinner = true, -- Show spinner while executing
    },
}
```

Override any options in your `opts` table.
