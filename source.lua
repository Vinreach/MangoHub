olocal HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local DevWhitelist = {
    [3084718882] = true,
    [3902155812] = true
}

if DevWhitelist[player.UserId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vinreach/MangoHub-Script/refs/heads/main/MangoHub-Load.lua"))()
    return
end

local FIREBASE_DB_URL = "https://vinchat-real-default-rtdb.firebaseio.com"
local DataStoreKey = "MangoHubKey"
local KEY_EXPIRE_SECONDS = 24 * 60 * 60

local function SaveLocal(key)
    local data = { Key = key, Time = os.time() }
    writefile(DataStoreKey..".json", HttpService:JSONEncode(data))
end
local function LoadLocal()
    if isfile(DataStoreKey..".json") then
        return HttpService:JSONDecode(readfile(DataStoreKey..".json"))
    end
    return nil
end

local function FetchKeyInfo(key)
    local url = FIREBASE_DB_URL.."/keys/"..key..".json"
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or not res or res == "null" then return nil end
    local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok2 then return nil end
    return data
end

local function IsKeyValidServerSide(keyInfo)
    if not keyInfo then return false end
    if keyInfo.status ~= "active" then return false end
    if type(keyInfo.expiresAt) ~= "number" then return false end
    return os.time() < keyInfo.expiresAt
end

local function SecondsLeft(keyInfo)
    if not keyInfo or type(keyInfo.expiresAt) ~= "number" then return 0 end
    return keyInfo.expiresAt - os.time()
end

local function Notify(title, content, dur, icon)
    WindUI:Notify({Title = title, Content = content, Duration = dur or 3, Icon = icon or "notification"})
end

local function TryAutoLogin()
    local saved = LoadLocal()
    if not saved or not saved.Key then return false end
    local info = FetchKeyInfo(saved.Key)
    if IsKeyValidServerSide(info) then
        local left = SecondsLeft(info)
        if left <= 3600 then
            Notify("Reminder", "Key will expire in less than 1 hour. Please get a new key soon.", 5, "warning")
        end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Vinreach/MangoHub-Script/refs/heads/main/MangoHub-Load.lua"))()
        return true
    else
        if info and info.status ~= "active" then
            Notify("Warning", "Key is not active. Please get a new key.", 4, "warning")
        else
            Notify("Warning", "Your saved key has expired or is invalid. Please enter a new one.", 4, "warning")
        end
        return false
    end
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/RoyRedRedVN/Library-Ui-For-Script-Hacking/refs/heads/main/windui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "MangoHub",
    Icon = "door-open",
    Author = "by Vinreach",
    Folder = "Key",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = true },
    KeySystem = {
        Key = {},
        Note = "Paste the key from GetKey app. Anyone who has the key can use it.",
        URL = "No Link",
        SaveKey = false,
        Callback = function(inputKey)
            if not inputKey or inputKey=="" then
                Notify("Error", "Please enter a key.", 3, "warning")
                return
            end
            local info = FetchKeyInfo(inputKey)
            if IsKeyValidServerSide(info) then
                SaveLocal(inputKey)
                local left = SecondsLeft(info)
                if left <= 3600 then
                    Notify("Reminder", "Key will expire in < 1 hour. Please get a new one.", 5, "warning")
                else
                    Notify("Success", "Key valid — unlocked!", 3, "notification")
                end
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Vinreach/MangoHub-Script/refs/heads/main/MangoHub-Load.lua"))()
            else
                Notify("Invalid", "Key invalid/expired. Please get a new key from the GetKey app.", 4, "warning")
            end
        end
    }
})

if not TryAutoLogin() then
    Notify("Info", "Please enter your key from GetKey app to unlock.", 4, "notification")
end
