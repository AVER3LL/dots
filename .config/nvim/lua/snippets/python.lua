local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
    s("ifmain", {
        t "def main() -> None:",
        t { "", "\t" },
        i(1, "pass"),
        t { "", "" },
        t { "", "", 'if __name__ == "__main__":' },
        t { "", "\tmain()" },
    }),
})
