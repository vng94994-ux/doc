local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local function getLp()
    return Players.LocalPlayer
end

local function getMouse()
    return getLp():GetMouse()
end

local function normalizeName(name)
    return string.lower((name or ""):gsub("[^%w]", ""))
end

local ConnectionManager = {}
ConnectionManager.__index = ConnectionManager

function ConnectionManager.new()
    return setmetatable({ connections = {}, tasks = {} }, ConnectionManager)
end

function ConnectionManager:connect(signal, fn)
    local conn = signal:Connect(fn)
    table.insert(self.connections, conn)
    return conn
end

function ConnectionManager:addTask(thread)
    table.insert(self.tasks, thread)
    return thread
end

function ConnectionManager:cleanup()
    for _, conn in ipairs(self.connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    self.connections = {}
    for _, thread in ipairs(self.tasks) do
        pcall(function()
            if task.cancel then
                task.cancel(thread)
            end
        end)
    end
    self.tasks = {}
end

local function getChar(plr)
    return plr and plr.Character
end

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(char)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getPingSeconds()
    local value = nil
    pcall(function()
        local perf = Stats.PerformanceStats:FindFirstChild("Ping")
        if perf and perf.GetValue then
            value = perf:GetValue()
        end
        if not value then
            local dataPing = Stats.Network.ServerStatsItem["Data Ping"]
            if dataPing and dataPing.GetValue then
                value = dataPing:GetValue()
            end
        end
    end)
    return (value or 50) / 1000
end

local function getPartVelocity(part, lastPositions)
    local vel = part.AssemblyLinearVelocity or part.Velocity or Vector3.new()
    local now = tick()
    local last = lastPositions[part]
    if last and last.time and now > last.time then
        vel = (part.Position - last.pos) / (now - last.time)
    end
    lastPositions[part] = { pos = part.Position, time = now }
    return vel
end

local function resolvePlayer(query)
    if not query or query == "" then
        return nil
    end
    local lower = string.lower(query)
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name) == lower or string.lower(plr.DisplayName) == lower then
            return plr
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(plr.Name), lower, 1, true) or string.find(string.lower(plr.DisplayName), lower, 1, true) then
            return plr
        end
    end
    return nil
end

local function getDetectorAndHead(model)
    if not model then
        return nil, nil
    end
    local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart", true)
    local detector = model:FindFirstChildOfClass("ClickDetector") or (head and head:FindFirstChildOfClass("ClickDetector"))
    return detector, head
end

local function fireDetector(detector)
    if detector and fireclickdetector then
        fireclickdetector(detector)
    end
end

getgenv().StandUtils = {
    Players = Players,
    RunService = RunService,
    ReplicatedStorage = ReplicatedStorage,
    Workspace = Workspace,
    Stats = Stats,
    getLp = getLp,
    getMouse = getMouse,
    normalizeName = normalizeName,
    ConnectionManager = ConnectionManager,
    getChar = getChar,
    getRoot = getRoot,
    getHumanoid = getHumanoid,
    getPingSeconds = getPingSeconds,
    getPartVelocity = getPartVelocity,
    resolvePlayer = resolvePlayer,
    getDetectorAndHead = getDetectorAndHead,
    fireDetector = fireDetector,
}
