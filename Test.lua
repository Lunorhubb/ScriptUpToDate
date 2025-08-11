-- Test.lua - AutoExec Installer + Immediate Loader Run (Safe)
local LOADER_URL = "https://raw.githubusercontent.com/Lunorhubb/LunorScript/refs/heads/main/Loader.lua"
local AUTOEXEC_FILE = "autoexec/loader_installer.lua"

local function installLoader()
    if writefile and isfolder("autoexec") then
        local loaderCode = string.format('loadstring(game:HttpGet("%s"))()', LOADER_URL)
        pcall(function()
            writefile(AUTOEXEC_FILE, loaderCode)
        end)
        print("[Installer] Loader auto-exec script installed successfully!")
    else
        warn("[Installer] Your executor does not support writefile or autoexec folder.")
    end
end

local function runLoader()
    pcall(function()
        local code = game:HttpGet(LOADER_URL)
        loadstring(code)()
    end)
end

-- Install to autoexec
pcall(installLoader)

-- Run loader immediately
pcall(runLoader)
