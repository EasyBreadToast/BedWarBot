--Put your user id here
local idList = {"673714191"}

if not game:IsLoaded() then
	game.Loaded:Wait()
	print("Not yet loaded")
end wait(4) print("waiting...")

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local items = {"emerald","diamond","iron"}

local fx,fz = math.random(1,1), math.random(-1,1)
local follower,dropper = false,false
local remoteUser

local function chat(text)
	local A_1,A_2 = text,"All" 
	local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest 
	Event:FireServer(A_1, A_2) 
end

for _,id in pairs(idList) do
	local stringId	= tostring(localPlayer.UserId)
	if stringId == id then
		print("LocalPlayerID Found")
		--This is the only way i know...
		while wait(10^10) do end
	end
end	

--Very bad way
spawn(function()
	while wait() do
		for _,player in pairs(players:GetChildren()) do
			local stringName = tostring(player.UserId)

			for _,id in pairs(idList) do
				if stringName == id then
					player.Chatted:Connect(function(msg)
						print(player,"chatted")
						if msg == "reset" then
							--chat("Resetting")
							localPlayer.character.Humanoid.Health = 0 
						elseif msg == "follow" then
							follower = true
							--Update directions
							fx,fz = math.random(-1,1),1
							remoteUser = player.Character
						elseif msg == "unfollow" then
							follower = false
						end
					end)
				end
			end
		end
		wait(8)
	end
end)



game:GetService("RunService").RenderStepped:Connect(function()
	if follower == true then
		local updatedCharacter = players.LocalPlayer.Character
		local remoteHumanoid = remoteUser.HumanoidRootPart
		
		local targetRoot = remoteHumanoid.CFrame:pointToWorldSpace(Vector3.new(fx, 0, fz))

		if updatedCharacter.HumanoidRootPart:FindFirstChild("BF") == nil then 
			local BF = Instance.new("BodyPosition",updatedCharacter.HumanoidRootPart)
			BF.MaxForce = Vector3.new(0,128000,0)
			BF.D	= 128
			BF.Name = "BF"
		else
			updatedCharacter.HumanoidRootPart.BF.Position = Vector3.new(0,remoteHumanoid.Position.Y,0)
		end

		updatedCharacter.Humanoid.WalkSpeed = 21
		updatedCharacter.Humanoid:MoveTo(targetRoot)
	end
end)
