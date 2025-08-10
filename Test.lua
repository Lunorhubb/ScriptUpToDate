-- ===== Grow a Garden AutoExec Installer =====
local ALLOW_INSTALL = true
local GAME_ID = 7436755782
local FILE_NAME = "grow_a_garden_loader.lua"
local SCRIPT_URL = "https://raw.githubusercontent.com/Lunorhubb/SpeedHubX/refs/heads/main/loader.lua"

-- Function to fetch and run code
local function fetchAndRun(url, tag)
    local ok, res = pcall(function() 
        return game:HttpGet(url) 
    end)
    if not ok or not res or #res == 0 then
        warn(string.format("[%s] Failed to download or empty file from: %s", tag or "Loader", url))
        return false
    end
    local func, err = loadstring(res)
    if not func then
        warn(string.format("[%s] Invalid Lua code: %s", tag or "Loader", err))
        return false
    end
    local success, runtimeErr = pcall(func)
    if not success then
        warn(string.format("[%s] Error running downloaded code: %s", tag or "Loader", runtimeErr))
        return false
    end
    return true
end

-- Loader code for autoexec
local loaderCode = string.format([[
if game.GameId == %d then
    local function fetchAndRun(url, tag)
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if not ok or not res or #res == 0 then
            warn(string.format("[%s] Failed to download or empty file from: %%s", tag or "Loader"), url)
            return false
        end
        local func, err = loadstring(res)
        if not func then
            warn(string.format("[%s] Invalid Lua code: %%s", tag or "Loader"), err)
            return false
        end
        local success, runtimeErr = pcall(func)
        if not success then
            warn(string.format("[%s] Error running downloaded code: %%s", tag or "Loader"), runtimeErr)
            return false
        end
        return true
    end
    fetchAndRun("%s", "Loader")
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

-- Try installing loader
local function tryInstall()
    if not writefile or not isfolder or not makefolder then
        warn("[Installer] Executor does not support file saving.")
        return false
    end
    local execName = identifyexecutor and identifyexecutor() or "Unknown"
    print("[Installer] Detected executor:", execName)
    local paths = executorPaths[execName] or { "autoexec" }
    for _, path in ipairs(paths) do
        local ok = pcall(function()
            if not isfolder(path) then makefolder(path) end
            writefile(path .. "/" .. FILE_NAME, loaderCode)
        end)
        if ok then
            print(string.format("[Installer] Installed loader to: %s/%s", path, FILE_NAME))
            return true
        end
    end
    warn("[Installer] Could not write loader to any known path.")
    return false
end

-- Run immediately if in Grow a Garden
if game.GameId == GAME_ID then
    fetchAndRun(SCRIPT_URL, "Runtime")
else
    print("[Installer] Not in Grow a Garden.")
end

-- Install if allowed
if ALLOW_INSTALL then
    tryInstall()
else
    print("[Installer] Auto-install skipped. Set ALLOW_INSTALL = true to install.")
end
