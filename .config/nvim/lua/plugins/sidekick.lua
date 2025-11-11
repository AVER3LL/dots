return {
    "folke/sidekick.nvim",
    opts = {
        -- add any options here
        nes = {
            enabled = false,
        },
        cli = {
            mux = {
                backend = "zellij",
                enabled = false,
            },
            win = {
                ---@type vim.api.keyset.win_config
                split = {
                    width = 50,
                    height = 20,
                },
            },
        },
    },
  -- stylua: ignore
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle({ filter = {installed = true} }) end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select({filter = {installed = true}}) end,
      desc = "Select CLI",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- {
    --   "<c-.>",
    --   function() require("sidekick.cli").focus() end,
    --   mode = { "n", "x", "i", "t" },
    --   desc = "Sidekick Switch Focus",
    -- },
    -- Example of a keybinding to open Gemini directly
    {
      "<leader>ag",
      function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end,
      desc = "Sidekick Toggle Gemini",
    },
    {
      "<leader>ao",
      function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
      desc = "Sidekick Toggle Opencode",
    },
  },
}
