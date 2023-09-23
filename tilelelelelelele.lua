-- Create a new ScreenGui instance
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Set the size to cover the whole screen
screenGui.ResetOnSpawn = false
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Background color (you can change this)
frame.BackgroundTransparency = 0.5 -- Adjust transparency as needed
frame.Parent = screenGui

-- Add a TextLabel on top of the TextBox
local label = Instance.new("TextLabel")
label.Text = "Put Player Username/Display Name"
label.Size = UDim2.new(0.5, 0, 0.1, 0)
label.Position = UDim2.new(0.25, 0, 0.05, 0) -- Adjust position here
label.Parent = frame

-- Position a TextBox below the TextLabel
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.5, 0, 0.2, 0)
textBox.Position = UDim2.new(0.25, 0, 0.2, 0) -- Adjust position here
textBox.Parent = frame

-- Add a TextButton named "Cframe" positioned below the TextBox
local cframeButton = Instance.new("TextButton")
cframeButton.Text = "Cframe"
cframeButton.Size = UDim2.new(0.3, 0, 0.1, 0)
cframeButton.Position = UDim2.new(0.35, 0, 0.45, 0) -- Adjust position here
cframeButton.Parent = frame

-- Add a TextButton named "Tween" positioned below the TextBox
local tweenButton = Instance.new("TextButton")
tweenButton.Text = "Tween"
tweenButton.Size = UDim2.new(0.3, 0, 0.1, 0)
tweenButton.Position = UDim2.new(0.35, 0, 0.6, 0) -- Adjust position here
tweenButton.Parent = frame

-- Add a TextButton named "View" positioned below the "Cframe" and "Tween" buttons
local viewButton = Instance.new("TextButton")
viewButton.Text = "View"
viewButton.Size = UDim2.new(0.3, 0, 0.1, 0)
viewButton.Position = UDim2.new(0.35, 0, 0.75, 0) -- Adjust position here
viewButton.Parent = frame

-- Bind the "View" button click event to focus the camera on a player's head
viewButton.MouseButton1Click:Connect(function()
    local partialName = textBox.Text:sub(6):lower() -- Assuming "view " takes 6 characters
    
    -- Find a player whose name or display name contains the provided text
    local targetPlayer = nil
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Name:lower():find(partialName, 1, true) or (player.DisplayName and player.DisplayName:lower():find(partialName, 1, true)) then
            targetPlayer = player
            break
        end
    end
    
    if targetPlayer then
        -- Set the camera's subject to the target player's head
        local targetCharacter = targetPlayer.Character
        if targetCharacter and targetCharacter:FindFirstChild("Head") then
            game.Workspace.CurrentCamera.CameraSubject = targetCharacter.Head
        else
            warn("Player does not have a Head part: " .. targetPlayer.Name)
        end
    else
        warn("Player not found: " .. partialName)
    end
end)

-- Add a TextButton named "Unview" positioned below the "View" button
local unviewButton = Instance.new("TextButton")
unviewButton.Text = "Unview"
unviewButton.Size = UDim2.new(0.3, 0, 0.1, 0)
unviewButton.Position = UDim2.new(0.35, 0, 0.9, 0) -- Adjust position here
unviewButton.Parent = frame

-- Function to set the camera back to your own player
local function viewYourPlayer()
    game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
end

-- Bind the "Unview" button click event to focus the camera back on your player
unviewButton.MouseButton1Click:Connect(function()
    viewYourPlayer()
end)

-- Create a ScrollFrame on the right side
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.2, 0, 0.7, 0) -- Adjust size
scrollFrame.Position = UDim2.new(0.8, 0, 0.2, 0) -- Move to the right side
scrollFrame.Parent = frame

-- Create a UIListLayout inside the ScrollFrame
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame

-- Function to refresh the player list in the ScrollFrame
local function refreshPlayerList()
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, player in pairs(game.Players:GetPlayers()) do
        local playerNameButton = Instance.new("TextButton")
        playerNameButton.Text = player.Name
        playerNameButton.Size = UDim2.new(1, 0, 0, 30) -- Adjust size as needed
        playerNameButton.Parent = scrollFrame

        -- Bind the click event to populate the textbox with the player's name
        playerNameButton.MouseButton1Click:Connect(function()
            textBox.Text = " " .. player.Name
        end)
    end
end

-- Initial player list
refreshPlayerList()

-- Function to CFrame teleport to a player using partial username or display name
local function cframeToPlayer(playerName)
    for _, player in pairs(game.Players:GetPlayers()) do
        if string.find(player.Name:lower(), playerName, 1, true) or (player.DisplayName and string.find(player.DisplayName:lower(), playerName, 1, true)) then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame)
            return
        end
    end
end

-- Function to Tween teleport to a player using partial username or display name
local function tweenToPlayer(playerName)
    for _, player in pairs(game.Players:GetPlayers()) do
        if string.find(player.Name:lower(), playerName, 1, true) or (player.DisplayName and string.find(player.DisplayName:lower(), playerName, 1, true)) then
            local targetCharacter = player.Character
            if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                local tweenInfo = TweenInfo.new(
                    1, -- Time (adjust as needed)
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.Out
                )
                local tween = game.TweenService:Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    tweenInfo,
                    {CFrame = targetCharacter.HumanoidRootPart.CFrame}
                )
                tween:Play()
                return
            else
                warn("Player does not have a HumanoidRootPart: " .. playerName)
            end
        end
    end
end

-- Bind the "Cframe" button click event to CFrame teleport
cframeButton.MouseButton1Click:Connect(function()
    local playerName = textBox.Text:sub(6):lower() -- Assuming "view " takes 6 characters
    if playerName ~= "" then
        cframeToPlayer(playerName)
    end
end)

-- Bind the "Tween" button click event to Tween teleport
tweenButton.MouseButton1Click:Connect(function()
    local playerName = textBox.Text:sub(6):lower() -- Assuming "view " takes 6 characters
    if playerName ~= "" then
        tweenToPlayer(playerName)
    end
end)

-- Add a TextButton called "X" and position it in the right top corner
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0.05, 0) -- Adjust position here
closeButton.Parent = frame

-- Define the function to destroy the ScreenGui
local function destroyScreenGui()
    screenGui:Destroy()
end

-- Bind the function to the "X" TextButton's click event
closeButton.MouseButton1Click:Connect(destroyScreenGui)

-- Periodically refresh the player list (you can adjust the interval as needed)
while true do
    wait(5) -- Refresh every 10 seconds
    refreshPlayerList()
end
