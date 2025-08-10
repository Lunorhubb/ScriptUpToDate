-- Self-installing autoexec for Grow a Garden
local TARGET_PLACE_ID = 6884319169 -- Grow a Garden's PlaceId

if game.PlaceId == TARGET_PLACE_ID then
    if writefile and isfolder and makefolder and isfile then
        if not isfolder("autoexec") then
            makefolder("autoexec")
        end
        if not isfile("autoexec/SpeedHubX.lua") then
            writefile(
                "autoexec/SpeedHubX.lua",
                string.format([[
if game.PlaceId == %d then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunorhubb/SpeedHubX/refs/heads/main/loader.lua"))()
end
]], TARGET_PLACE_ID)
            )
            print("[SpeedHubX] Installed to autoexec for Grow a Garden. It will now run automatically.")
        end
    end

    -- Run your loader right now
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunorhubb/SpeedHubX/refs/heads/main/loader.lua"))()
else
    warn("[SpeedHubX] This script only works in Grow a Garden.")
end
