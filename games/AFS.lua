newModule("AFS", "ModuleScript", "Pombium.games.AFS", "Pombium.games", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local Fleet = TS.import(script, script.Parent.Parent, "utils", "fleet").default
local Log = TS.import(script, TS.getModule(script, "@rbxts", "log").out).default
local services = TS.import(script, script, "controllers", "load")
local ui = TS.import(script, script, "app", "load")
local main = TS.async(function()
	for _, service in pairs(ui) do
		Fleet.register(service)
	end
	for _, service in pairs(services) do
		Fleet.register(service)
	end
	Fleet.fire()
end)
main():catch(function(err)
	Log.Warn("Pombium failed to load {game}: {err}", GameName, err)
end)
return nil
 end, newEnv("Pombium.games.AFS"))() end)

newInstance("app", "Folder", "Pombium.games.AFS.app", "Pombium.games.AFS")

newModule("farm", "ModuleScript", "Pombium.games.AFS.app.farm", "Pombium.games.AFS.app", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local _constants = TS.import(script, script.Parent.Parent, "constants")
local IGNORED_METEOR = _constants.IGNORED_METEOR
local IGNORED_WORLDS = _constants.IGNORED_WORLDS
local _world_utils = TS.import(script, script.Parent.Parent, "utils", "world-utils")
local getCurrentWorld = _world_utils.getCurrentWorld
local getOrderedWorlds = _world_utils.getOrderedWorlds
local worldValue = _world_utils.worldValue
local Fleet = TS.import(script, script.Parent.Parent.Parent.Parent, "utils", "fleet").default
local getEnemies = TS.import(script, script.Parent.Parent, "utils", "enemy-utils").getEnemies
local hubController
local settingsController
local FarmUI
do
	FarmUI = setmetatable({}, {
		__tostring = function()
			return "FarmUI"
		end,
	})
	FarmUI.__index = FarmUI
	function FarmUI.new(...)
		local self = setmetatable({}, FarmUI)
		return self:constructor(...) or self
	end
	function FarmUI:constructor()
		self._loadOrder = 0
		self.ClassName = "FarmUI"
	end
	function FarmUI:onInit()
		hubController = Fleet.getDependency("Hub")
		settingsController = Fleet.getDependency("Settings")
		local saveManager = settingsController:getSaveManager()
		saveManager:SetIgnoreIndexes({ "Farm_Target", "Farm_TargetList", "Farm_Teleport" })
		self.section = hubController:getWindow():AddTab("Farm")
		local farmTabbox = self.section:AddLeftTabbox()
		local combatGroupbox = self.section:AddRightGroupbox("Combat Settings")
		local modesTabbox = self.section:AddLeftTabbox()
		local meteorGroupbox = self.section:AddRightGroupbox("Meteor")
		local farmTab = farmTabbox:AddTab("Autofarm")
		farmTab:AddToggle("Farm_Autofarm", {
			Text = "Autofarm",
		})
		farmTab:AddToggle("Farm_Target", {
			Text = "Attack Targets",
		})
		farmTab:AddDropdown("Farm_TargetList", {
			Text = "Select Targets",
			Multi = true,
			Compact = true,
			Values = {},
		})
		farmTab:AddButton("Select All", function()
			return true
		end):AddButton("Unselect All", function()
			return true
		end)
		worldValue.Changed:Connect(function()
			return self:updateTargetList()
		end)
		self:updateTargetList()
		local playTab = farmTabbox:AddTab("Auto Play")
		playTab:AddToggle("Farm_Play", {
			Text = "Auto Play [BETA]",
		})
		playTab:AddToggle("Farm_Quest", {
			Text = "Auto Quest",
		})
		combatGroupbox:AddToggle("Farm_Click", {
			Text = "Auto Click",
		})
		combatGroupbox:AddToggle("Farm_Collect", {
			Text = "Auto Collect",
		})
		combatGroupbox:AddToggle("Farm_Ability", {
			Text = "Ability Cancel",
		})
		combatGroupbox:AddToggle("Farm_Spread", {
			Text = "Spread Units",
		})
		combatGroupbox:AddSlider("Farm_Range", {
			Text = "Farm Range",
			Default = 100,
			Min = 100,
			Max = 1000,
			Rounding = 0,
		})
		combatGroupbox:AddSlider("Farm_Speed", {
			Text = "Unit Speed",
			Default = 1,
			Min = 1,
			Max = 10,
			Rounding = 1,
		})
		local trialTab = modesTabbox:AddTab("Trial")
		local raidTab = modesTabbox:AddTab("Raid")
		local defenseTab = modesTabbox:AddTab("Defense")
		trialTab:AddDropdown("Farm_TrialList", {
			Values = { "Lesser", "Medium", "Greater", "Ultimate" },
			Multi = true,
			Text = "Trials",
		})
		trialTab:AddToggle("Farm_Trial", {
			Text = "Trial Farm",
		})
		trialTab:AddToggle("Farm_NoChest", {
			Text = "Ignore Chest",
		})
		trialTab:AddToggle("Farm_Teleport", {
			Text = "Teleport Back",
		})
		trialTab:AddButton("Save Location", function()
			return true
		end):AddButton("Remove Location", function()
			return true
		end)
		local worlds = getOrderedWorlds()
		local _fn = raidTab
		local _object = {
			Multi = true,
		}
		local _left = "Values"
		local _arg0 = function(v)
			local _name = v.Name
			local _condition = table.find(IGNORED_WORLDS, _name) ~= nil
			if not _condition then
				_condition = v.NoRaid
			end
			return not _condition
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(worlds) do
			if _arg0(_v, _k - 1, worlds) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local _arg0_1 = function(v)
			return v.Name
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue_1 = table.create(#_newValue)
		for _k, _v in ipairs(_newValue) do
			_newValue_1[_k] = _arg0_1(_v, _k - 1, _newValue)
		end
		-- ▲ ReadonlyArray.map ▲
		_object[_left] = _newValue_1
		_object.Text = "Ignore Raids"
		_fn:AddDropdown("Farm_RaidIgnore", _object)
		raidTab:AddToggle("Farm_Raid", {
			Text = "Raid Farm",
		})
		raidTab:AddButton("Save Location", function()
			return true
		end):AddButton("Remove Location", function()
			return true
		end)
		local _fn_1 = defenseTab
		local _object_1 = {}
		local _left_1 = "Values"
		local _arg0_2 = function(v)
			local _name = v.Name
			local _condition = table.find(IGNORED_WORLDS, _name) ~= nil
			if not _condition then
				_condition = v.NoDefense
			end
			return not _condition
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue_2 = {}
		local _length_1 = 0
		for _k, _v in ipairs(worlds) do
			if _arg0_2(_v, _k - 1, worlds) == true then
				_length_1 += 1
				_newValue_2[_length_1] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local _arg0_3 = function(v)
			return v.Name
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue_3 = table.create(#_newValue_2)
		for _k, _v in ipairs(_newValue_2) do
			_newValue_3[_k] = _arg0_3(_v, _k - 1, _newValue_2)
		end
		-- ▲ ReadonlyArray.map ▲
		_object_1[_left_1] = _newValue_3
		_object_1.Multi = true
		_object_1.Text = "Choose Defense"
		_fn_1:AddDropdown("Farm_DefenseOption", _object_1)
		defenseTab:AddToggle("Farm_Defense", {
			Text = "Defense Farm",
		})
		defenseTab:AddToggle("Farm_JoinOther", {
			Text = "Join Others",
		})
		defenseTab:AddButton("Save Location", function()
			return true
		end):AddButton("Remove Location", function()
			return true
		end)
		local _fn_2 = defenseTab
		local _object_2 = {}
		local _left_2 = "Values"
		local _arg0_4 = function(v)
			local _name = v.Name
			return not (table.find(IGNORED_METEOR, _name) ~= nil)
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue_4 = {}
		local _length_2 = 0
		for _k, _v in ipairs(worlds) do
			if _arg0_4(_v, _k - 1, worlds) == true then
				_length_2 += 1
				_newValue_4[_length_2] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local _arg0_5 = function(v)
			return v.Name
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue_5 = table.create(#_newValue_4)
		for _k, _v in ipairs(_newValue_4) do
			_newValue_5[_k] = _arg0_5(_v, _k - 1, _newValue_4)
		end
		-- ▲ ReadonlyArray.map ▲
		_object_2[_left_2] = _newValue_5
		_object_2.Multi = true
		_object_2.Text = "Ignore Worlds"
		_fn_2:AddDropdown("Farm_MeteorOption", _object_2)
		defenseTab:AddToggle("Farm_Meteor", {
			Text = "Defense Farm",
		})
		defenseTab:AddButton("Save Location", function()
			return true
		end):AddButton("Remove Location", function()
			return true
		end)
	end
	function FarmUI:updateTargetList()
		local currentEnemies = {}
		for _, enemy in ipairs(getEnemies(getCurrentWorld())) do
			if enemy.RaidBoss then
				continue
			end
			local _displayName = enemy.DisplayName
			table.insert(currentEnemies, _displayName)
		end
		local dropdown = hubController:getOption("Farm_TargetList")
		dropdown.Values = currentEnemies
		dropdown:SetValues()
	end
end
return {
	FarmUI = FarmUI,
}
 end, newEnv("Pombium.games.AFS.app.farm"))() end)

newModule("load", "ModuleScript", "Pombium.games.AFS.app.load", "Pombium.games.AFS.app", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local exports = {}
for _k, _v in pairs(TS.import(script, script.Parent, "farm") or {}) do
	exports[_k] = _v
end
return exports
 end, newEnv("Pombium.games.AFS.app.load"))() end)

newModule("constants", "ModuleScript", "Pombium.games.AFS.constants", "Pombium.games.AFS", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local IGNORED_WORLDS = { "Raid", "Tower", "Titan", "Halloween", "Christmas" }
local IGNORED_METEOR = { "Raid", "Tower" }
return {
	IGNORED_WORLDS = IGNORED_WORLDS,
	IGNORED_METEOR = IGNORED_METEOR,
}
 end, newEnv("Pombium.games.AFS.constants"))() end)

newInstance("controllers", "Folder", "Pombium.games.AFS.controllers", "Pombium.games.AFS")

newModule("character-controller", "ModuleScript", "Pombium.games.AFS.controllers.character-controller", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local player = Players.LocalPlayer
local CharacterController
do
	CharacterController = setmetatable({}, {
		__tostring = function()
			return "CharacterController"
		end,
	})
	CharacterController.__index = CharacterController
	function CharacterController.new(...)
		local self = setmetatable({}, CharacterController)
		return self:constructor(...) or self
	end
	function CharacterController:constructor()
		self._loadOrder = 1000000000
		self.ClassName = "Character"
	end
	function CharacterController:onInit()
	end
	function CharacterController:onStart()
	end
end
return {
	CharacterController = CharacterController,
}
 end, newEnv("Pombium.games.AFS.controllers.character-controller"))() end)

newModule("farm-controller", "ModuleScript", "Pombium.games.AFS.controllers.farm-controller", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local FarmController
do
	FarmController = setmetatable({}, {
		__tostring = function()
			return "FarmController"
		end,
	})
	FarmController.__index = FarmController
	function FarmController.new(...)
		local self = setmetatable({}, FarmController)
		return self:constructor(...) or self
	end
	function FarmController:constructor()
		self._loadOrder = 1
		self.ClassName = "Farm"
	end
	function FarmController:onInit()
	end
end
return {
	FarmController = FarmController,
}
 end, newEnv("Pombium.games.AFS.controllers.farm-controller"))() end)

newModule("load", "ModuleScript", "Pombium.games.AFS.controllers.load", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local exports = {}
for _k, _v in pairs(TS.import(script, script.Parent, "character-controller") or {}) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script.Parent, "speed-controller") or {}) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script.Parent, "farm-controller") or {}) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script.Parent, "maingui-controller") or {}) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script.Parent, "summon-controller") or {}) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script.Parent, "miscellaneous-controller") or {}) do
	exports[_k] = _v
end
return exports
 end, newEnv("Pombium.games.AFS.controllers.load"))() end)

newModule("maingui-controller", "ModuleScript", "Pombium.games.AFS.controllers.maingui-controller", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local MainGui = playerGui:WaitForChild("MainGui")
local MainGuiHandler = MainGui:WaitForChild("Scripts"):WaitForChild("MainGuiHandler")
local MainGuiController
do
	MainGuiController = setmetatable({}, {
		__tostring = function()
			return "MainGuiController"
		end,
	})
	MainGuiController.__index = MainGuiController
	function MainGuiController.new(...)
		local self = setmetatable({}, MainGuiController)
		return self:constructor(...) or self
	end
	function MainGuiController:constructor()
		self._loadOrder = 1
		self.ClassName = "MainGui"
		self.windowFunctions = {}
	end
	function MainGuiController:onInit()
		local WindowHandler = require(MainGuiHandler:WaitForChild("WindowHandler"))
		for _, value in ipairs(getupvalues(WindowHandler.UnregisterWindow)) do
			if type(value) ~= "table" then
				continue
			end
			local windowFunction = value.YenShop
			if windowFunction and windowFunction.Open then
				for name, functions in pairs(value) do
					self.windowFunctions[name] = functions
				end
				break
			end
		end
	end
	function MainGuiController:onStart()
	end
end
return {
	MainGuiController = MainGuiController,
}
 end, newEnv("Pombium.games.AFS.controllers.maingui-controller"))() end)

newModule("miscellaneous-controller", "ModuleScript", "Pombium.games.AFS.controllers.miscellaneous-controller", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Fleet = TS.import(script, script.Parent.Parent.Parent.Parent, "utils", "fleet").default
local player = Players.LocalPlayer
local hubController
local MiscController
do
	MiscController = setmetatable({}, {
		__tostring = function()
			return "MiscController"
		end,
	})
	MiscController.__index = MiscController
	function MiscController.new(...)
		local self = setmetatable({}, MiscController)
		return self:constructor(...) or self
	end
	function MiscController:constructor()
		self._loadOrder = 1
		self.ClassName = "Misc"
	end
	function MiscController:onInit()
	end
	function MiscController:onStart()
		hubController = Fleet.getDependency("Hub")
	end
end
return {
	MiscController = MiscController,
}
 end, newEnv("Pombium.games.AFS.controllers.miscellaneous-controller"))() end)

newModule("speed-controller", "ModuleScript", "Pombium.games.AFS.controllers.speed-controller", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local ReplicatedStorage = TS.import(script, TS.getModule(script, "@rbxts", "services")).ReplicatedStorage
local createHook = TS.import(script, script.Parent.Parent.Parent.Parent, "utils", "createHook").default
local Fleet = TS.import(script, script.Parent.Parent.Parent.Parent, "utils", "fleet").default
local moduleScripts = ReplicatedStorage:WaitForChild("ModuleScripts")
local passiveListModule = moduleScripts:WaitForChild("PassiveStats")
local hasPassiveModule = moduleScripts:WaitForChild("HasPassive")
local passiveList = require(passiveListModule)
local hasPassive = require(hasPassiveModule)
local hubController
local SpeedController
do
	SpeedController = setmetatable({}, {
		__tostring = function()
			return "SpeedController"
		end,
	})
	SpeedController.__index = SpeedController
	function SpeedController.new(...)
		local self = setmetatable({}, SpeedController)
		return self:constructor(...) or self
	end
	function SpeedController:constructor()
		self._loadOrder = 1
		self.ClassName = "Speed"
		self.EFFECTS = {}
	end
	function SpeedController:onInit()
		hubController = Fleet.getDependency("Hub")
		local unitSlider = hubController:getOption("Farm_Speed")
		print(hubController, unitSlider)
		passiveList.H4x = {
			Image = "rbxassetid://3560280048",
			DisplayName = "You're Cheating?!",
			Description = "How did you get this!?\n\n\n- Pombium <3",
			Chance = 0,
			Hidden = false,
			Effects = self.EFFECTS,
		}
		unitSlider:OnChanged(function()
			self.EFFECTS.Speed = unitSlider.Value
		end)
		local original, hook = createHook(hasPassive.ForPassiveList)
		hook(function(passives, ...)
			local args = { ... }
			if unitSlider.Value >= 1 and not (table.find(passives, "H4x") ~= nil) then
				table.insert(passives, "H4x")
			end
			return original(passives, ...)
		end)
	end
end
return {
	SpeedController = SpeedController,
}
 end, newEnv("Pombium.games.AFS.controllers.speed-controller"))() end)

newModule("summon-controller", "ModuleScript", "Pombium.games.AFS.controllers.summon-controller", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local Fleet = TS.import(script, script.Parent.Parent.Parent.Parent, "utils", "fleet").default
local player = Players.LocalPlayer
local hubController
local PetController
do
	PetController = setmetatable({}, {
		__tostring = function()
			return "PetController"
		end,
	})
	PetController.__index = PetController
	function PetController.new(...)
		local self = setmetatable({}, PetController)
		return self:constructor(...) or self
	end
	function PetController:constructor()
		self._loadOrder = 1
		self.ClassName = "Pet"
	end
	function PetController:onInit()
	end
	function PetController:onStart()
		hubController = Fleet.getDependency("Hub")
	end
end
return {
	PetController = PetController,
}
 end, newEnv("Pombium.games.AFS.controllers.summon-controller"))() end)

newModule("tower-controller", "ModuleScript", "Pombium.games.AFS.controllers.tower-controller", "Pombium.games.AFS.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TowerController
do
	TowerController = setmetatable({}, {
		__tostring = function()
			return "TowerController"
		end,
	})
	TowerController.__index = TowerController
	function TowerController.new(...)
		local self = setmetatable({}, TowerController)
		return self:constructor(...) or self
	end
	function TowerController:constructor()
		self._loadOrder = 1
		self.ClassName = "Tower"
	end
	function TowerController:onInit()
	end
end
return {
	TowerController = TowerController,
}
 end, newEnv("Pombium.games.AFS.controllers.tower-controller"))() end)

newInstance("types", "Folder", "Pombium.games.AFS.types", "Pombium.games.AFS")

newInstance("utils", "Folder", "Pombium.games.AFS.utils", "Pombium.games.AFS")

newModule("datastore", "ModuleScript", "Pombium.games.AFS.utils.datastore", "Pombium.games.AFS.utils", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local ReplicatedStorage = TS.import(script, TS.getModule(script, "@rbxts", "services")).ReplicatedStorage
local moduleScripts = ReplicatedStorage:WaitForChild("ModuleScripts")
local dairebModule = moduleScripts:WaitForChild("WorldData")
local dairebStore = require(dairebModule)
local function getData()
	for _, value in ipairs(getupvalues(dairebStore.GetData)) do
		if type(value) == "table" then
			local gameData = value.GameData
			if gameData then
				return gameData
			end
		end
	end
end
return {
	getData = getData,
}
 end, newEnv("Pombium.games.AFS.utils.datastore"))() end)

newModule("enemy-utils", "ModuleScript", "Pombium.games.AFS.utils.enemy-utils", "Pombium.games.AFS.utils", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local ReplicatedStorage = TS.import(script, TS.getModule(script, "@rbxts", "services")).ReplicatedStorage
local moduleScripts = ReplicatedStorage:WaitForChild("ModuleScripts")
local enemyModule = moduleScripts:WaitForChild("EnemyStats")
local enemyStats = require(enemyModule)
local enemyData = {}
for name, data in pairs(enemyStats) do
	data.Name = name
	local _value = data.Homeworld
	if _value ~= "" and _value then
		local world = enemyData[data.Homeworld]
		if not world then
			world = {}
			enemyData[data.Homeworld] = world
		end
		world[name] = data
	end
end
local function getEnemies(world)
	local worldEnemies = enemyData[world]
	if not worldEnemies then
		return {}
	end
	local enemies = {}
	for _, info in pairs(worldEnemies) do
		table.insert(enemies, info)
	end
	local _arg0 = function(a, b)
		return a.Health < b.Health
	end
	table.sort(enemies, _arg0)
	return enemies
end
return {
	getEnemies = getEnemies,
}
 end, newEnv("Pombium.games.AFS.utils.enemy-utils"))() end)

newModule("world-utils", "ModuleScript", "Pombium.games.AFS.utils.world-utils", "Pombium.games.AFS.utils", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.Parent.Parent.include.RuntimeLib)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local ReplicatedStorage = _services.ReplicatedStorage
local Workspace = _services.Workspace
local worldValue = Players.LocalPlayer:WaitForChild("World")
local moduleScripts = ReplicatedStorage:WaitForChild("ModuleScripts")
local worldFolder = Workspace:WaitForChild("Worlds")
local worldModule = moduleScripts:WaitForChild("WorldData")
local worldData = require(worldModule)
for name, info in pairs(worldData) do
	info.Name = name
	if not info.NoDefense then
		local world = worldFolder:FindFirstChild(name)
		if world then
			local titanSummon = world:FindFirstChild("TitanSummon")
			if titanSummon then
				info.NoDefense = true
			else
				info.NoDefense = false
			end
		end
	end
end
local function getCurrentWorld()
	return worldValue.Value
end
local function getOrderedWorlds()
	local worlds = {}
	for _, info in pairs(worldData) do
		table.insert(worlds, info)
	end
	local _arg0 = function(a, b)
		return a.Price < b.Price
	end
	table.sort(worlds, _arg0)
	return worlds
end
return {
	getCurrentWorld = getCurrentWorld,
	getOrderedWorlds = getOrderedWorlds,
	worldValue = worldValue,
}
 end, newEnv("Pombium.games.AFS.utils.world-utils"))() end)