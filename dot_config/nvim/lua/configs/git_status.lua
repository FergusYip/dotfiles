local M = {}

function M.open()
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local finders = require "telescope.finders"
  local make_entry = require "telescope.make_entry"
  local pickers = require "telescope.pickers"
  local previewers = require "telescope.previewers"
  local conf = require("telescope.config").values

  local show_untracked = false
  local opts = { cwd = vim.fn.getcwd(), split_char = "\0" }

  local function finder()
    return finders.new_oneshot_job({
      "git",
      "status",
      "-z",
      show_untracked and "--untracked-files=all" or "--untracked-files=no",
      "--",
      ".",
    }, opts)
  end

  local picker = pickers.new(vim.tbl_extend("force", opts, {
    prompt_title = "Git status — <C-u> to include untracked",
    finder = finder(),
    entry_maker = make_entry.gen_from_git_status(opts),
    previewer = previewers.git_file_diff.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      local function refresh()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:refresh(finder(), { reset_prompt = false })
      end

      map({ "i", "n" }, "<C-u>", function()
        show_untracked = true
        refresh()
      end)

      actions.git_staging_toggle:enhance { post = refresh }
      map({ "i", "n" }, "<Tab>", actions.git_staging_toggle)

      return true
    end,
  }))

  picker:find()
end

return M
