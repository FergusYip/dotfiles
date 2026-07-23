-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "onedark",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.ui = {
	statusline = {
		modules = {
			file = function()
				local utils = require "nvchad.stl.utils"
				local path = vim.api.nvim_buf_get_name(utils.stbufnr())
				local name = path == "" and "Empty" or vim.fn.fnamemodify(path, ":.")
				local icon = utils.file()[1]
				local style = require("nvconfig").ui.statusline.separator_style
				local separators = type(style) == "table" and style or utils.separators[style]

				-- A literal percent sign otherwise has special meaning in a statusline.
				name = name:gsub("%%", "%%%%")

				return "%#St_file# " .. icon .. " " .. name .. " %#St_file_sep#" .. separators.right
			end,
		},
	},
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
