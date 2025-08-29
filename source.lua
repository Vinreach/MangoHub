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
    
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    
    KeySystem = { 
        Key = { "1234", "5678" },
        Note = "Key System.",
        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)",
        SaveKey = true,

        Callback = function(key)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/RoyRedRedVN/Script/refs/heads/main/MangoHub-CheckGame"))()
        end,
    },
})
