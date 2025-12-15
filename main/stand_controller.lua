-- MoonStand loader: defines globals and loads utils + core
-- Only configuration and fetch logic live here

getgenv().Script = "Moon Stand"
getgenv().Owner = "USERNAME"

getgenv().DisableRendering = false
getgenv().BlackScreen = false
getgenv().FPSCap = 60

getgenv().Guns = {"rifle", "aug"}  -- // "flintlock", "db", "lmg"

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/vng94994-ux/doc/refs/heads/main/main/stand_utils.lua"
))()

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/vng94994-ux/doc/refs/heads/main/main/stand_core.lua"
))()
