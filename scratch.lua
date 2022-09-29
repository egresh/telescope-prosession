local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local dump = require("oleo").dump

local function get_prosession_list()
    local prosession_list_as_string = vim.api.nvim_exec("echo prosession#ListSessions()", true)

    local t = {}
    for dir in string.gmatch(prosession_list_as_string, "'(.-)'") do
        table.insert(t, dir)
    end

    return t
end

local colors = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "colors",
        finder = finders.new_table({
            results = get_prosession_list(),
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = function() return entry end,
                    ordinal = entry
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_exec(('Prosession ' .. selection.value), false)
            end)
            return true
        end,
    }):find()
end

colors(require("telescope.themes").get_dropdown({}))
