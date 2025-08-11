local M = {}

M.gf = require("config.laravel.gf").goto_file_under_cursor

M.find_related = require("config.laravel.related").find_related

M.run_ide_helper = require("config.laravel.ide_helper").generate_ide_helpers

return M
