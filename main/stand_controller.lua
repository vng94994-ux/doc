-- MoonStand loader: defines globals and loads external core
-- Only configuration and core fetch should live here.

getgenv().Script = "Moon Stand"
getgenv().Owner = "USERNAME"

getgenv().DisableRendering = false
getgenv().BlackScreen = false
getgenv().FPSCap = 60

getgenv().Guns = {"rifle", "aug"} -- // "flintlock", "db", "lmg"

-- Load external core logic

loadstring(game:HttpGet("https://raw.githubusercontent.com/vng94994-ux/doc/refs/heads/main/main/stand_core.lua"))()
