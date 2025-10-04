local status, bufferline = pcall(require, "bufferline")
if not status then
  return
end

bufferline.setup({
  -- ========== 基础选项 ==========
  options = {
    -- 模式设置
    mode = "buffers", -- 可选: "buffers" | "tabs"
    
    -- 样式设置
    style_preset = {
      bufferline.style_preset.no_italic,    -- 禁用斜体
      bufferline.style_preset.no_bold,       -- 禁用粗体
    },
    
    -- 数字显示
    numbers = "ordinal", -- 可选: "none" | "ordinal" | "buffer_id"
    
    -- 关闭按钮
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    
    -- 指示器
    indicator = {
      style = "icon", -- "icon" | "underline" | "none"
      icon = "▎",
    },
    
    -- 缓冲区选择
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    
    -- 名称格式化
    name_formatter = function(buf)
      -- 特殊缓冲区名称处理
      if buf.name:match("%.md") then
        return vim.fn.fnamemodify(buf.name, ":t")
      end
    end,
    
    -- 最大名称长度
    max_name_length = 18,
    max_prefix_length = 15,
    truncate_names = true,
    
    -- 标签页设置
    tab_size = 18,
    diagnostics = "nvim_lsp", -- "false" | "nvim_lsp" | "coc"
    
    -- 诊断图标
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    
    -- 自定义区域
    custom_areas = {
      right = function()
        local result = {}
        local seve = vim.diagnostic.severity
        local error = #vim.diagnostic.get(0, { severity = seve.ERROR })
        local warning = #vim.diagnostic.get(0, { severity = seve.WARN })
        local info = #vim.diagnostic.get(0, { severity = seve.INFO })
        local hint = #vim.diagnostic.get(0, { severity = seve.HINT })
        
        if error ~= 0 then
          table.insert(result, { text = "  " .. error, guifg = "#db4b4b" })
        end
        
        if warning ~= 0 then
          table.insert(result, { text = "  " .. warning, guifg = "#e0af68" })
        end
        
        if hint ~= 0 then
          table.insert(result, { text = "  " .. hint, guifg = "#1abc9c" })
        end
        
        if info ~= 0 then
          table.insert(result, { text = "  " .. info, guifg = "#0db9d7" })
        end
        
        return result
      end,
    },
    
    -- 显示设置
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    show_duplicate_prefix = true,
    persist_buffer_sort = true,
    
    -- 分隔符
    separator_style = "thin", -- "slant" | "slope" | "thick" | "thin" | { "any", "any" }
    
    -- 排序
    sort_by = 'insert_after_current', -- 'insert_after_current' | 'id' | 'extension' | 'relative_directory' | 'directory'
    
    -- 高亮
    highlights = {
      -- 你可以在这里自定义高亮组
      -- 参考: https://github.com/akinsho/bufferline.nvim#highlights
    },
    
    -- 偏移量
    offsets = {
      {
        filetype = "NvimTree",
        text = "文件管理器",
        highlight = "Directory",
        text_align = "center",
        separator = true,
      },
      {
        filetype = "neo-tree",
        text = "文件管理器", 
        highlight = "Directory",
        text_align = "center",
      },
      {
        filetype = "dbui",
        text = "数据库管理器",
        highlight = "Directory",
        text_align = "center",
      },
    },
  },
  
  -- ========== 标签页样式 ==========
  -- 你可以在这里进一步自定义每个缓冲区的外观
})

-- ========== 快捷键配置 ==========
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ========== 自动命令 ==========
local bufferline_group = vim.api.nvim_create_augroup("BufferlineConfig", { clear = true })

-- 自动关闭缓冲区时调整布局
vim.api.nvim_create_autocmd("BufDelete", {
  group = bufferline_group,
  callback = function()
    vim.schedule(function()
      -- 确保 bufferline 更新
      pcall(vim.cmd, "BufferLineRefresh")
    end)
  end,
})

-- 新文件打开时自动聚焦
vim.api.nvim_create_autocmd("BufEnter", {
  group = bufferline_group,
  callback = function()
    -- 确保不是特殊缓冲区
    if vim.bo.buftype == "" then
      vim.schedule(function()
        pcall(vim.cmd, "BufferLineRefresh")
      end)
    end
  end,
})

-- ========== 自定义函数 ==========

-- 智能关闭缓冲区
local function smart_close_buffer()
  local buflisted = vim.fn.getbufinfo({ buflisted = 1 })
  
  if #buflisted <= 1 then
    -- 如果只有一个缓冲区，创建新缓冲区再关闭当前
    vim.cmd("enew")
    vim.cmd("bdelete #")
  else
    -- 正常关闭当前缓冲区
    vim.cmd("Bdelete")
  end
end

-- 映射智能关闭
keymap("n", "<leader>bd", smart_close_buffer, { desc = "Smart delete buffer", unpack(opts) })

-- 仅保留当前缓冲区
local function close_other_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and buf ~= current_buf then
      vim.cmd("bdelete " .. buf)
    end
  end
end

keymap("n", "<leader>bo", close_other_buffers, { desc = "Close other buffers", unpack(opts) })

-- ========== 状态指示器 ==========

-- 在状态栏显示缓冲区信息（可选）
local function bufferline_status()
  local current = vim.fn.bufnr("%")
  local total = #vim.fn.getbufinfo({ buflisted = 1 })
  
  return string.format("📁 %d/%d", current, total)
end

-- 可以将其添加到你的状态栏配置中
-- 例如在 lualine 中:
-- sections = { lualine_c = { { bufferline_status } } }
