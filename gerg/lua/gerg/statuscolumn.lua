local M = {}

function M.statuscolumn()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local is_file = vim.bo[buf].buftype == ""

  -- Only show line numbers for normal buffers
  if not is_file then
    return ""
  end

  local lnum = vim.v.lnum
  local rnum = vim.v.relnum
  local space = "  "

  return string.format(" %3d%s%s", lnum, space, rnum == 0 and lnum or rnum)
end

return M
