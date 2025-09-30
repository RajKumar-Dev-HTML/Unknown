-- Player Tools GUI LocalScript (updated: Clean background without extra layers)
-- Compatible with KRNL executor
-- Execute directly in KRNL or place in StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Color scheme
local COLOR_SCHEME = {
    PRIMARY = Color3.fromRGB(100, 80, 255),     -- Purple-blue
    SECONDARY = Color3.fromRGB(120, 100, 255),  -- Lighter purple-blue
    ACCENT = Color3.fromRGB(80, 180, 255),      -- Blue accent
    BACKGROUND = Color3.fromRGB(25, 25, 45),    -- Dark blue background
    GLASS = Color3.fromRGB(35, 30, 65),         -- Glass effect base
    TEXT = Color3.fromRGB(240, 240, 255),       -- Light text
    SUCCESS = Color3.fromRGB(80, 255, 180),     -- Green success
    WARNING = Color3.fromRGB(255, 200, 80),     -- Yellow warning
    DANGER = Color3.fromRGB(255, 100, 150)      -- Pink danger
}

-- Main GUI container with clean design
local PlayerToolsGUI = Instance.new("ScreenGui")
PlayerToolsGUI.Name = "PlayerToolsGUI"
PlayerToolsGUI.DisplayOrder = 10
PlayerToolsGUI.ResetOnSpawn = false
PlayerToolsGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
PlayerToolsGUI.Parent = CoreGui

-- Main frame with clean glass effect
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0, 50, 0, 50)
MainFrame.BackgroundColor3 = COLOR_SCHEME.GLASS
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = PlayerToolsGUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = COLOR_SCHEME.PRIMARY
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- Title bar (draggable area) with gradient
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = COLOR_SCHEME.PRIMARY
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

-- Gradient effect for title bar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLOR_SCHEME.PRIMARY),
    ColorSequenceKeypoint.new(1, COLOR_SCHEME.SECONDARY)
})
TitleGradient.Rotation = 15
TitleGradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Herramientas de Jugador"
TitleLabel.TextColor3 = COLOR_SCHEME.TEXT
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Control buttons container
local ControlButtons = Instance.new("Frame")
ControlButtons.Name = "ControlButtons"
ControlButtons.Size = UDim2.new(0, 70, 1, 0)
ControlButtons.Position = UDim2.new(1, -75, 0, 0)
ControlButtons.BackgroundTransparency = 1
ControlButtons.Parent = TitleBar

-- Minimize button with clean effect
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(0, 0, 0.5, -15)
MinimizeButton.BackgroundColor3 = COLOR_SCHEME.ACCENT
MinimizeButton.BackgroundTransparency = 0.1
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = COLOR_SCHEME.TEXT
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = ControlButtons

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = COLOR_SCHEME.ACCENT
MinimizeStroke.Thickness = 1
MinimizeStroke.Transparency = 0.3
MinimizeStroke.Parent = MinimizeButton

-- Close button with clean effect
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(0, 35, 0.5, -15)
CloseButton.BackgroundColor3 = COLOR_SCHEME.DANGER
CloseButton.BackgroundTransparency = 0.1
CloseButton.Text = "×"
CloseButton.TextColor3 = COLOR_SCHEME.TEXT
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = ControlButtons

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = COLOR_SCHEME.DANGER
CloseStroke.Thickness = 1
CloseStroke.Transparency = 0.3
CloseStroke.Parent = CloseButton

-- Content area (player list container)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -15, 1, -45)
ContentFrame.Position = UDim2.new(0, 7.5, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Player list scrolling frame with clean effect
local PlayerListScrollingFrame = Instance.new("ScrollingFrame")
PlayerListScrollingFrame.Name = "PlayerListScrollingFrame"
PlayerListScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
PlayerListScrollingFrame.BackgroundColor3 = COLOR_SCHEME.GLASS
PlayerListScrollingFrame.BackgroundTransparency = 0.8
PlayerListScrollingFrame.BorderSizePixel = 0
PlayerListScrollingFrame.ScrollBarThickness = 4
PlayerListScrollingFrame.ScrollBarImageColor3 = COLOR_SCHEME.PRIMARY
PlayerListScrollingFrame.ScrollBarImageTransparency = 0.5
PlayerListScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerListScrollingFrame.Parent = ContentFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 8)
ScrollCorner.Parent = PlayerListScrollingFrame

local ScrollStroke = Instance.new("UIStroke")
ScrollStroke.Color = COLOR_SCHEME.PRIMARY
ScrollStroke.Thickness = 1
ScrollStroke.Transparency = 0.6
ScrollStroke.Parent = PlayerListScrollingFrame

-- UIListLayout for player entries
local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 8)
PlayerListLayout.SortOrder = Enum.SortOrder.Name
PlayerListLayout.Parent = PlayerListScrollingFrame

-- Variables for GUI state
local isDragging = false
local dragInput, dragStart, startPos
local isMinimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, 320, 0, 35)

-- Tables to track active states
local viewingPlayers = {} -- Tracks which players are being spectated
local locatingPlayers = {} -- Tracks which players have locate enabled
local playerEntries = {} -- Tracks UI elements for each player
local selectedPlayer = nil -- Currently selected player
local currentActionFrame = nil -- Currently displayed action frame

-- Make GUI draggable
local function onDragStart(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                connection:Disconnect()
            end
        end)
    end
end

local function onDrag(input)
    if isDragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

-- Connect drag events
TitleBar.InputBegan:Connect(onDragStart)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and isDragging then
        onDrag(input)
    end
end)

-- Toggle minimize/maximize
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        MainFrame.Size = minimizedSize
        MinimizeButton.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = originalSize
        MinimizeButton.Text = "_"
    end
end

MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Close GUI
CloseButton.MouseButton1Click:Connect(function()
    PlayerToolsGUI.Enabled = false
end)

-- View/Unview functionality
local function viewPlayer(targetPlayer)
    if viewingPlayers[targetPlayer] then
        -- Stop viewing
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = localPlayer.Character:FindFirstChild("Humanoid")
        else
            camera.CameraSubject = localPlayer.CharacterAdded:Wait()
        end
        viewingPlayers[targetPlayer] = nil
    else
        -- Start viewing
        if targetPlayer.Character then
            camera.CameraSubject = targetPlayer.Character:WaitForChild("Humanoid", 5)
        else
            local character = targetPlayer.CharacterAdded:Wait()
            camera.CameraSubject = character:WaitForChild("Humanoid", 5)
        end
        viewingPlayers[targetPlayer] = true
        
        -- Handle character respawns while viewing
        targetPlayer.CharacterAdded:Connect(function(character)
            if viewingPlayers[targetPlayer] then
                camera.CameraSubject = character:WaitForChild("Humanoid", 5)
            end
        end)
    end
end

-- Get root part function for locate
local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("Head")
end

-- Enhanced Locate functionality with single-line display
local function Locate(plr)
    task.spawn(function()
        -- Remove existing locate GUI
        for i,v in pairs(CoreGui:GetChildren()) do
            if v.Name == plr.Name..'_LC' then
                v:Destroy()
            end
        end
        wait()
        
        if plr.Character and plr.Name ~= Players.LocalPlayer.Name and not CoreGui:FindFirstChild(plr.Name..'_LC') then
            local ESPholder = Instance.new("Folder")
            ESPholder.Name = plr.Name..'_LC'
            ESPholder.Parent = CoreGui
            
            repeat wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
            
            for b,n in pairs (plr.Character:GetChildren()) do
                if (n:IsA("BasePart")) then
                    local a = Instance.new("BoxHandleAdornment")
                    a.Name = plr.Name
                    a.Parent = ESPholder
                    a.Adornee = n
                    a.AlwaysOnTop = true
                    a.ZIndex = 10
                    a.Size = n.Size
                    a.Transparency = 0.5
                    a.Color3 = plr.TeamColor.Color
                end
            end
            
            if plr.Character and plr.Character:FindFirstChild('Head') then
                local BillboardGui = Instance.new("BillboardGui")
                local TextLabel = Instance.new("TextLabel")
                BillboardGui.Adornee = plr.Character.Head
                BillboardGui.Name = plr.Name
                BillboardGui.Parent = ESPholder
                BillboardGui.Size = UDim2.new(0, 200, 0, 30) -- Wider for single line
                BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                BillboardGui.AlwaysOnTop = true
                TextLabel.Parent = BillboardGui
                TextLabel.BackgroundTransparency = 1
                TextLabel.Position = UDim2.new(0, 0, 0, 0)
                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                TextLabel.Font = Enum.Font.SourceSansSemibold
                TextLabel.TextSize = 16
                TextLabel.TextColor3 = Color3.new(1, 1, 1)
                TextLabel.TextStrokeTransparency = 0
                TextLabel.TextYAlignment = Enum.TextYAlignment.Center
                TextLabel.TextXAlignment = Enum.TextXAlignment.Center
                
                -- Initial text
                local displayName = plr.DisplayName ~= plr.Name and plr.DisplayName or plr.Name
                local health = math.floor((plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health) or 0)
                TextLabel.Text = string.format("%s | Vida: %d | Dist: 0", displayName, health)
                TextLabel.ZIndex = 10
                
                local lcLoopFunc
                local addedFunc
                local teamChange
                
                -- Update loop: update distance & health frequently
                lcLoopFunc = RunService.Heartbeat:Connect(function()
                    if ESPholder.Parent == nil then
                        lcLoopFunc:Disconnect()
                        return
                    end
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((localPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
                        local health = math.floor(plr.Character:FindFirstChildOfClass("Humanoid").Health)
                        local displayName = plr.DisplayName ~= plr.Name and plr.DisplayName or plr.Name
                        TextLabel.Text = string.format("%s | Vida: %d | Dist: %d", displayName, health, dist)
                    end
                end)
                
                addedFunc = plr.CharacterAdded:Connect(function()
                    if ESPholder ~= nil and ESPholder.Parent ~= nil then
                        lcLoopFunc:Disconnect()
                        teamChange:Disconnect()
                        ESPholder:Destroy()
                        repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
                        Locate(plr)
                        addedFunc:Disconnect()
                    else
                        teamChange:Disconnect()
                        addedFunc:Disconnect()
                    end
                end)
                
                teamChange = plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
                    if ESPholder ~= nil and ESPholder.Parent ~= nil then
                        lcLoopFunc:Disconnect()
                        addedFunc:Disconnect()
                        ESPholder:Destroy()
                        repeat wait(1) until getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
                        Locate(plr)
                        teamChange:Disconnect()
                    else
                        teamChange:Disconnect()
                    end
                end)
            end
        end
    end)
end

-- Locate/Unlocate functionality
local function locatePlayer(targetPlayer)
    if locatingPlayers[targetPlayer] then
        -- Remove locate
        for i,v in pairs(CoreGui:GetChildren()) do
            if v.Name == targetPlayer.Name..'_LC' then
                v:Destroy()
            end
        end
        locatingPlayers[targetPlayer] = nil
    else
        -- Add locate
        Locate(targetPlayer)
        locatingPlayers[targetPlayer] = true
    end
end

-- Teleport functionality
local function teleportToPlayer(targetPlayer)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetCharacter = targetPlayer.Character
        if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame
        end
    end
end

-- Create action buttons frame for a player
local function createActionButtons(playerObj, playerFrame)
    -- Remove existing action frame if any
    if currentActionFrame then
        currentActionFrame:Destroy()
        currentActionFrame = nil
    end
    
    -- Create new action frame with clean effect
    local actionFrame = Instance.new("Frame")
    actionFrame.Name = "ActionButtons"
    actionFrame.Size = UDim2.new(1, 0, 0, 90)
    actionFrame.Position = UDim2.new(0, 0, 0, 40)
    actionFrame.BackgroundColor3 = COLOR_SCHEME.GLASS
    actionFrame.BackgroundTransparency = 0.2
    actionFrame.BorderSizePixel = 0
    actionFrame.Parent = playerFrame
    
    local actionCorner = Instance.new("UICorner")
    actionCorner.CornerRadius = UDim.new(0, 8)
    actionCorner.Parent = actionFrame
    
    local actionStroke = Instance.new("UIStroke")
    actionStroke.Color = COLOR_SCHEME.SECONDARY
    actionStroke.Thickness = 1
    actionStroke.Transparency = 0.5
    actionStroke.Parent = actionFrame
    
    -- Button container with grid layout
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Size = UDim2.new(1, -10, 1, -10)
    ButtonContainer.Position = UDim2.new(0, 5, 0, 5)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = actionFrame
    
    local ButtonLayout = Instance.new("UIGridLayout")
    ButtonLayout.CellSize = UDim2.new(1, 0, 0, 25)
    ButtonLayout.CellPadding = UDim2.new(0, 0, 0, 5)
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.Parent = ButtonContainer
    
    -- Teleport button
    local teleportButton = Instance.new("TextButton")
    teleportButton.Name = "TeleportButton"
    teleportButton.LayoutOrder = 1
    teleportButton.BackgroundColor3 = COLOR_SCHEME.ACCENT
    teleportButton.BackgroundTransparency = 0.1
    teleportButton.Text = "Teletransportarse al Jugador"
    teleportButton.TextColor3 = COLOR_SCHEME.TEXT
    teleportButton.TextSize = 12
    teleportButton.Font = Enum.Font.Gotham
    teleportButton.Parent = ButtonContainer
    
    local teleportCorner = Instance.new("UICorner")
    teleportCorner.CornerRadius = UDim.new(0, 6)
    teleportCorner.Parent = teleportButton
    
    local teleportStroke = Instance.new("UIStroke")
    teleportStroke.Color = COLOR_SCHEME.ACCENT
    teleportStroke.Thickness = 1
    teleportStroke.Transparency = 0.3
    teleportStroke.Parent = teleportButton
    
    -- View/Unview button
    local viewButton = Instance.new("TextButton")
    viewButton.Name = "ViewButton"
    viewButton.LayoutOrder = 2
    viewButton.BackgroundColor3 = COLOR_SCHEME.SUCCESS
    viewButton.BackgroundTransparency = 0.1
    viewButton.Text = "Ver Jugador"
    viewButton.TextColor3 = COLOR_SCHEME.TEXT
    viewButton.TextSize = 12
    viewButton.Font = Enum.Font.Gotham
    viewButton.Parent = ButtonContainer
    
    local viewCorner = Instance.new("UICorner")
    viewCorner.CornerRadius = UDim.new(0, 6)
    viewCorner.Parent = viewButton
    
    local viewStroke = Instance.new("UIStroke")
    viewStroke.Color = COLOR_SCHEME.SUCCESS
    viewStroke.Thickness = 1
    viewStroke.Transparency = 0.3
    viewStroke.Parent = viewButton
    
    -- Locate/Unlocate button
    local locateButton = Instance.new("TextButton")
    locateButton.Name = "LocateButton"
    locateButton.LayoutOrder = 3
    locateButton.BackgroundColor3 = COLOR_SCHEME.WARNING
    locateButton.BackgroundTransparency = 0.1
    locateButton.Text = "Localizar Jugador"
    locateButton.TextColor3 = COLOR_SCHEME.TEXT
    locateButton.TextSize = 12
    locateButton.Font = Enum.Font.Gotham
    locateButton.Parent = ButtonContainer
    
    local locateCorner = Instance.new("UICorner")
    locateCorner.CornerRadius = UDim.new(0, 6)
    locateCorner.Parent = locateButton
    
    local locateStroke = Instance.new("UIStroke")
    locateStroke.Color = COLOR_SCHEME.WARNING
    locateStroke.Thickness = 1
    locateStroke.Transparency = 0.3
    locateStroke.Parent = locateButton
    
    -- Update button states based on current active states
    if viewingPlayers[playerObj] then
        viewButton.Text = "Dejar de Ver"
        viewButton.BackgroundColor3 = COLOR_SCHEME.DANGER
    end
    
    if locatingPlayers[playerObj] then
        locateButton.Text = "Dejar de Localizar"
        locateButton.BackgroundColor3 = COLOR_SCHEME.DANGER
    end
    
    -- Connect button events
    teleportButton.MouseButton1Click:Connect(function()
        teleportToPlayer(playerObj)
    end)
    
    viewButton.MouseButton1Click:Connect(function()
        viewPlayer(playerObj)
        -- Update button text
        if viewingPlayers[playerObj] then
            viewButton.Text = "Dejar de Ver"
            viewButton.BackgroundColor3 = COLOR_SCHEME.DANGER
        else
            viewButton.Text = "Ver Jugador"
            viewButton.BackgroundColor3 = COLOR_SCHEME.SUCCESS
        end
    end)
    
    locateButton.MouseButton1Click:Connect(function()
        locatePlayer(playerObj)
        -- Update button text
        if locatingPlayers[playerObj] then
            locateButton.Text = "Dejar de Localizar"
            locateButton.BackgroundColor3 = COLOR_SCHEME.DANGER
        else
            locateButton.Text = "Localizar Jugador"
            locateButton.BackgroundColor3 = COLOR_SCHEME.WARNING
        end
    end)
    
    -- Store reference
    currentActionFrame = actionFrame
    selectedPlayer = playerObj
end

-- Improved function to get player thumbnails with better error handling
local function getPlayerThumbnail(userId, thumbnailType, thumbnailSize)
    local success, result = pcall(function()
        return Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)
    end)
    
    if success then
        return result
    else
        warn("Failed to get thumbnail for user " .. userId .. ": " .. tostring(result))
        return nil
    end
end

-- Create player entry in the list with clean effect
local function createPlayerEntry(player)
    if player == localPlayer then return end -- Skip local player
    
    local playerFrame = Instance.new("Frame")
    playerFrame.Name = player.Name
    playerFrame.Size = UDim2.new(1, 0, 0, 40) -- Default height (will expand when selected)
    playerFrame.BackgroundTransparency = 1
    playerFrame.Parent = PlayerListScrollingFrame
    
    -- Player button (used for selection) with clean effect
    local playerButton = Instance.new("TextButton")
    playerButton.Name = "PlayerButton"
    playerButton.Size = UDim2.new(1, 0, 0, 40)
    playerButton.Position = UDim2.new(0, 0, 0, 0)
    playerButton.BackgroundColor3 = COLOR_SCHEME.GLASS
    playerButton.BackgroundTransparency = 0.3
    playerButton.BorderSizePixel = 0
    playerButton.Text = "" -- text replaced by labels below
    playerButton.TextColor3 = COLOR_SCHEME.TEXT
    playerButton.TextSize = 12
    playerButton.Font = Enum.Font.Gotham
    playerButton.Parent = playerFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = playerButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLOR_SCHEME.SECONDARY
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = playerButton
    
    -- Profile Image with clean effect
    local profileImage = Instance.new("ImageLabel")
    profileImage.Name = "ProfileImage"
    profileImage.Size = UDim2.new(0, 32, 0, 32)
    profileImage.Position = UDim2.new(0, 6, 0, 4)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" -- Default placeholder
    profileImage.ScaleType = Enum.ScaleType.Crop
    profileImage.Parent = playerButton
    
    local imgCorner = Instance.new("UICorner")
    imgCorner.CornerRadius = UDim.new(0, 8)
    imgCorner.Parent = profileImage
    
    local imgStroke = Instance.new("UIStroke")
    imgStroke.Color = COLOR_SCHEME.PRIMARY
    imgStroke.Thickness = 2
    imgStroke.Transparency = 0.4
    imgStroke.Parent = profileImage
    
    -- Name label (DisplayName (username))
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -45, 1, 0)
    nameLabel.Position = UDim2.new(0, 45, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = COLOR_SCHEME.TEXT
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 13
    nameLabel.Text = tostring(player.DisplayName or player.Name) .. " (@" .. player.Name .. ")"
    nameLabel.Parent = playerButton
    
    -- Status indicator (online/offline)
    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, 8, 0, 8)
    statusIndicator.Position = UDim2.new(1, -15, 0.5, -4)
    statusIndicator.BackgroundColor3 = COLOR_SCHEME.SUCCESS
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = playerButton
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = statusIndicator
    
    -- Improved profile picture loading with multiple fallbacks
    spawn(function()
        -- Try multiple thumbnail types as fallbacks
        local thumbnailTypes = {
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailType.AvatarThumbnail,
            Enum.ThumbnailType.AvatarBust
        }
        
        local thumbnailUrl = nil
        
        for _, thumbType in ipairs(thumbnailTypes) do
            thumbnailUrl = getPlayerThumbnail(player.UserId, thumbType, Enum.ThumbnailSize.Size48x48)
            if thumbnailUrl and thumbnailUrl ~= "" then
                break
            end
        end
        
        if thumbnailUrl and thumbnailUrl ~= "" then
            -- Set the image with error handling
            local success, err = pcall(function()
                profileImage.Image = thumbnailUrl
            end)
            
            if not success then
                warn("Failed to load profile image for " .. player.Name .. ": " .. tostring(err))
            end
        else
            -- Final fallback - use a generic Roblox icon
            pcall(function()
                profileImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            end)
        end
    end)
    
    -- Update display name if it changes
    player:GetPropertyChangedSignal("DisplayName"):Connect(function()
        if nameLabel and nameLabel.Parent then
            nameLabel.Text = tostring(player.DisplayName or player.Name) .. " (@" .. player.Name .. ")"
        end
    end)
    
    -- Connect click event
    playerButton.MouseButton1Click:Connect(function()
        if selectedPlayer == player then
            -- Deselect if already selected
            if currentActionFrame then
                currentActionFrame:Destroy()
                currentActionFrame = nil
            end
            playerFrame.Size = UDim2.new(1, 0, 0, 40)
            selectedPlayer = nil
        else
            -- Select this player
            -- cleanup previous selection
            if currentActionFrame and currentActionFrame.Parent then
                currentActionFrame:Destroy()
                currentActionFrame = nil
            end
            -- restore previous selected player's size if exists
            for p, entry in pairs(playerEntries) do
                if entry and entry ~= playerFrame then
                    entry.Size = UDim2.new(1, 0, 0, 40)
                end
            end
            playerFrame.Size = UDim2.new(1, 0, 0, 135) -- Expand to fit buttons
            createActionButtons(player, playerFrame)
        end
    end)
    
    -- Store reference
    playerEntries[player] = playerFrame
end

-- Remove player entry
local function removePlayerEntry(player)
    local entry = playerEntries[player]
    if entry then
        entry:Destroy()
        playerEntries[player] = nil
        
        -- Clean up active states
        viewingPlayers[player] = nil
        locatingPlayers[player] = nil
        
        -- If this was the selected player, clear selection
        if selectedPlayer == player then
            selectedPlayer = nil
            if currentActionFrame then
                currentActionFrame:Destroy()
                currentActionFrame = nil
            end
        end
    end
end

-- Initialize player list
local function initializePlayerList()
    -- Clear existing entries
    for _, entry in pairs(playerEntries) do
        if entry and entry.Parent then entry:Destroy() end
    end
    playerEntries = {}
    viewingPlayers = {}
    locatingPlayers = {}
    selectedPlayer = nil
    currentActionFrame = nil
    
    -- Add all current players except local player
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= localPlayer then
            createPlayerEntry(pl)
        end
    end
end

-- Set up player connection events
Players.PlayerAdded:Connect(function(player)
    wait(0.5) -- Small delay to ensure player is fully initialized
    if player ~= localPlayer then
        createPlayerEntry(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removePlayerEntry(player)
end)

-- Initialize the GUI
initializePlayerList()
