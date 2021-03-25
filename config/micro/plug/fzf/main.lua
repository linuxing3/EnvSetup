VERSION = "1.1.1"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")
local buffer = import("micro/buffer")
local view = import("micro/view")
local tab = import("micro/tab")
local os = import("os")
local filepath = import("path/filepath")

local fzf_pane = nil
local current_dir = os.Getwd()
local fzf_view = nil
local fzf_tab = nil

-- Returns the basename of a path (aka a name without leading path)
local function get_basename(path)
	if path == nil then
		micro.Log("Bad path passed to get_basename")
		return nil
	else
		-- Get Go's path lib for a basename callback
		local golib_path = import("filepath")
		return golib_path.Base(path)
	end
end

-- Returns true/false if the file is a dotfile
local function is_dotfile(file_name)
	-- Check if the filename starts with a dot
	if string.sub(file_name, 1, 1) == "." then
		return true
	else
		return false
	end
end

-- Stat a path to check if it exists, returning true/false
local function path_exists(path)
	local go_os = import("os")
	-- Stat the file/dir path we created
	-- file_stat should be non-nil, and stat_err should be nil on success
	local file_stat, stat_err = go_os.Stat(path)
	-- Check if what we tried to create exists
	if stat_err ~= nil then
		-- true/false if the file/dir exists
		return go_os.IsExist(stat_err)
	elseif file_stat ~= nil then
		-- Assume it exists if no errors
		return true
	end
	return false
end

local function entry(bp)
    local gofulconfig = "~/.goful/config.yaml"
    -- tab2
   	bp:NewTabCmd({})
   	-- tab3
 	-- local go_os = import("os")
 	-- go_os.chdir()
   	local microbindings = "~/.config/micro/bindings.json" 
   	local microsettings = "~/.config/micro/bindings.json" 
   	bp:NewTabCmd({microbindings})
   	micro.CurPane():VSplitIndex(buffer.NewBufferFromFile(microsettings), true)
   	-- tab4
    local doominit = "~/.doom.d/init.el"
    local doomconfig = "~/.doom.d/config.el"
   	bp:NewTabCmd({doominit})
   	micro.CurPane():VSplitIndex(buffer.NewBufferFromFile(doomconfig), true)
    -- fzf(bp)
end

function fzf(bp)
    if shell.TermEmuSupported then
        local err = shell.RunTermEmulator(bp, "fzf", false, true, fzfOutput, {bp})
        if err ~= nil then
            micro.InfoBar():Error(err)
        end
    else
        -- 使用交互shell调用fzf,返回文件路径 
        local output, err = shell.RunInteractiveShell("fzf", false, true)
        if err ~= nil then
            micro.InfoBar():Error(err)
        else
            fzfOutputTab(output, {bp})
        end
    end
end

function fzfOutputSplit(output, args)
    local strings = import("strings")
    output = strings.TrimSpace(output)
    if output ~= "" then
        -- 在左侧分割一个新的窗口 
        micro.CurPane():VSplitIndex(buffer.NewBufferFromFile(output), false)
        fzf_pane = micro.CurPane()
        -- fzf_pane:ResizePane(30)
        fzf_pane.Buf:SetOptionNative("softwrap", true)
        micro.Log("File path: " .. output)
    end
end

function fzfOutputTab(output, args)
    local bp = args[1]
    local strings = import("strings")
    output = strings.TrimSpace(output)
    if output ~= "" then
        -- 无法直接调用NewTabFromView,因为没有导出 
        bp:NewTabCmd({output})
        micro.Log("File path: " .. output)
    end
end

function fzfOutput(output, args)
    local bp = args[1]
    local strings = import("strings")
    output = strings.TrimSpace(output)
    if output ~= "" then
        -- 在当前的缓冲区打来fzf搜索的文件
        local buf, err = buffer.NewBufferFromFile(output)
        if err == nil then
            bp:OpenBuffer(buf)
        end
        micro.Log("File path: " .. output)
    end
end

function init()
    config.MakeCommand("fzf", fzf, config.noComplete)
    config.MakeCommand("entry", entry, config.noComplete)
end
