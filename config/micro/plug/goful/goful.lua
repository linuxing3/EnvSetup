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
    config.AddRuntimeFile("go", config.RTHelp, "help/goful-plugin.md")
    config.TryBindKey("F4", "command-edit:goful", false)
end

function goful(bp)
    if shell.TermEmuSupported then
        local err = shell.RunTermEmulator(bp, "goful", false, true, gofulOutput, {bp})
        if err ~= nil then
            micro.InfoBar():Error(err)
        end
    else
        local output, err = shell.RunInteractiveShell("goful", false, true)
        if err ~= nil then
            micro.InfoBar():Error(err)
        else
            gofulOutput(output, {bp})
        end
    end
end

function gofulOutput(output, args)
    local bp = args[1]
    local strings = import("strings")
    output = strings.TrimSpace(output)
    if output ~= "" then
        local buf, err = buffer.NewBufferFromFile(output)
        if err == nil then
            bp:OpenBuffer(buf)
        end
    end
end
