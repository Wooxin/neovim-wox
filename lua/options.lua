-- Hint: use `:h ` to figure out the meaning if needed

-- 剪贴板设置
vim.opt.clipboard = 'unnamedplus' -- 使用系统剪贴板，允许与外部应用共享复制粘贴内容

-- Wayland 剪贴板配置
vim.g.clipboard = {
    name = 'wayland',
    copy = {
        ['+'] = 'wl-copy --foreground --type text/plain',
        ['*'] = 'wl-copy --foreground --primary --type text/plain',
    },
    paste = {
        ['+'] = 'wl-paste --no-newline',
        ['*'] = 'wl-paste --no-newline --primary',
    },
    cache_enabled = 1,
}

-- 自动完成设置
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' } 

-- 鼠标支持
vim.opt.mouse = 'a' -- 允许在 Neovim 中使用鼠标（所有模式）

-- Tab 相关设置
vim.opt.tabstop = 4 -- 每个 TAB 在屏幕上显示为 4 个空格宽度
vim.opt.softtabstop = 4 -- 编辑时按 TAB 键插入 4 个空格
vim.opt.shiftwidth = 4 -- 自动缩进时使用 4 个空格
vim.opt.expandtab = true -- 将 TAB 转换为空格，主要用于 Python 开发

-- 用户界面配置
vim.opt.number = true -- 显示绝对行号
-- vim.opt.relativenumber = true -- 显示相对行号（相对于光标位置）
vim.opt.cursorline = true -- 高亮光标所在的行（水平方向）
vim.opt.splitbelow = true -- 新的垂直分割窗口在下方打开
vim.opt.splitright = true -- 新的水平分割窗口在右侧打开
vim.opt.termguicolors = true -- 在终端中启用 24 位真彩色（当前被注释）
vim.opt.showmode = false -- 不显示模式提示（如 -- INSERT --），适合有经验的用户

-- 搜索设置
vim.opt.incsearch = true -- 输入搜索模式时实时高亮匹配项
vim.opt.hlsearch = false -- 搜索完成后不高亮所有匹配项
vim.opt.ignorecase = true -- 搜索时默认忽略大小写
vim.opt.smartcase = true -- 如果搜索模式包含大写字母，则启用大小写敏感搜索
