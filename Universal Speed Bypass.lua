--v0.1

local player = game.Players.LocalPlayer

local character = player.Character

local newHumanoid = character.Humanoid:Clone()

local speed = 90

newHumanoid.Parent = character

character.Humanoid:Destroy()

workspace.Camera.CameraSubject = newHumanoid

newHumanoid:GetPropertyChangedSignal("Parent"):Connect(function()
    workspace.Camera.CameraSubject = newHumanoid
end)
