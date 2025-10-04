-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}
local keymap = vim.keymap.set

-- 复制/剪切/粘贴 (VSCode 习惯)
keymap({ "n", "v" }, "c", '"_c', { desc = "Delete without yanking" })
keymap({ "n", "v" }, "x", '"_x', { desc = "Delete char without yanking" })
-- 更常见的做法是直接使用系统剪贴板
keymap({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
keymap({ "n", "v" }, "<C-x>", '"+d', { desc = "Cut to system clipboard" })
keymap("n", "<C-v>", '"+p', { desc = "Paste from system clipboard" })
keymap("i", "<C-v>", '<C-o>"+p', { desc = "Paste in insert mode" })

-- 移动行 (Alt+Up/Down)
keymap("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
keymap("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
keymap("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
keymap("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })

-- 增加/减少缩进 (Tab / Shift+Tab)
keymap("v", "<", "<gv", { desc = "Deindent line" })
keymap("v", ">", ">gv", { desc = "Indent line" })

-- 保存 (Ctrl+S) - 已存在，确保工作正常
keymap({ "n", "i", "v" }, "<C-s>", ":w<CR>", { desc = "Save file", silent = true })

-- 关闭标签页/缓冲区 (Ctrl+W)
-- 关闭当前标签页 (Ctrl+W) - 使用基础命令
keymap("n", "<C-w>", ":bdelete<CR>", { desc = "Close buffer", silent = true })

-- 搜索 (Ctrl+F)
keymap({ "n", "v" }, "<C-f>", "/", { desc = "Search in file" })
-- 如果你想要更强大的搜索（推荐），使用 Telescope：
-- keymap("n", "<C-f>", function()
--     require("telescope.builtin").current_buffer_fuzzy_find()
-- end, { desc = "Search in current buffer" })

-- 注释 (Ctrl+/) - 需要 Comment.nvim 插件
keymap({ "n", "v" }, "<C-/>", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

-- 在 Visual 模式下的注释
keymap("v", "<C-/>", function()
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment for selection" })

-- 格式化 (Ctrl+Shift+L) - 需要格式化插件
keymap({ "n", "v" }, "<C-S-l>", function()
    -- 使用 conform.nvim
    require("conform").format()
    -- 或者使用 null-ls.nvim
    -- vim.lsp.buf.format()
end, { desc = "Format code" })

-- 新建文件 (Ctrl+N)
keymap("n", "<C-n>", ":enew<CR>", { desc = "New buffer" })

-- 打开文件 (Ctrl+O)
keymap("n", "<C-o>", ":e ", { desc = "Open file" })

-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
keymap('n', '<C-Up>', ':resize -2<CR>', opts)
keymap('n', '<C-Down>', ':resize +2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- plugin keymaps (修复了 opt -> opts)
keymap('n', '<A-m>', ':NvimTreeToggle<CR>', opts)
keymap('n', '<C-Space>', '<Cmd>NvimTreeFocus<CR>', opts)
keymap("n", "<C-h>", ":BufferLineCyclePrev<CR>", opts)
keymap("n", "<C-l>", ":BufferLineCycleNext<CR>", opts)
