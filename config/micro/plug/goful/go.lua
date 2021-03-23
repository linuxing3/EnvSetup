VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local buffer = import("micro/buffer")

-- outside init because we want these options to take effect before
-- buffers are initialized
config.RegisterCommonOption("go", "goful", false)

function init()
    config.MakeCommand("goful", goful, config.NoComplete)
    config.AddRuntimeFile("go", config.RTHelp, "help/go-plugin.md")
    config.TryBindKey("F4", "command-edit:goful", false)
end

function goful(bp)
    bp:Save()
    local _, err = shell.RunCommand("goful " .. bp.Buf.Path)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end
    bp.Buf:ReOpen()
    bp.Buf:Refresh()
end
