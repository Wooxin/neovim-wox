vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require('nvim-tree').setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})
-- ========== 智能自动打开配置 ==========
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    -- 延迟执行，确保其他插件加载完成
    vim.defer_fn(function()
      local real_file = data.file ~= "" and vim.fn.filereadable(data.file) == 1
      local directory = vim.fn.isdirectory(data.file) == 1
      
      -- 如果没有指定文件或者是目录，打开树
      if not real_file and not directory then
        require("nvim-tree.api").tree.open()
      else
        -- 如果打开文件，也打开树但不获取焦点
        require("nvim-tree.api").tree.open({ focus = false })
      end
    end, 10)
  end,
})

-- ========== 智能退出解决方案 ==========
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_windows = {}
    local windows = vim.api.nvim_list_wins()
    
    -- 查找所有 nvim-tree 窗口
    for _, win in ipairs(windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_ft = vim.api.nvim_buf_get_option(buf, "filetype")
      if buf_ft == "NvimTree" then
        table.insert(tree_windows, win)
      end
    end
    
    -- 如果只剩下 nvim-tree 窗口，自动关闭它们
    if #windows == #tree_windows and #windows > 0 then
      for _, win in ipairs(tree_windows) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})
-- ========== 自动命令组 ==========
local nvim_tree_group = vim.api.nvim_create_augroup("NvimTreeConfig", { clear = true })

-- 自动调整树大小（可选）
vim.api.nvim_create_autocmd("VimResized", {
  group = nvim_tree_group,
  callback = function()
    if require("nvim-tree.view").get_winnr() ~= nil then
      require("nvim-tree.view").resize()
    end
  end,
})

-- 启动时恢复树状态
vim.api.nvim_create_autocmd("BufEnter", {
  group = nvim_tree_group,
  callback = function()
    if vim.fn.winnr("$") == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd("quit")
    end
  end,
})
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function(data)
    vim.defer_fn(function()
      -- 总是打开树但不获取焦点
      require("nvim-tree.api").tree.open({ focus = false })
      
      -- 强制焦点到文件窗口
      local file_windows = {}
      local windows = vim.api.nvim_list_wins()
      
      for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_ft = vim.api.nvim_buf_get_option(buf, "filetype")
        if buf_ft ~= "NvimTree" then
          table.insert(file_windows, win)
        end
      end
      
      -- 如果有文件窗口，聚焦第一个
      if #file_windows > 0 then
        vim.api.nvim_set_current_win(file_windows[1])
      end
    end, 20)
  end,
})
vim.keymap.set('n', '<C-Space>', function()
    local nvim_tree = false
    
    -- 检查当前窗口是否是 NvimTree
    if vim.bo.filetype == "NvimTree" then
        nvim_tree = true
    else
        -- 检查是否有 NvimTree 窗口存在
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
            if ft == "NvimTree" then
                nvim_tree = true
                break
            end
        end
    end
    
    if nvim_tree then
        -- 如果当前在 NvimTree 或者 NvimTree 存在，就切换到上一个窗口
        vim.cmd('wincmd p')
    else
        -- 如果 NvimTree 不存在，就打开并聚焦
        vim.cmd('NvimTreeFocus')
    end
end, opts)
