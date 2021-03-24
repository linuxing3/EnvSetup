VERSION = "2.0.2"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local buffer = import("micro/buffer")

-- outside init because we want these options to take effect before
-- buffers are initialized
config.RegisterCommonOption("sh", "shfmt", true)

function init()
    config.MakeCommand("shfmt", shfmt, config.NoComplete)
    config.AddRuntimeFile("sh", config.RTHelp, "help/sh-plugin.md")
end

function onSave(bp)
    if bp.Buf:FileType() == "sh" then
       shfmt(bp)
    end
    if bp.Buf:FileType() == "bash" then
       shfmt(bp)
    end
    return true
end

function shfmt(bp)
    bp:Save()
    local _, err = shell.RunCommand("shfmt -l -w " .. bp.Buf.Path)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end

    bp.Buf:ReOpen()
end
