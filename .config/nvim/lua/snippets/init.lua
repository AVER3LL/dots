local ls_installed, _ = pcall(require, "luasnip")

if not ls_installed then
    return
end

require "snippets.python"
