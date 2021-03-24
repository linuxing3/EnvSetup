VERSION = "2.0.2"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local buffer = import("micro/buffer")

-- outside init because we want these options to take effect before
-- buffers are initialized
config.RegisterCommonOption("rust", "rustfmt", true)

function init()
    config.MakeCommand("rustfmt", rustfmt, config.NoComplete)
    config.AddRuntimeFile("rs", config.RTHelp, "help/rust-plugin.md")
end

function onSave(bp)
    if bp.Buf:FileType() == "rs" then
       rustfmt(bp)
    end
    return true
end

function rustfmt(bp)
    bp:Save()
    local _, err = shell.RunCommand("rustfmt " .. bp.Buf.Path)
    if err ~= nil then
        micro.InfoBar():Error(err)
        return
    end

    bp.Buf:ReOpen()
end
