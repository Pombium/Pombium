local GameName
local games = {
	["AFS"] = {6299805723},
}

for name, ids in pairs(games) do
	if table.find(ids, game.PlaceId) then
		GameName = name
		break
	end
end

assert(GameName, "Game wasn't implemented yet!")
assert(getgenv, "Your exploit is not supported!")

local environment = getgenv();
assert(not environment["_POMBIUM_LOADED_"], "Pombium was already executed!")
environment["_POMBIUM_LOADED_"] = true;
environment.GameName = GameName;

local instanceFromId = {}
environment.instanceFromId = instanceFromId

local idFromInstance = {}
environment.idFromInstance = idFromInstance

local modules = {}
environment.modules = modules

local currentlyLoading = {}
environment.currentlyLoading = currentlyLoading

local function validateRequire(module, caller)
	currentlyLoading[caller] = module

	local currentModule = module
	local depth = 0

	if not modules[module] then
		while currentModule do
			depth = depth + 1
			currentModule = currentlyLoading[currentModule]

			if currentModule == module then
				local str = currentModule.Name

				for _ = 1, depth do
					currentModule = currentlyLoading[currentModule]
					str = str .. "  ⇒ " .. currentModule.Name
				end

				error("Failed to load '" .. module.Name .. "'; Detected a circular dependency chain: " .. str, 2)
			end
		end
	end

	return function ()
		if currentlyLoading[caller] == module then
			currentlyLoading[caller] = nil
		end
	end
end
environment.validateRequire = validateRequire

local function loadModule(obj, this)
	local cleanup = this and validateRequire(obj, this)
	local module = modules[obj]

	if module.isLoaded then
		if cleanup then
			cleanup()
		end
		return module.value
	else
		local data = module.fn()
		module.value = data
		module.isLoaded = true
		if cleanup then
			cleanup()
		end
		return data
	end
end
environment.loadModule = loadModule

local function requireModuleInternal(target, this)
	if modules[target] and target:IsA("ModuleScript") then
		return loadModule(target, this)
	else
		return require(target)
	end
end
environment.requireModuleInternal = requireModuleInternal

local function newEnv(id)
	return setmetatable({
		VERSION = "dev",
		script = instanceFromId[id],
		require = function (module)
			return requireModuleInternal(module, instanceFromId[id])
		end,
	}, {
		__index = getfenv(0),
		__metatable = "This metatable is locked",
	})
end
environment.newEnv = newEnv

local function newModule(name, className, path, parent, fn)
	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = instanceFromId[parent]

	instanceFromId[path] = instance
	idFromInstance[instance] = path

	modules[instance] = {
		fn = fn,
		isLoaded = false,
		value = nil,
	}
end
environment.newModule = newModule

local function newInstance(name, className, path, parent)
	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = instanceFromId[parent]

	instanceFromId[path] = instance
	idFromInstance[instance] = path
end
environment.newInstance = newInstance

local function init()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	loadstring(
		game:HttpGetAsync("https://raw.githubusercontent.com/Pombium/Pombium/master/games/".. GameName ..".lua")
	)()

	for object in pairs(modules) do
		if object:IsA("LocalScript") and not object.Disabled then
			task.spawn(loadModule, object)
		end
	end
end


newInstance("Pombium", "Folder", "Pombium", nil)

newInstance("controllers", "Folder", "Pombium.controllers", "Pombium")

newModule("hub-controller", "ModuleScript", "Pombium.controllers.hub-controller", "Pombium.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local Library = TS.import(script, script.Parent.Parent, "vendor", "linoria-ui").default
local HubController
do
	HubController = setmetatable({}, {
		__tostring = function()
			return "HubController"
		end,
	})
	HubController.__index = HubController
	function HubController.new(...)
		local self = setmetatable({}, HubController)
		return self:constructor(...) or self
	end
	function HubController:constructor()
		self._loadOrder = -1
		self.ClassName = "Hub"
		self.window = Library:CreateWindow({
			Title = "Pombiu | " .. GameName,
		})
		self.toggles = Library.Toggles
		self.options = Library.Options
	end
	function HubController:onInit()
		self.loadStart = os.clock()
		Library:Notify("Loading Pombium...", 5)
	end
	function HubController:onStart()
		Library:Notify("Pombium loaded in " .. (tostring((os.clock() - self.loadStart) * 1000) .. "ms"), 5)
		Library:Toggle()
	end
	function HubController:getWindow()
		return self.window
	end
	function HubController:getToggle(name)
		return self.toggles[name]
	end
	function HubController:getOption(name)
		return self.options[name]
	end
end
return {
	HubController = HubController,
}
 end, newEnv("Pombium.controllers.hub-controller"))() end)

newModule("load", "ModuleScript", "Pombium.controllers.load", "Pombium.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local exports = {}
for _k, _v in pairs(TS.import(script, script.Parent, "hub-controller") or {}) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script.Parent, "settings-controller") or {}) do
	exports[_k] = _v
end
return exports
 end, newEnv("Pombium.controllers.load"))() end)

newModule("settings-controller", "ModuleScript", "Pombium.controllers.settings-controller", "Pombium.controllers", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local Fleet = TS.import(script, script.Parent.Parent, "utils", "fleet").default
local Library = TS.import(script, script.Parent.Parent, "vendor", "linoria-ui").default
local SaveManager = TS.import(script, script.Parent.Parent, "vendor", "save-manager").default
local ThemeManager = TS.import(script, script.Parent.Parent, "vendor", "theme-manager").default
local renderStepped = RunService.RenderStepped
local hubController
local SettingsController
do
	SettingsController = setmetatable({}, {
		__tostring = function()
			return "SettingsController"
		end,
	})
	SettingsController.__index = SettingsController
	function SettingsController.new(...)
		local self = setmetatable({}, SettingsController)
		return self:constructor(...) or self
	end
	function SettingsController:constructor()
		self._loadOrder = 1e+128
		self.ClassName = "Settings"
		self.path = "Pombium"
		self.saveManager = SaveManager
		self.themeManager = ThemeManager
	end
	function SettingsController:onInit()
		hubController = Fleet.getDependency("Hub")
		self.settingsTab = hubController:getWindow():AddTab("Settings")
		self.saveManager:SetLibrary(Library)
		self.themeManager:SetLibrary(Library)
		self.saveManager:SetFolder(self.path .. ("/" .. GameName))
		self.themeManager:SetFolder(self.path)
		self.saveManager:IgnoreThemeSettings()
		self.saveManager:BuildConfigSection(self.settingsTab)
		self.themeManager:ApplyToTab(self.settingsTab)
	end
	function SettingsController:onStart()
		self.saveManager:LoadAutoloadConfig()
		local window = hubController:getWindow()
		local menuGroup = self.settingsTab:AddRightGroupbox("Menu")
		menuGroup:AddLabel("Menu Toggle"):AddKeyPicker("MenuKeybind", {
			Default = "F6",
			NoUI = true,
			Text = "Menu keybind",
		})
		menuGroup:AddButton("Unload", function()
			task.defer(function()
				return Library:Unload()
			end)
		end)
		Library.ToggleKeybind = hubController:getOption("MenuKeybind")
		local _signals = Library.Signals
		local _arg0 = renderStepped:Connect(function()
			if Library.Toggles.RainbowToggle.Value then
				local registry = window.Holder and Library.Registry or Library.HudRegistry
				local _arg0_1 = function(object)
					for property, colorIndex in pairs(object.Properties) do
						if colorIndex == "AccentColor" or colorIndex == "AccentColorDark" then
							local instance = object.Instance
							local yPos = instance.AbsolutePosition.Y
							local mapped = Library:MapValue(yPos, 0, 1080, 0, 0.5) * 1.5
							local color = Color3.fromHSV((Library.CurrentRainbowHue - mapped) % 1, 0.8, 1)
							if colorIndex == "AccentColorDark" then
								color = Library:GetDarkerColor(color)
							end
							instance[property] = color
						end
					end
				end
				for _k, _v in ipairs(registry) do
					_arg0_1(_v, _k - 1, registry)
				end
			end
		end)
		table.insert(_signals, _arg0)
	end
	function SettingsController:getSaveManager()
		return self.saveManager
	end
	function SettingsController:getThemeManager()
		return self.themeManager
	end
end
return {
	SettingsController = SettingsController,
}
 end, newEnv("Pombium.controllers.settings-controller"))() end)

newInstance("games", "Folder", "Pombium.games", "Pombium")

newModule("runtime", "LocalScript", "Pombium.runtime", "Pombium", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.include.RuntimeLib)
local _log = TS.import(script, TS.getModule(script, "@rbxts", "log").out)
local Log = _log.default
local Logger = _log.Logger
local LogLevel = _log.LogLevel
local services = TS.import(script, script.Parent, "controllers", "load")
local loadMethods = TS.import(script, script.Parent, "set-methods").default
local Fleet = TS.import(script, script.Parent, "utils", "fleet").default
local ts = TS.import(script, script.Parent, "vendor", "ts-thing").default
Log.SetLogger(Logger:configure():SetMinLogLevel(LogLevel.Information):EnrichWithProperty("Version", VERSION):WriteTo(Log.RobloxOutput({
	TagFormat = "full",
})):Create())
local main = TS.async(function()
	loadMethods()
	for _, service in pairs(services) do
		Fleet.register(service)
	end
end)
local _exp = main()
local _arg0 = function()
	ts.getModule(script, script.Parent, "games", GameName)
end
_exp:andThen(_arg0):catch(function(err)
	Log.Warn("Pombium failed to load:\n{err}", err)
end)
 end, newEnv("Pombium.runtime"))() end)

newModule("set-methods", "ModuleScript", "Pombium.set-methods", "Pombium", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.include.RuntimeLib)
local ScriptContext = TS.import(script, TS.getModule(script, "@rbxts", "services")).ScriptContext
local _protect_instance = TS.import(script, script.Parent, "vendor", "protect-instance")
local protectInstance = _protect_instance.protectInstance
local unprotectInstance = _protect_instance.unprotectInstance
local function loadMethods()
	assert(getgenv, "Your exploit is not supported")
	local environment = getgenv()
	local globalMethods = {
		checkCaller = checkcaller or check_caller,
		newCClosure = newcclosure,
		hookFunction = HookFunction or (hookfunction or (hook_function or detour_function)),
		getGc = getgc or get_gc_objects,
		getInfo = debug.getinfo or getinfo,
		getSenv = getsenv,
		getMenv = getmenv or getsenv,
		getContext = getthreadcontext or (get_thread_context or (syn and syn.get_thread_identity)),
		getConnections = get_signal_cons or (get_connection or getconnections),
		getScriptClosure = getscriptclosure or get_script_function,
		getNamecallMethod = getnamecallmethod or get_namecall_method,
		getCallingScript = getcallingscript or get_calling_script,
		getLoadedModules = getloadedmodules or get_loaded_modules,
		getConstants = debug.getconstants or (getconstants or getconsts),
		getUpvalues = debug.getupvalues or (getupvalues or getupvals),
		getProtos = debug.getprotos or getprotos,
		getStack = debug.getstack or getstack,
		getConstant = debug.getconstant or (getconstant or getconst),
		getUpvalue = debug.getupvalue or (getupvalue or getupval),
		getProto = debug.getproto or getproto,
		getMetatable = getrawmetatable or debug.getmetatable,
		getHui = get_hidden_gui or gethui,
		protectInstance = protectInstance,
		unprotectInstance = unprotectInstance,
		setClipboard = setclipboard or writeclipboard,
		setConstant = debug.setconstant or (setconstant or setconst),
		setContext = setthreadcontext or (set_thread_context or (syn and syn.set_thread_identity)),
		setUpvalue = debug.setupvalue or (setupvalue or setupval),
		setStack = debug.setstack or setstack,
		setReadOnly = setreadonly or (make_writeable and function(t, readonly)
			if readonly ~= 0 and (readonly == readonly and (readonly ~= "" and readonly)) then
				make_readonly(t)
			else
				make_writeable(t)
			end
		end),
		isLClosure = islclosure or (is_l_closure or (iscclosure and function(closure)
			return not iscclosure(closure)
		end)),
		isReadOnly = isreadonly or is_readonly,
		isXClosure = is_synapse_function or (issentinelclosure or (is_protosmasher_closure or (is_sirhurt_closure or (iselectronfunction or (istempleclosure or checkclosure))))),
		hookMetaMethod = hookmetamethod or (hookfunction and function(object, method, hook)
			return hookfunction(getMetatable(object)[method], hook)
		end),
		readFile = readfile,
		writeFile = writefile,
		makeFolder = makefolder,
		isFolder = isfolder,
		isFile = isfile,
	}
	for method, func in pairs(globalMethods) do
		local _value = environment[method]
		if not (_value ~= 0 and (_value == _value and (_value ~= "" and _value))) then
			environment[method] = func
		end
	end
	if getConnections then
		for _, connection in ipairs(getConnections(ScriptContext.Error)) do
			local conn = getMetatable(connection)
			local old = conn and conn.__index
			setReadOnly(conn, false)
			if old then
				conn.__index = newCClosure(function(t, k)
					if k == "Connected" then
						return nil
					end
					return old(t, k)
				end)
			end
			setReadOnly(conn, true)
			connection:Disable()
		end
	end
	return environment
end
local default = loadMethods
return {
	default = default,
}
 end, newEnv("Pombium.set-methods"))() end)

newInstance("utils", "Folder", "Pombium.utils", "Pombium")

newModule("createHook", "ModuleScript", "Pombium.utils.createHook", "Pombium.utils", function () return setfenv(function() local env = getgenv()
env.__hooks = __hooks or {}

local function createHook(fn)
	local function proxy(...)
		local this = debug.info(1, "f")
		local hook = __hooks[this]

		return (hook.replacement or hook.original)(...)
	end

	local original = hookFunction(fn, proxy)

	local hook = {
		fn = fn,
		original = original,
		replacement = nil,
	}

	__hooks[fn] = hook
	__hooks[proxy] = hook

	return original, function (replacement)
		hook.replacement = replacement
	end
end

return {
	default = createHook
} end, newEnv("Pombium.utils.createHook"))() end)

newModule("fleet", "ModuleScript", "Pombium.utils.fleet", "Pombium.utils", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local sortPriority = function(a, b)
	return a._loadOrder < b._loadOrder
end
local Fleet = {}
do
	local _container = Fleet
	local fleetArray = {}
	_container.fleetArray = fleetArray
	local tickArray = {}
	_container.tickArray = tickArray
	local stepArray = {}
	_container.stepArray = stepArray
	local started = false
	local register = function(fleetClass)
		local _arg0 = not started
		assert(_arg0, "Cannot register class after Fleet started")
		local controller = fleetClass.new()
		local _arg0_1 = not (table.find(fleetArray, controller) ~= nil)
		local _arg1 = "Class " .. (controller.ClassName .. " already exists")
		assert(_arg0_1, _arg1)
		table.insert(fleetArray, controller)
		return controller
	end
	_container.register = register
	local function getDependency(name)
		local service
		for _, fleetClass in ipairs(fleetArray) do
			if fleetClass.ClassName == name then
				service = fleetClass
			end
		end
		return service
	end
	_container.getDependency = getDependency
	local fire = TS.async(function()
		if started then
			error("Fleet already started")
		end
		started = true
		table.sort(fleetArray, sortPriority)
		local _promise = TS.Promise.new(function(resolve)
			local startServicePromises = {}
			local _arg0 = function(controller)
				if controller.onInit ~= nil then
					local _promise_1 = TS.Promise.new(function(r)
						print("Initializing " .. controller.ClassName)
						controller:onInit()
						print(controller.ClassName .. " Initiated")
						r()
					end)
					table.insert(startServicePromises, _promise_1)
				end
			end
			for _k, _v in ipairs(fleetArray) do
				_arg0(_v, _k - 1, fleetArray)
			end
			resolve(TS.Promise.all(startServicePromises))
		end)
		local _arg0 = function()
			local _arg0_1 = function(controller)
				if controller.onStart ~= nil then
					print("Starting " .. controller.ClassName)
					task.defer(function()
						controller:onStart()
						print(controller.ClassName .. " Started")
					end)
				end
				if controller.onTick ~= nil then
					table.insert(tickArray, controller)
				end
				if controller.onStep ~= nil then
					table.insert(stepArray, controller)
				end
			end
			for _k, _v in ipairs(fleetArray) do
				_arg0_1(_v, _k - 1, fleetArray)
			end
			RunService.Heartbeat:Connect(function()
				for _, controller in ipairs(tickArray) do
					if controller.onTick ~= nil then
						task.spawn(function()
							return controller:onTick()
						end)
					end
				end
			end)
			RunService.RenderStepped:Connect(function()
				for _, controller in ipairs(stepArray) do
					if controller.onStep ~= nil then
						task.spawn(function()
							return controller:onStep()
						end)
					end
				end
			end)
		end
		return _promise:andThen(_arg0)
	end)
	_container.fire = fire
end
local default = Fleet
return {
	default = default,
}
 end, newEnv("Pombium.utils.fleet"))() end)

newInstance("vendor", "Folder", "Pombium.vendor", "Pombium")

newModule("linoria-ui", "ModuleScript", "Pombium.vendor.linoria-ui", "Pombium.vendor", function () return setfenv(function() local InputService = game:GetService('UserInputService');
local TextService = game:GetService('TextService');
local TweenService = game:GetService('TweenService');
local CoreGui = game:GetService('CoreGui');
local RunService = game:GetService('RunService')
local RenderStepped = RunService.RenderStepped;
local LocalPlayer = game:GetService('Players').LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

local ScreenGui = Instance.new('ScreenGui');
ProtectGui(ScreenGui);

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
ScreenGui.Parent = CoreGui;

local Toggles = {};
local Options = {};

getgenv().Toggles = Toggles;
getgenv().Options = Options;

local Library = {
    Registry = {};
    RegistryMap = {};

    HudRegistry = {};
    Toggles = Toggles;
    Options = Options;
    
    FontColor = Color3.fromRGB(255, 255, 255);
    MainColor = Color3.fromRGB(28, 28, 28);
    BackgroundColor = Color3.fromRGB(20, 20, 20);
    AccentColor = Color3.fromRGB(0, 85, 255);
    OutlineColor = Color3.fromRGB(50, 50, 50);

    Black = Color3.new(0, 0, 0);

    OpenedFrames = {};
	CurrentRainbowHue = 0;
	CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1);

    Signals = {};
    ScreenGui = ScreenGui;
};

local RainbowStep = 0
local Hue = 0

table.insert(Library.Signals, RenderStepped:Connect(function(Delta)
    RainbowStep = RainbowStep + Delta

    if RainbowStep >= (1 / 60) then
        RainbowStep = 0

        Hue = Hue + (1 / 400);

        if Hue > 1 then
            Hue = 0;
        end;

        Library.CurrentRainbowHue = Hue;
        Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1);
    end
end))

function Library:AttemptSave()
    if Library.SaveManager then
        Library.SaveManager:Save();
    end;
end;

function Library:Create(Class, Properties)
    local _Instance = Class;

    if type(Class) == 'string' then
        _Instance = Instance.new(Class);
    end;

    for Property, Value in next, Properties do
        _Instance[Property] = Value;
    end;

    return _Instance;
end;

function Library:CreateLabel(Properties, IsHud)
    local _Instance = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Enum.Font.Code;
        TextColor3 = Library.FontColor;
        TextSize = 16;
        TextStrokeTransparency = 0;
    });

    Library:AddToRegistry(_Instance, {
        TextColor3 = 'FontColor';
    }, IsHud);

    return Library:Create(_Instance, Properties);
end;

function Library:MakeDraggable(Instance, Cutoff)
    Instance.Active = true;

   Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ObjPos = Vector2.new(
                Mouse.X - Instance.AbsolutePosition.X,
                Mouse.Y - Instance.AbsolutePosition.Y
            );

            if ObjPos.Y > (Cutoff or 40) then
                return;
            end;

            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                Instance.Position = UDim2.new(
                    0,
                    Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                    0,
                    Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                );

                RenderStepped:Wait();
            end;
        end;
    end)
end;

function Library:AddToolTip(InfoStr, HoverInstance)
    local X, Y = Library:GetTextBounds(InfoStr, Enum.Font.Code, 14);
    local Tooltip = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor,        
        BorderColor3 = Library.OutlineColor,

        Size = UDim2.fromOffset(X + 5, Y + 4),
        ZIndex = 11;
        Parent = Library.ScreenGui,

        Visible = false,
    })

    local Label = Library:CreateLabel({
        Position = UDim2.fromOffset(3, 1),
        Size = UDim2.fromOffset(X, Y);
        TextSize = 14;
        Text = InfoStr,
        TextColor3 = Library.FontColor,
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 12;

        Parent = Tooltip;
    });

    Library:AddToRegistry(Tooltip, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    Library:AddToRegistry(Label, {
        TextColor3 = 'FontColor',
    });

    local IsHovering = false
    HoverInstance.MouseEnter:Connect(function()
        IsHovering = true
        
        Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        Tooltip.Visible = true

        while IsHovering do
            RunService.Heartbeat:Wait()
            Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        end
    end)

    HoverInstance.MouseLeave:Connect(function()
        IsHovering = false
        Tooltip.Visible = false
    end)
end

function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault)
    HighlightInstance.MouseEnter:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, Properties do
            Instance[Property] = Library[ColorIdx] or ColorIdx;

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)

    HighlightInstance.MouseLeave:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, PropertiesDefault do
            Instance[Property] = Library[ColorIdx] or ColorIdx;

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)
end;

function Library:MouseIsOverOpenedFrame()
    for Frame, _ in next, Library.OpenedFrames do
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

        if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
            and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

            return true;
        end;
    end;
end;

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
    return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
end;

function Library:GetTextBounds(Text, Font, Size, Resolution)
    local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
    return Bounds.X, Bounds.Y
end;

function Library:GetDarkerColor(Color)
    local H, S, V = Color3.toHSV(Color);
    return Color3.fromHSV(H, S, V / 1.5);
end; 
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);

function Library:AddToRegistry(Instance, Properties, IsHud)
    local Idx = #Library.Registry + 1;
    local Data = {
        Instance = Instance;
        Properties = Properties;
        Idx = Idx;
    };

    table.insert(Library.Registry, Data);
    Library.RegistryMap[Instance] = Data;

    if IsHud then
        table.insert(Library.HudRegistry, Data);
    end;
end;

function Library:RemoveFromRegistry(Instance)
    local Data = Library.RegistryMap[Instance];

    if Data then
        for Idx = #Library.Registry, 1, -1 do
            if Library.Registry[Idx] == Data then
                table.remove(Library.Registry, Idx);
            end;
        end;

        for Idx = #Library.HudRegistry, 1, -1 do
            if Library.HudRegistry[Idx] == Data then
                table.remove(Library.HudRegistry, Idx);
            end;
        end;

        Library.RegistryMap[Instance] = nil;
    end;
end;

function Library:UpdateColorsUsingRegistry()
    -- TODO: Could have an 'active' list of objects
    -- where the active list only contains Visible objects.

    -- IMPL: Could setup .Changed events on the AddToRegistry function
    -- that listens for the 'Visible' propert being changed.
    -- Visible: true => Add to active list, and call UpdateColors function
    -- Visible: false => Remove from active list.

    -- The above would be especially efficient for a rainbow menu color or live color-changing.

    for Idx, Object in next, Library.Registry do
        for Property, ColorIdx in next, Object.Properties do
            if type(ColorIdx) == 'string' then
                Object.Instance[Property] = Library[ColorIdx];
            elseif type(ColorIdx) == 'function' then
                Object.Instance[Property] = ColorIdx()
            end
        end;
    end;
end;

function Library:GiveSignal(Signal)
    -- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
    table.insert(Library.Signals, Signal)
end

function Library:Unload()
    -- Unload all of the signals
    for Idx = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Idx)
        Connection:Disconnect()
    end

     -- Call our unload callback, maybe to undo some hooks etc
    if Library.OnUnload then
        Library.OnUnload()
    end

    ScreenGui:Destroy()
end

function Library:OnUnload(Callback)
    Library.OnUnload = Callback
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
    if Library.RegistryMap[Instance] then
        Library:RemoveFromRegistry(Instance);
    end;
end))

local BaseAddons = {};

do
    local Funcs = {};

    function Funcs:AddColorPicker(Idx, Info)
        local ToggleLabel = self.TextLabel;
        local Container = self.Container;

        local ColorPicker = {
            Value = Info.Default;
            Type = 'ColorPicker';
            Title = type(Info.Title) == 'string' and Info.Title or 'Color picker',
        };

        function ColorPicker:SetHSVFromRGB(Color)
            local H, S, V = Color3.toHSV(Color);

            ColorPicker.Hue = H;
            ColorPicker.Sat = S;
            ColorPicker.Vib = V;
        end;

        ColorPicker:SetHSVFromRGB(ColorPicker.Value);

        local DisplayFrame = Library:Create('Frame', {
            BackgroundColor3 = ColorPicker.Value;
            BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(0, 28, 0, 14);
            ZIndex = 6;
            Parent = ToggleLabel;
        });

        local RelativeOffset = 0;

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA('UIListLayout') then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
            end;
        end;

        local PickerFrameOuter = Library:Create('Frame', {
            Name = 'Color';
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 4, 0, 20 + RelativeOffset + 1);
            Size = UDim2.new(1, -13, 0, 253);
            Visible = false;
            ZIndex = 15;
            Parent = Container.Parent;
        });

        local PickerFrameInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 16;
            Parent = PickerFrameOuter;
        });

        local Highlight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 2);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 4, 0, 25);
            Size = UDim2.new(0, 200, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = SatVibMapOuter;
        });

        local SatVibMap = Library:Create('ImageLabel', {
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Image = 'rbxassetid://4155801252';
            Parent = SatVibMapInner;
        });

        local HueSelectorOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 208, 0, 25);
            Size = UDim2.new(0, 15, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local HueSelectorInner = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = HueSelectorOuter;
        });

        local HueTextSize = Library:GetTextBounds('Hex color', Enum.Font.Code, 16) + 3
        local RgbTextSize = Library:GetTextBounds('255, 255, 255', Enum.Font.Code, 16) + 3

        local HueBoxOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(4, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            ZIndex = 18,
            Parent = PickerFrameInner;
        });

        local HueBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18,
            Parent = HueBoxOuter;
        });

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = HueBoxInner;
        });

        local HueBox = Library:Create('TextBox', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            Font = Enum.Font.Code;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = 'Hex color',
            Text = '#FFFFFF',
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 20,
            Parent = HueBoxInner;
        });

        local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
            Position = UDim2.new(0.5, 2, 0, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            Parent = PickerFrameInner
        })  

        local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild('TextBox'), {
            Text = '255, 255, 255',
            PlaceholderText = 'RGB color',
            TextColor3 = Library.FontColor,
        })

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 14);
            Position = UDim2.fromOffset(5, 5);
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            Text = ColorPicker.Title,--Info.Default;
            TextWrapped = false;
            ZIndex = 16;
            Parent = PickerFrameInner;
        });


        Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(Highlight, { BackgroundColor3 = 'AccentColor'; });
        Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });

        Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBox, { TextColor3 = 'FontColor', });
        Library:AddToRegistry(HueBox, { TextColor3 = 'FontColor', });

        local SequenceTable = {};

        for Hue = 0, 1, 0.1 do
            table.insert(SequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)));
        end;

        local HueSelectorGradient = Library:Create('UIGradient', {
            Color = ColorSequence.new(SequenceTable);
            Rotation = 90;
            Parent = HueSelectorInner;
        });
        
        HueBox.FocusLost:Connect(function(enter)
            if enter then
                local success, result = pcall(Color3.fromHex, HueBox.Text)
                if success and typeof(result) == 'Color3' then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
                end
            end

            ColorPicker:Display()
        end)

        RgbBox.FocusLost:Connect(function(enter)
            if enter then
                local r, g, b = RgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                if r and g and b then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(Color3.fromRGB(r, g, b))
                end
            end

            ColorPicker:Display()
        end)

        function ColorPicker:Display()
            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib);
            SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1);

            Library:Create(DisplayFrame, {
                BackgroundColor3 = ColorPicker.Value;
                BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            });

            HueBox.Text = '#' .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', ')

            if ColorPicker.Changed then
                ColorPicker.Changed();
            end;
        end;

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func;
            Func();
        end;

        function ColorPicker:Show()
            for Frame, Val in next, Library.OpenedFrames do
                if Frame.Name == 'Color' then
                    Frame.Visible = false;
                    Library.OpenedFrames[Frame] = nil;
                end;
            end;

            PickerFrameOuter.Visible = true;
            Library.OpenedFrames[PickerFrameOuter] = true;
        end;

        function ColorPicker:Hide()
            PickerFrameOuter.Visible = false;
            Library.OpenedFrames[PickerFrameOuter] = nil;
        end;

        function ColorPicker:SetValue(HSV)
            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3]);

            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        function ColorPicker:SetValueRGB(Color)
            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        SatVibMap.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinX = SatVibMap.AbsolutePosition.X;
                    local MaxX = MinX + SatVibMap.AbsoluteSize.X;
                    local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                    local MinY = SatVibMap.AbsolutePosition.Y;
                    local MaxY = MinY + SatVibMap.AbsoluteSize.Y;
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                    ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX);
                    ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        HueSelectorInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinY = HueSelectorInner.AbsolutePosition.Y;
                    local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y;
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                    ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        DisplayFrame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if PickerFrameOuter.Visible then
                    ColorPicker:Hide();
                else
                    ColorPicker:Show();
                end;
            end;
        end);

        Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ColorPicker:Hide();
                end;
            end;
        end))

        ColorPicker:Display();

        Options[Idx] = ColorPicker;

        return self;
    end;

    function Funcs:AddKeyPicker(Idx, Info)
        local ParentObj = self;
        local ToggleLabel = self.TextLabel;
        local Container = self.Container;

        local KeyPicker = {
            Value = Info.Default;
            Toggled = false;
            Mode = Info.Mode or 'Toggle'; -- Always, Toggle, Hold
            Type = 'KeyPicker';

            SyncToggleState = Info.SyncToggleState or false;
        };

        if KeyPicker.SyncToggleState then
            Info.Modes = { 'Toggle' }
            Info.Mode = 'Toggle'
        end

        local RelativeOffset = 0;

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA('UIListLayout') then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
            end;
        end;

        local PickOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 28, 0, 15);
            ZIndex = 6;
            Parent = ToggleLabel;
        });

        local PickInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 7;
            Parent = PickOuter;
        });

        Library:AddToRegistry(PickInner, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 13;
            Text = Info.Default;
            TextWrapped = true;
            ZIndex = 8;
            Parent = PickInner;
        });

        local ModeSelectOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(1, 0, 0, RelativeOffset + 1);
            Size = UDim2.new(0, 60, 0, 45 + 2);
            Visible = false;
            ZIndex = 14;
            Parent = Container.Parent;
        });

        local ModeSelectInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 15;
            Parent = ModeSelectOuter;
        });

        Library:AddToRegistry(ModeSelectInner, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ModeSelectInner;
        });

        local ContainerLabel = Library:CreateLabel({
            TextXAlignment = Enum.TextXAlignment.Left;
            Size = UDim2.new(1, 0, 0, 18);
            TextSize = 13;
            Visible = false;
            ZIndex = 110;
            Parent = Library.KeybindContainer;
        },  true);

        local Modes = Info.Modes or { 'Always', 'Toggle', 'Hold' };
        local ModeButtons = {};

        for Idx, Mode in next, Modes do
            local ModeButton = {};

            local Label = Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 15);
                TextSize = 13;
                Text = Mode;
                ZIndex = 16;
                Parent = ModeSelectInner;
            });

            function ModeButton:Select()
                for _, Button in next, ModeButtons do
                    Button:Deselect();
                end;

                KeyPicker.Mode = Mode;

                Label.TextColor3 = Library.AccentColor;
                Library.RegistryMap[Label].Properties.TextColor3 = 'AccentColor';

                ModeSelectOuter.Visible = false;
            end;

            function ModeButton:Deselect()
                KeyPicker.Mode = nil;

                Label.TextColor3 = Library.FontColor;
                Library.RegistryMap[Label].Properties.TextColor3 = 'FontColor';
            end;

            Label.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    ModeButton:Select();
                    Library:AttemptSave();
                end;
            end);

            if Mode == KeyPicker.Mode then
                ModeButton:Select();
            end;

            ModeButtons[Mode] = ModeButton;
        end;

        function KeyPicker:Update()
            if Info.NoUI then
                return;
            end;

            local State = KeyPicker:GetState();

            ContainerLabel.Text = string.format('[%s] %s (%s)', KeyPicker.Value, Info.Text, KeyPicker.Mode);

            ContainerLabel.Visible = true;
            ContainerLabel.TextColor3 = State and Library.AccentColor or Library.FontColor;

            Library.RegistryMap[ContainerLabel].Properties.TextColor3 = State and 'AccentColor' or 'FontColor';

            local YSize = 0
            local XSize = 0
            
            for _, Label in next, Library.KeybindContainer:GetChildren() do
                if Label:IsA('TextLabel') and Label.Visible then
                    YSize = YSize + 18;
                    if (Label.TextBounds.X > XSize) then
                        XSize = Label.TextBounds.X 
                    end 
                end;
            end;

            Library.KeybindFrame.Size = UDim2.new(0, math.max(XSize + 10, 210), 0, YSize + 23)
        end;

        function KeyPicker:GetState()
            if KeyPicker.Mode == 'Always' then
                return true;
            elseif KeyPicker.Mode == 'Hold' then
                local Key = KeyPicker.Value;

                if Key == 'MB1' or Key == 'MB2' then
                    return Key == 'MB1' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                        or Key == 'MB2' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2);
                else
                    return InputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value]);
                end;
            else
                return KeyPicker.Toggled;
            end;
        end;

        function KeyPicker:SetValue(Data)
            local Key, Mode = Data[1], Data[2];
            DisplayLabel.Text = Key;
            KeyPicker.Value = Key;
            ModeButtons[Mode]:Select();
            KeyPicker:Update();
        end;

        function KeyPicker:OnClick(Callback)
            KeyPicker.Clicked = Callback
        end


        if ParentObj.Addons then
            table.insert(ParentObj.Addons, KeyPicker)
        end

        function KeyPicker:DoClick()
            if ParentObj.Type == 'Toggle' and KeyPicker.SyncToggleState then
                ParentObj:SetValue(not ParentObj.Value)
            end

            if KeyPicker.Clicked then
                KeyPicker.Clicked()
            end
        end

        local Picking = false;

        PickOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Picking = true;

                DisplayLabel.Text = '';

                local Break;
                local Text = '';

                task.spawn(function()
                    while (not Break) do
                        if Text == '...' then
                            Text = '';
                        end;

                        Text = Text .. '.';
                        DisplayLabel.Text = Text;

                        wait(0.4);
                    end;
                end);

                wait(0.2);

                local Event;
                Event = InputService.InputBegan:Connect(function(Input)
                    local Key;

                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = Input.KeyCode.Name;
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Key = 'MB1';
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                        Key = 'MB2';
                    end;

                    Break = true;
                    Picking = false;

                    DisplayLabel.Text = Key;
                    KeyPicker.Value = Key;

                    Library:AttemptSave();

                    Event:Disconnect();
                end);
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                ModeSelectOuter.Visible = true;
            end;
        end);

        Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if (not Picking) then
                if KeyPicker.Mode == 'Toggle' then
                    local Key = KeyPicker.Value;

                    if Key == 'MB1' or Key == 'MB2' then
                        if Key == 'MB1' and Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Key == 'MB2' and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeyPicker.Toggled = not KeyPicker.Toggled
                            KeyPicker:DoClick()
                        end;
                    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode.Name == Key then
                            KeyPicker.Toggled = not KeyPicker.Toggled;
                            KeyPicker:DoClick()
                        end;
                    end;
                end;

                KeyPicker:Update();
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ModeSelectOuter.Visible = false;
                end;
            end;
        end))

        Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
            if (not Picking) then
                KeyPicker:Update();
            end;
        end))

        KeyPicker:Update();

        Options[Idx] = KeyPicker;

        return self;
    end;

    BaseAddons.__index = Funcs;
    BaseAddons.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

local BaseGroupbox = {};

do
    local Funcs = {};

    function Funcs:AddBlank(Size)
        local Groupbox = self;
        local Container = Groupbox.Container;

        Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, Size);
            ZIndex = 1;
            Parent = Container;
        });
    end;

    function Funcs:AddLabel(Text, DoesWrap)
        local Label = {};

        local Groupbox = self;
        local Container = Groupbox.Container;

        local TextLabel = Library:CreateLabel({
            Size = UDim2.new(1, -4, 0, 15);
            TextSize = 14;
            Text = Text;
            TextWrapped = DoesWrap or false,
            RichText = true,
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        if DoesWrap then
            local Y = select(2, Library:GetTextBounds(Text, Enum.Font.Code, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
            TextLabel.Size = UDim2.new(1, -4, 0, Y)
        else
            Library:Create('UIListLayout', {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TextLabel;
            });
        end

        Label.TextLabel = TextLabel;
        Label.Container = Container;

        function Label:SetText(Text)
            TextLabel.Text = Text

            if DoesWrap then
                local Y = select(2, Library:GetTextBounds(Text, Enum.Font.Code, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                TextLabel.Size = UDim2.new(1, -4, 0, Y)
            end

            Groupbox:Resize();
        end

        if (not DoesWrap) then
            setmetatable(Label, BaseAddons);
        end

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        return Label;
    end;

    function Funcs:AddButton(Text, Func)
        local Button = {};

        local Groupbox = self;
        local Container = Groupbox.Container;

        local ButtonOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(ButtonOuter, {
            BorderColor3 = 'Black';
        });

        local ButtonInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = ButtonOuter;
        });

        Library:AddToRegistry(ButtonInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = ButtonInner;
        });

        local ButtonLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 14;
            Text = Text;
            ZIndex = 6;
            Parent = ButtonInner;
        });

        Library:OnHighlight(ButtonOuter, ButtonOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        ButtonOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Func();
            end;
        end);

        function Button:AddTooltip(tip)
            if type(tip) == 'string' then
                Library:AddToolTip(tip, ButtonOuter)
            end
            return Button
        end

        function Button:AddButton(Text, Func)
            local SubButton = {}

            ButtonOuter.Size = UDim2.new(0.5, -2, 0, 20)
            
            local Outer = ButtonOuter:Clone()
            local Inner = Outer.Frame;
            local Label = Inner:FindFirstChildWhichIsA('TextLabel')

            Outer.Position = UDim2.new(1, 2, 0, 0)
            Outer.Size = UDim2.fromOffset(ButtonOuter.AbsoluteSize.X - 2, ButtonOuter.AbsoluteSize.Y)
            Outer.Parent = ButtonOuter

            Label.Text = Text;

            Library:AddToRegistry(Inner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });
    
            Library:OnHighlight(Outer, Outer,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'Black' }
            )

            Library:Create('UIGradient', {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                });

                Rotation = 90;
                Parent = Inner;
            });

            Outer.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                    Func();
                end;
            end);

            function SubButton:AddTooltip(tip)
                if type(tip) == 'string' then
                    Library:AddToolTip(tip, Outer)
                end
                return SubButton
            end

            return SubButton
        end 

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        return Button;
    end;

    function Funcs:AddDivider()
        local Groupbox = self;
        local Container = self.Container

        local Divider = {
            Type = 'Divider',
        }

        Groupbox:AddBlank(2);
        local DividerOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 5);
            ZIndex = 5;
            Parent = Container;
        });

        local DividerInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DividerOuter;
        });

        Library:AddToRegistry(DividerOuter, {
            BorderColor3 = 'Black';
        });

        Library:AddToRegistry(DividerInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Groupbox:AddBlank(9);
        Groupbox:Resize();
    end

    function Funcs:AddInput(Idx, Info)
        local Textbox = {
            Value = Info.Default or '';
            Numeric = Info.Numeric or false;
            Finished = Info.Finished or false;
            Type = 'Input';
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local InputLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 15);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        Groupbox:AddBlank(1);

        local TextBoxOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        });

        local TextBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = TextBoxOuter;
        });

        Library:AddToRegistry(TextBoxInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:OnHighlight(TextBoxOuter, TextBoxOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then 
            Library:AddToolTip(Info.Tooltip, TextBoxOuter)
        end

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = TextBoxInner;
        });

        local Container = Library:Create('Frame', {
            BackgroundTransparency = 1;
            ClipsDescendants = true;

            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);

            ZIndex = 7;
            Parent = TextBoxInner;
        })

        local Box = Library:Create('TextBox', {
            BackgroundTransparency = 1;

            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromScale(5, 1),
            
            Font = Enum.Font.Code;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = Info.Placeholder or '';

            Text = Info.Default or '';
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;

            ZIndex = 7;
            Parent = Container;
        });
        
        function Textbox:SetValue(Text)
            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength);
            end;

            if Textbox.Numeric then
                if (not tonumber(Text)) and Text:len() > 0 then
                    Text = Textbox.Value 
                end
            end

            Textbox.Value = Text;
            Box.Text = Text;
                
            if Textbox.Changed then
                Textbox.Changed();
            end;
        end;

        if Textbox.Finished then
            Box.FocusLost:Connect(function(enter)
                if not enter then return end
                
                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end)
        else 
            Box:GetPropertyChangedSignal('Text'):Connect(function()
                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end);
        end

        -- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
        -- thank you nicemike40 :)

        local function Update()
            local PADDING = 5
            local reveal = Container.AbsoluteSize.X

            if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
                -- we aren't focused, or we fit so be normal
                Box.Position = UDim2.new(0, PADDING, 0, 0)
            else
                -- we are focused and don't fit, so adjust position
                local cursor = Box.CursorPosition
                if cursor ~= -1 then
                    -- calculate pixel width of text from start to cursor
                    local subtext = string.sub(Box.Text, 1, cursor-1)
                    local width = TextService:GetTextSize(subtext, Box.TextSize, Box.Font, Vector2.new(math.huge, math.huge)).X
                    
                    -- check if we're inside the box with the cursor
                    local currentCursorPos = Box.Position.X.Offset + width

                    -- adjust if necessary
                    if currentCursorPos < PADDING then
                        Box.Position = UDim2.fromOffset(PADDING-width, 0)
                    elseif currentCursorPos > reveal - PADDING - 1 then
                        Box.Position = UDim2.fromOffset(reveal-width-PADDING-1, 0)
                    end
                end
            end
        end 

        task.spawn(Update)

        Box:GetPropertyChangedSignal('Text'):Connect(Update)
        Box:GetPropertyChangedSignal('CursorPosition'):Connect(Update)
        Box.FocusLost:Connect(Update)
        Box.Focused:Connect(Update)

        Library:AddToRegistry(Box, {
            TextColor3 = 'FontColor';
        });

        function Textbox:OnChanged(Func)
            Textbox.Changed = Func;
            Func();
        end;

        Groupbox:AddBlank(5);
        Groupbox:Resize();

        Options[Idx] = Textbox;

        return Textbox;
    end;

    function Funcs:AddToggle(Idx, Info)
        local Toggle = {
            Value = Info.Default or false;
            Type = 'Toggle';

            Addons = {},
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local ToggleOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 13, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(ToggleOuter, {
            BorderColor3 = 'Black';
        });

        local ToggleInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = ToggleOuter;
        });

        Library:AddToRegistry(ToggleInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local ToggleLabel = Library:CreateLabel({
            Size = UDim2.new(0, 216, 1, 0);
            Position = UDim2.new(1, 6, 0, 0);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 6;
            Parent = ToggleInner;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 4);
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ToggleLabel;
        });

        local ToggleRegion = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(0, 170, 1, 0);
            ZIndex = 8;
            Parent = ToggleOuter;
        });

        Library:OnHighlight(ToggleRegion, ToggleOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        function Toggle:UpdateColors()
            Toggle:Display();
        end;

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, ToggleRegion)
        end

        function Toggle:Display()
            ToggleInner.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.MainColor;
            ToggleInner.BorderColor3 = Toggle.Value and Library.AccentColorDark or Library.OutlineColor;

            Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and 'AccentColor' or 'MainColor';
            Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and 'AccentColorDark' or 'OutlineColor';
        end;

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func;
            Func();
        end;

        function Toggle:SetValue(Bool)
            Bool = (not not Bool);

            Toggle.Value = Bool;
            Toggle:Display();

            for _, Addon in next, Toggle.Addons do
                if Addon.Type == 'KeyPicker' and Addon.SyncToggleState then
                    Addon.Toggled = Bool
                    Addon:Update()
                end
            end

            if Toggle.Changed then
                Toggle.Changed();
            end;
        end;

        ToggleRegion.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
                Library:AttemptSave();
            end;
        end);

        Toggle:Display();
        Groupbox:AddBlank(Info.BlankSize or 5 + 2);
        Groupbox:Resize();

        Toggle.TextLabel = ToggleLabel;
        Toggle.Container = Container;
        setmetatable(Toggle, BaseAddons);

        Toggles[Idx] = Toggle;

        return Toggle;
    end;

    function Funcs:AddSlider(Idx, Info)
        assert(Info.Default and Info.Text and Info.Min and Info.Max and Info.Rounding, 'Bad Slider Data');

        local Slider = {
            Value = Info.Default;
            Min = Info.Min;
            Max = Info.Max;
            Rounding = Info.Rounding;
            MaxSize = 232;
            Type = 'Slider';
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        if not Info.Compact then
            Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        local SliderOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(SliderOuter, {
            BorderColor3 = 'Black';
        });

        local SliderInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = SliderOuter;
        });

        Library:AddToRegistry(SliderInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local Fill = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderColor3 = Library.AccentColorDark;
            Size = UDim2.new(0, 0, 1, 0);
            ZIndex = 7;
            Parent = SliderInner;
        });

        Library:AddToRegistry(Fill, {
            BackgroundColor3 = 'AccentColor';
            BorderColor3 = 'AccentColorDark';
        });

        local HideBorderRight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0, 0);
            Size = UDim2.new(0, 1, 1, 0);
            ZIndex = 8;
            Parent = Fill;
        });

        Library:AddToRegistry(HideBorderRight, {
            BackgroundColor3 = 'AccentColor';
        });

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 14;
            Text = 'Infinite';
            ZIndex = 9;
            Parent = SliderInner;
        });

        Library:OnHighlight(SliderOuter, SliderOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, SliderOuter)
        end

        function Slider:UpdateColors()
            Fill.BackgroundColor3 = Library.AccentColor;
            Fill.BorderColor3 = Library.AccentColorDark;
        end;

        function Slider:Display()
            local Suffix = Info.Suffix or '';
            DisplayLabel.Text = string.format('%s/%s', Slider.Value .. Suffix, Slider.Max .. Suffix);

            local X = math.ceil(Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, Slider.MaxSize));
            Fill.Size = UDim2.new(0, X, 1, 0);

            HideBorderRight.Visible = not (X == Slider.MaxSize or X == 0);
        end;

        function Slider:OnChanged(Func)
            Slider.Changed = Func;
            Func();
        end;

        local function Round(Value)
            if Slider.Rounding == 0 then
                return math.floor(Value);
            end;

            local Str = Value .. '';
            local Dot = Str:find('%.');

            return Dot and tonumber(Str:sub(1, Dot + Slider.Rounding)) or Value;
        end;

        function Slider:GetValueFromXOffset(X)
            return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max));
        end;

        function Slider:SetValue(Str)
            local Num = tonumber(Str);

            if (not Num) then
                return;
            end;

            Num = math.clamp(Num, Slider.Min, Slider.Max);

            Slider.Value = Num;
            Slider:Display();

            if Slider.Changed then
                Slider.Changed();
            end;
        end;

        SliderInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                local mPos = Mouse.X;
                local gPos = Fill.Size.X.Offset;
                local Diff = mPos - (Fill.AbsolutePosition.X + gPos);

                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local nMPos = Mouse.X;
                    local nX = math.clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize);

                    local nValue = Slider:GetValueFromXOffset(nX);
                    local OldValue = Slider.Value;
                    Slider.Value = nValue;

                    Slider:Display();

                    if nValue ~= OldValue and Slider.Changed then
                        Slider.Changed();
                    end;

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        Slider:Display();
        Groupbox:AddBlank(Info.BlankSize or 6);
        Groupbox:Resize();

        Options[Idx] = Slider;

        return Slider;
    end;

    function Funcs:AddDropdown(Idx, Info)
        assert(Info.Values, 'Bad Dropdown Data');

        local Dropdown = {
            Values = Info.Values;
            Value = Info.Multi and {};
            Multi = Info.Multi;
            Type = 'Dropdown';
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local RelativeOffset = 0;

        if not Info.Compact then
			local DropdownLabel = Library:CreateLabel({
				Size = UDim2.new(1, 0, 0, 10);
				TextSize = 14;
				Text = Info.Text;
				TextXAlignment = Enum.TextXAlignment.Left;
				TextYAlignment = Enum.TextYAlignment.Bottom;
				ZIndex = 5;
				Parent = Container;
			});
			Groupbox:AddBlank(3);
        end

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA('UIListLayout') then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
            end;
        end;

        local DropdownOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 20);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(DropdownOuter, {
            BorderColor3 = 'Black';
        });

        local DropdownInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DropdownOuter;
        });

        Library:AddToRegistry(DropdownInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = DropdownInner;
        });

        local DropdownArrow = Library:Create('ImageLabel', {
            AnchorPoint = Vector2.new(0, 0.5);
            BackgroundTransparency = 1;
            Position = UDim2.new(1, -16, 0.5, 0);
            Size = UDim2.new(0, 12, 0, 12);
            Image = 'http://www.roblox.com/asset/?id=6282522798';
            ZIndex = 7;
            Parent = DropdownInner;
        });

        local ItemList = Library:CreateLabel({
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            TextSize = 14;
            Text = '--';
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            ZIndex = 7;
            Parent = DropdownInner;
        });

        Library:OnHighlight(DropdownOuter, DropdownOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, DropdownOuter)
        end

        local MAX_DROPDOWN_ITEMS = 8;

        local ListOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 4, 0, 20 + RelativeOffset + 1 + 20);
            Size = UDim2.new(1, -8, 0, MAX_DROPDOWN_ITEMS * 20 + 2);
            ZIndex = 20;
            Visible = false;
            Parent = Container.Parent;
        });

        local ListInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListOuter;
        });

        Library:AddToRegistry(ListInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local Scrolling = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            CanvasSize = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListInner;

            TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.AccentColor, 
        });

        Library:AddToRegistry(Scrolling, {
            ScrollBarImageColor3 = 'AccentColor'
        })

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 0);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Scrolling;
        });

        function Dropdown:Display()
            local Values = Dropdown.Values;
            local Str = '';

            if Info.Multi then
                for Idx, Value in next, Values do
                    if Dropdown.Value[Value] then
                        Str = Str .. Value .. ', ';
                    end;
                end;

                Str = Str:sub(1, #Str - 2);
            else
                Str = Dropdown.Value or '';
            end;

            ItemList.Text = (Str == '' and '--' or Str);
        end;

        function Dropdown:GetActiveValues()
            if Info.Multi then
                local T = {};

                for Value, Bool in next, Dropdown.Value do
                    table.insert(T, Value);
                end;

                return T;
            else
                return Dropdown.Value and 1 or 0;
            end;
        end;

        function Dropdown:SetValues()
            local Values = Dropdown.Values;
            local Buttons = {};

            for _, Element in next, Scrolling:GetChildren() do
                if not Element:IsA('UIListLayout') then
                    -- Library:RemoveFromRegistry(Element);
                    Element:Destroy();
                end;
            end;

            local Count = 0;

            for Idx, Value in next, Values do
                local Table = {};

                Count = Count + 1;

                local Button = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Middle;
                    Size = UDim2.new(1, -1, 0, 20);
                    ZIndex = 23;
                    Active = true,
                    Parent = Scrolling;
                });

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                local ButtonLabel = Library:CreateLabel({
                    Size = UDim2.new(1, -6, 1, 0);
                    Position = UDim2.new(0, 6, 0, 0);
                    TextSize = 14;
                    Text = Value;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 25;
                    Parent = Button;
                });

                Library:OnHighlight(Button, Button,
                    { BorderColor3 = 'AccentColor', ZIndex = 24 },
                    { BorderColor3 = 'OutlineColor', ZIndex = 23 }
                );

                local Selected;

                if Info.Multi then
                    Selected = Dropdown.Value[Value];
                else
                    Selected = Dropdown.Value == Value;
                end;

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value];
                    else
                        Selected = Dropdown.Value == Value;
                    end;

                    ButtonLabel.TextColor3 = Selected and Library.AccentColor or Library.FontColor;
                    Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or 'FontColor';
                end;

                ButtonLabel.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local Try = not Selected;

                        if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                        else
                            if Info.Multi then
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value[Value] = true;
                                else
                                    Dropdown.Value[Value] = nil;
                                end;
                            else
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value = Value;
                                else
                                    Dropdown.Value = nil;
                                end;

                                for _, OtherButton in next, Buttons do
                                    OtherButton:UpdateButton();
                                end;
                            end;

                            Table:UpdateButton();
                            Dropdown:Display();

                            if Dropdown.Changed then
                                Dropdown.Changed();
                            end;

                            Library:AttemptSave();
                        end;
                    end;
                end);

                Table:UpdateButton();
                Dropdown:Display();

                Buttons[Button] = Table;
            end;

            local Y = math.clamp(Count * 20, 0, MAX_DROPDOWN_ITEMS * 20) + 1;
            ListOuter.Size = UDim2.new(1, -8, 0, Y);
            Scrolling.CanvasSize = UDim2.new(0, 0, 0, (Count * 20) + 1);

            -- ListOuter.Size = UDim2.new(1, -8, 0, (#Values * 20) + 2);
        end;

        function Dropdown:OpenDropdown()
            ListOuter.Visible = true;
            Library.OpenedFrames[ListOuter] = true;
            DropdownArrow.Rotation = 180;
        end;

        function Dropdown:CloseDropdown()
            ListOuter.Visible = false;
            Library.OpenedFrames[ListOuter] = nil;
            DropdownArrow.Rotation = 0;
        end;

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func;
            Func();
        end;

        function Dropdown:SetValue(Val)
            if Dropdown.Multi then
                local nTable = {};

                for Value, Bool in next, Val do
                    if table.find(Dropdown.Values, Value) then
                        nTable[Value] = true
                    end;
                end;

                Dropdown.Value = nTable;
            else
                if (not Val) then
                    Dropdown.Value = nil;
                elseif table.find(Dropdown.Values, Val) then
                    Dropdown.Value = Val;
                end;
            end;

            Dropdown:SetValues();
            Dropdown:Display();
            
            if Dropdown.Changed then Dropdown.Changed() end
        end;

        DropdownOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if ListOuter.Visible then
                    Dropdown:CloseDropdown();
                else
                    Dropdown:OpenDropdown();
                end;
            end;
        end);

        InputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    Dropdown:CloseDropdown();
                end;
            end;
        end);

        Dropdown:SetValues();
        Dropdown:Display();

        if type(Info.Default) == 'string' then
            Info.Default = table.find(Dropdown.Values, Info.Default)
        end

        if Info.Default then
            if Info.Multi then
                Dropdown.Value[Dropdown.Values[Info.Default]] = true;
            else
                Dropdown.Value = Dropdown.Values[Info.Default];
            end;

            Dropdown:SetValues();
            Dropdown:Display();
        end;

        Groupbox:AddBlank(Info.BlankSize or 5);
        Groupbox:Resize();

        Options[Idx] = Dropdown;

        return Dropdown;
    end;

    BaseGroupbox.__index = Funcs;
    BaseGroupbox.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

-- < Create other UI elements >
do
    Library.NotificationArea = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 40);
        Size = UDim2.new(0, 300, 0, 200);
        ZIndex = 100;
        Parent = ScreenGui;
    });

    Library:Create('UIListLayout', {
        Padding = UDim.new(0, 4);
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Library.NotificationArea;
    });

    local WatermarkOuter = Library:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 100, 0, -25);
        Size = UDim2.new(0, 213, 0, 20);
        ZIndex = 200;
        Visible = false;
        Parent = ScreenGui;
    });

    local WatermarkInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 201;
        Parent = WatermarkOuter;
    });

    Library:AddToRegistry(WatermarkInner, {
        BorderColor3 = 'AccentColor';
    });

    local InnerFrame = Library:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 202;
        Parent = WatermarkInner;
    });

    local Gradient = Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
            ColorSequenceKeypoint.new(1, Library.MainColor),
        });
        Rotation = -90;
        Parent = InnerFrame;
    });

    Library:AddToRegistry(Gradient, {
        Color = function()
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
        end
    });

    local WatermarkLabel = Library:CreateLabel({
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        TextSize = 14;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = InnerFrame;
    });

    Library.Watermark = WatermarkOuter;
    Library.WatermarkText = WatermarkLabel;
    Library:MakeDraggable(Library.Watermark);



    local KeybindOuter = Library:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5);
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 10, 0.5, 0);
        Size = UDim2.new(0, 210, 0, 20);
        Visible = false;
        ZIndex = 100;
        Parent = ScreenGui;
    });

    local KeybindInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = KeybindOuter;
    });

    Library:AddToRegistry(KeybindInner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    }, true);

    local ColorFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 2);
        ZIndex = 102;
        Parent = KeybindInner;
    });

    Library:AddToRegistry(ColorFrame, {
        BackgroundColor3 = 'AccentColor';
    }, true);

    local KeybindLabel = Library:CreateLabel({
        Size = UDim2.new(1, 0, 0, 20);
        Position = UDim2.fromOffset(5, 2),
        TextXAlignment = Enum.TextXAlignment.Left,
        
        Text = 'Keybinds';
        ZIndex = 104;
        Parent = KeybindInner;
    });

    local KeybindContainer = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 1, -20);
        Position = UDim2.new(0, 0, 0, 20);
        ZIndex = 1;
        Parent = KeybindInner;
    });

    Library:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = KeybindContainer;
    });

    Library:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 5),
        Parent = KeybindContainer,
    })

    Library.KeybindFrame = KeybindOuter;
    Library.KeybindContainer = KeybindContainer;
    Library:MakeDraggable(KeybindOuter);
end;

function Library:SetWatermarkVisibility(Bool)
    Library.Watermark.Visible = Bool;
end;

function Library:SetWatermark(Text)
    local X, Y = Library:GetTextBounds(Text, Enum.Font.Code, 14);
    Library.Watermark.Size = UDim2.new(0, X + 15, 0, (Y * 1.5) + 3);
    Library:SetWatermarkVisibility(true)

    Library.WatermarkText.Text = Text;
end;

function Library:Notify(Text, Time)
    local XSize, YSize = Library:GetTextBounds(Text, Enum.Font.Code, 14);

    YSize = YSize + 7

    local NotifyOuter = Library:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 100, 0, 10);
        Size = UDim2.new(0, 0, 0, YSize);
        ClipsDescendants = true;
        ZIndex = 100;
        Parent = Library.NotificationArea;
    });

    local NotifyInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = NotifyOuter;
    });

    Library:AddToRegistry(NotifyInner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    }, true);

    local InnerFrame = Library:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 102;
        Parent = NotifyInner;
    });

    local Gradient = Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
            ColorSequenceKeypoint.new(1, Library.MainColor),
        });
        Rotation = -90;
        Parent = InnerFrame;
    });

    Library:AddToRegistry(Gradient, {
        Color = function()
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
        end
    });

    local NotifyLabel = Library:CreateLabel({
        Position = UDim2.new(0, 4, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        Text = Text;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 103;
        Parent = InnerFrame;
    });

    local LeftColor = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.new(0, -1, 0, -1);
        Size = UDim2.new(0, 3, 1, 2);
        ZIndex = 104;
        Parent = NotifyOuter;
    });

    Library:AddToRegistry(LeftColor, {
        BackgroundColor3 = 'AccentColor';
    }, true);

    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.4, true);

    task.spawn(function()
        wait(Time or 5);

        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);

        wait(0.4);

        NotifyOuter:Destroy();
    end);
end;

function Library:CreateWindow(...)
    local Arguments = { ... }
    local Config = { AnchorPoint = Vector2.zero }

    if type(...) == 'table' then
        Config = ...;
    else
        Config.Title = Arguments[1]
        Config.AutoShow = Arguments[2] or false;
    end
    
    if type(Config.Title) ~= 'string' then Config.Title = 'No title' end
    
    if typeof(Config.Position) ~= 'UDim2' then Config.Position = UDim2.fromOffset(175, 50) end
    if typeof(Config.Size) ~= 'UDim2' then Config.Size = UDim2.fromOffset(550, 600) end

    if Config.Center then
        Config.AnchorPoint = Vector2.new(0.5, 0.5)
        Config.Position = UDim2.fromScale(0.5, 0.5)
    end

    local Window = {
        Tabs = {};
    };

    local Outer = Library:Create('Frame', {
        AnchorPoint = Config.AnchorPoint,
        BackgroundColor3 = Color3.new(0, 0, 0);
        BorderSizePixel = 0;
        Position = Config.Position,
        Size = Config.Size,
        Visible = false;
        ZIndex = 1;
        Parent = ScreenGui;
    });

    Library:MakeDraggable(Outer, 25);

    local Inner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 1;
        Parent = Outer;
    });

    Library:AddToRegistry(Inner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'AccentColor';
    });

    local WindowLabel = Library:CreateLabel({
        Position = UDim2.new(0, 7, 0, 0);
        Size = UDim2.new(0, 0, 0, 25);
        Text = Config.Title or '';
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 1;
        Parent = Inner;
    });

    local MainSectionOuter = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 25);
        Size = UDim2.new(1, -16, 1, -33);
        ZIndex = 1;
        Parent = Inner;
    });

    Library:AddToRegistry(MainSectionOuter, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });

    local MainSectionInner = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Color3.new(0, 0, 0);
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 0, 0, 0);
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 1;
        Parent = MainSectionOuter;
    });

    Library:AddToRegistry(MainSectionInner, {
        BackgroundColor3 = 'BackgroundColor';
    });

    local TabArea = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 8, 0, 8);
        Size = UDim2.new(1, -16, 0, 21);
        ZIndex = 1;
        Parent = MainSectionInner;
    });

    Library:Create('UIListLayout', {
        Padding = UDim.new(0, 0);
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = TabArea;
    });

    local TabContainer = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 30);
        Size = UDim2.new(1, -16, 1, -38);
        ZIndex = 2;
        Parent = MainSectionInner;
    });

    Library:AddToRegistry(TabContainer, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    function Window:SetWindowTitle(Title)
        WindowLabel.Text = Title;
    end;

    function Window:AddTab(Name)
        local Tab = {
            Groupboxes = {};
            Tabboxes = {};
        };

        local TabButtonWidth = Library:GetTextBounds(Name, Enum.Font.Code, 16);

        local TabButton = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            Size = UDim2.new(0, TabButtonWidth + 8 + 4, 1, 0);
            ZIndex = 1;
            Parent = TabArea;
        });

        Library:AddToRegistry(TabButton, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        local TabButtonLabel = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, -1);
            Text = Name;
            ZIndex = 1;
            Parent = TabButton;
        });

        local Blocker = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 1, 0);
            Size = UDim2.new(1, 0, 0, 1);
            BackgroundTransparency = 1;
            ZIndex = 3;
            Parent = TabButton;
        });

        Library:AddToRegistry(Blocker, {
            BackgroundColor3 = 'MainColor';
        });

        local TabFrame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            Visible = false;
            ZIndex = 2;
            Parent = TabContainer;
        });

        local LeftSide = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 8, 0, 8);
            Size = UDim2.new(0.5, -12, 0, 507);
            ZIndex = 2;
            Parent = TabFrame;
        });

        local RightSide = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 4, 0, 8);
            Size = UDim2.new(0.5, -12, 0, 507);
            ZIndex = 2;
            Parent = TabFrame;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = LeftSide;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = RightSide;
        });

        function Tab:ShowTab()
            for _, Tab in next, Window.Tabs do
                Tab:HideTab();
            end;

            Blocker.BackgroundTransparency = 0;
            TabButton.BackgroundColor3 = Library.MainColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'MainColor';
            TabFrame.Visible = true;
        end;

        function Tab:HideTab()
            Blocker.BackgroundTransparency = 1;
            TabButton.BackgroundColor3 = Library.BackgroundColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'BackgroundColor';
            TabFrame.Visible = false;
        end;

        function Tab:AddGroupbox(Info)
            local Groupbox = {};

            local BoxOuter = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                Size = UDim2.new(1, 0, 0, 507);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            });

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            local BoxInner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.new(0, 0, 0);
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 4;
                Parent = BoxOuter;
            });

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = 'BackgroundColor';
            });

            local Highlight = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 5;
                Parent = BoxInner;
            });

            Library:AddToRegistry(Highlight, {
                BackgroundColor3 = 'AccentColor';
            });

            local GroupboxLabel = Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 18);
                Position = UDim2.new(0, 4, 0, 2);
                TextSize = 14;
                Text = Info.Name;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 5;
                Parent = BoxInner;
            });

            local Container = Library:Create('Frame', {
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 4, 0, 20);
                Size = UDim2.new(1, -4, 1, -20);
                ZIndex = 1;
                Parent = BoxInner;
            });

            Library:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Container;
            });

            function Groupbox:Resize()
                local Size = 0;

                for _, Element in next, Groupbox.Container:GetChildren() do
                    if not Element:IsA('UIListLayout') then
                        Size = Size + Element.Size.Y.Offset;
                    end;
                end;

                BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2);
            end;

            Groupbox.Container = Container;
            setmetatable(Groupbox, BaseGroupbox);

            Groupbox:AddBlank(3);
            Groupbox:Resize();

            Tab.Groupboxes[Info.Name] = Groupbox;

            return Groupbox;
        end;

        function Tab:AddLeftGroupbox(Name)
            return Tab:AddGroupbox({ Side = 1; Name = Name; });
        end;

        function Tab:AddRightGroupbox(Name)
            return Tab:AddGroupbox({ Side = 2; Name = Name; });
        end;

        function Tab:AddTabbox(Info)
            local Tabbox = {
                Tabs = {};
            };

            local BoxOuter = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                Size = UDim2.new(1, 0, 0, 0);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            });

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            local BoxInner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.new(0, 0, 0);
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 4;
                Parent = BoxOuter;
            });

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = 'BackgroundColor';
            });

            local Highlight = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 10;
                Parent = BoxInner;
            });

            Library:AddToRegistry(Highlight, {
                BackgroundColor3 = 'AccentColor';
            });

            local TabboxButtons = Library:Create('Frame', {
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 0, 0, 1);
                Size = UDim2.new(1, 0, 0, 18);
                ZIndex = 5;
                Parent = BoxInner;
            });

            Library:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Left;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TabboxButtons;
            });

            function Tabbox:AddTab(Name)
                local Tab = {};

                local Button = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(0.5, 0, 1, 0);
                    ZIndex = 6;
                    Parent = TabboxButtons;
                });

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = 'MainColor';
                });

                local ButtonLabel = Library:CreateLabel({
                    Size = UDim2.new(1, 0, 1, 0);
                    TextSize = 14;
                    Text = Name;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    ZIndex = 7;
                    Parent = Button;
                });

                local Block = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 1, 0);
                    Size = UDim2.new(1, 0, 0, 1);
                    Visible = false;
                    ZIndex = 9;
                    Parent = Button;
                });

                Library:AddToRegistry(Block, {
                    BackgroundColor3 = 'BackgroundColor';
                });

                local Container = Library:Create('Frame', {
                    Position = UDim2.new(0, 4, 0, 20);
                    Size = UDim2.new(1, -4, 1, -20);
                    ZIndex = 1;
                    Visible = false;
                    Parent = BoxInner;
                });

                Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Container;
                });

                function Tab:Show()
                    for _, Tab in next, Tabbox.Tabs do
                        Tab:Hide();
                    end;

                    Container.Visible = true;
                    Block.Visible = true;

                    Button.BackgroundColor3 = Library.BackgroundColor;
                    Library.RegistryMap[Button].Properties.BackgroundColor3 = 'BackgroundColor';
                end;

                function Tab:Hide()
                    Container.Visible = false;
                    Block.Visible = false;

                    Button.BackgroundColor3 = Library.MainColor;
                    Library.RegistryMap[Button].Properties.BackgroundColor3 = 'MainColor';
                end;

                function Tab:Resize()
                    local TabCount = 0;

                    for _, Tab in next, Tabbox.Tabs do
                        TabCount = TabCount +  1;
                    end;

                    for _, Button in next, TabboxButtons:GetChildren() do
                        if not Button:IsA('UIListLayout') then
                            Button.Size = UDim2.new(1 / TabCount, 0, 1, 0);
                        end;
                    end;

                    local Size = 0;

                    for _, Element in next, Tab.Container:GetChildren() do
                        if not Element:IsA('UIListLayout') then
                            Size = Size + Element.Size.Y.Offset;
                        end;
                    end;

                    if BoxOuter.Size.Y.Offset < 20 + Size + 2 then
                        BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2);
                    end;
                end;

                Button.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                        Tab:Show();
                    end;
                end);

                Tab.Container = Container;
                Tabbox.Tabs[Name] = Tab;

                setmetatable(Tab, BaseGroupbox);

                Tab:AddBlank(3);
                Tab:Resize();

                if #TabboxButtons:GetChildren() == 2 then
                    Tab:Show();
                end;

                return Tab;
            end;

            Tab.Tabboxes[Info.Name or ''] = Tabbox;

            return Tabbox;
        end;

        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 1; });
        end;

        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 2; });
        end;

        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Tab:ShowTab();
            end;
        end);

        -- This was the first tab added, so we show it by default.
        if #TabContainer:GetChildren() == 1 then
            Tab:ShowTab();
        end;

        Window.Tabs[Name] = Tab;
        return Tab;
    end;

    local ModalElement = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = UDim2.new(0, 0, 0, 0);
        Visible = true;
        Text = '';
        Modal = false;
        Parent = ScreenGui;
    });

    function Library.Toggle()
        Outer.Visible = not Outer.Visible;
        ModalElement.Modal = Outer.Visible;

        local oIcon = Mouse.Icon;
        local State = InputService.MouseIconEnabled;

        local Cursor = Drawing.new('Triangle');
        Cursor.Thickness = 1;
        Cursor.Filled = true;

        while Outer.Visible do
            local mPos = workspace.CurrentCamera:WorldToViewportPoint(Mouse.Hit.p);

            Cursor.Color = Library.AccentColor;
            Cursor.PointA = Vector2.new(mPos.X, mPos.Y);
            Cursor.PointB = Vector2.new(mPos.X, mPos.Y) + Vector2.new(6, 14);
            Cursor.PointC = Vector2.new(mPos.X, mPos.Y) + Vector2.new(-6, 14);

            Cursor.Visible = not InputService.MouseIconEnabled;

            RenderStepped:Wait();
        end;

        Cursor:Remove();
    end

    Library:GiveSignal(InputService.InputBegan:Connect(function(Input, Processed)
        if type(Library.ToggleKeybind) == 'table' and Library.ToggleKeybind.Type == 'KeyPicker' then
            if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Library.ToggleKeybind.Value then
                task.spawn(Library.Toggle)
            end
        elseif Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
            task.spawn(Library.Toggle)
        end
    end))

    if Config.AutoShow then task.spawn(Library.Toggle) end

    Window.Holder = Outer;

    return Window;
end;

return {
    default = Library
} end, newEnv("Pombium.vendor.linoria-ui"))() end)

newModule("protect-instance", "ModuleScript", "Pombium.vendor.protect-instance", "Pombium.vendor", function () return setfenv(function() local ProtectedInstances = {};
local Connections = getconnections or get_connection or get_signal_conss;
local HookFunction = HookFunction or hookfunction or hook_function or detour_function;
local GetNCMethod = getnamecallmethod or get_namecall_method;
local CheckCaller = checkcaller or check_caller;
local GetRawMT = get_raw_metatable or getrawmetatable or getraw_metatable;

assert(HookFunction and GetNCMethod and CheckCaller and Connections, "Exploit is not supported");

local function HookMetaMethod(Object, MetaMethod, Function)
    return HookFunction(assert(GetRawMT(Object)[MetaMethod], "Invalid Method"), Function);
end 

local TblDataCache = {};
local FindDataCache = {};
local PropertyChangedData = {};
local InstanceConnections = {};
local NameCall, NewIndex;

local EventMethods = {
    "ChildAdded",
    "ChildRemoved",
    "DescendantRemoving",
    "DescendantAdded",
    "childAdded",
    "childRemoved",
    "descendantRemoving",
    "descendantAdded",
}
local TableInstanceMethods = {
    GetChildren = game.GetChildren,
    GetDescendants = game.GetDescendants,
    getChildren = game.getChildren,
    getDescendants = game.getDescendants,
    children = game.children,
}
local FindInstanceMethods = {
    FindFirstChild = game.FindFirstChild,
    FindFirstChildWhichIsA = game.FindFirstChildWhichIsA,
    FindFirstChildOfClass = game.FindFirstChildOfClass,
    findFirstChild = game.findFirstChild,
    findFirstChildWhichIsA = game.findFirstChildWhichIsA,
    findFirstChildOfClass = game.findFirstChildOfClass,
}
local NameCallMethods = {
    Remove = game.Remove;
    Destroy = game.Destroy;
    remove = game.remove;
    destroy = game.destroy;
}

for MethodName, MethodFunction in next, TableInstanceMethods do
    TblDataCache[MethodName] = HookFunction(MethodFunction, function(...)
        if not CheckCaller() then
            local ReturnedTable = TblDataCache[MethodName](...);
            
            if ReturnedTable then
                table.foreach(ReturnedTable, function(_, Inst)
                    if table.find(ProtectedInstances, Inst) then
                        table.remove(ReturnedTable, _);
                    end
                end)

                return ReturnedTable;
            end
        end

        return TblDataCache[MethodName](...);
    end)
end

for MethodName, MethodFunction in next, FindInstanceMethods do
    FindDataCache[MethodName] = HookFunction(MethodFunction, function(...)
        if not CheckCaller() then
            local FindResult = FindDataCache[MethodName](...);

            if table.find(ProtectedInstances, FindResult) then
                FindResult = nil
            end
            for _, Object in next, ProtectedInstances do
                if Object == FindResult then
                    FindResult = nil
                end
            end
        end
        return FindDataCache[MethodName](...);
    end)
end

local function GetParents(Object)
    local Parents = { Object.Parent };

    local CurrentParent = Object.Parent;

    while CurrentParent ~= game and CurrentParent ~= nil do
        CurrentParent = CurrentParent.Parent;
        table.insert(Parents, CurrentParent)
    end

    return Parents;
end

NameCall = HookMetaMethod(game, "__namecall", function(...)
    if not CheckCaller() then
        local ReturnedData = NameCall(...);
        local NCMethod = GetNCMethod();
        local self, Args = ...;

        if typeof(self) ~= "Instance" then return ReturnedData end
        if not ReturnedData then return nil; end;

        if TableInstanceMethods[NCMethod] then
            if typeof(ReturnedData) ~= "table" then return ReturnedData end;

            table.foreach(ReturnedData, function(_, Inst)
                if table.find(ProtectedInstances, Inst) then
                    table.remove(ReturnedData, _);
                end
            end)

            return ReturnedData;
        end
        
        if FindInstanceMethods[NCMethod] then
            if typeof(ReturnedData) ~= "Instance" then return ReturnedData end;
            
            if table.find(ProtectedInstances, ReturnedData) then
                return nil;
            end
        end
    elseif CheckCaller() then
        local self, Args = ...;
        local Method = GetNCMethod();

        if NameCallMethods[Method] then
            if typeof(self) ~= "Instance" then return NewIndex(...) end

            if table.find(ProtectedInstances, self) and not PropertyChangedData[self] then
                local Parent = self.Parent;
                InstanceConnections[self] = {}

                if tostring(Parent) ~= "nil" then
                    for _, ConnectionType in next, EventMethods do
                        for _, Connection in next, Connections(Parent[ConnectionType]) do
                            table.insert(InstanceConnections[self], Connection);
                            Connection:Disable();
                        end
                    end
                end
                for _, Connection in next, Connections(game.ItemChanged) do
                    table.insert(InstanceConnections[self], Connection);
                    Connection:Disable();
                end
                for _, Connection in next, Connections(game.itemChanged) do
                    table.insert(InstanceConnections[self], Connection);
                    Connection:Disable();
                end
                for _, ParentObject in next, GetParents(self) do
                    if tostring(ParentObject) ~= "nil" then
                        for _, ConnectionType in next, EventMethods do
                            for _, Connection in next, Connections(ParentObject[ConnectionType]) do
                                table.insert(InstanceConnections[self], Connection);
                                Connection:Disable();
                            end
                        end
                    end
                end

                PropertyChangedData[self] = true;
                self[Method](self);
                PropertyChangedData[self] = false;

                table.foreach(InstanceConnections[self], function(_,Connect) 
                    Connect:Enable();
                end)
            end
        end
    end
    return NameCall(...);
end)
NewIndex = HookMetaMethod(game , "__newindex", function(...)
    if CheckCaller() then
        local self, Property, Value, UselessArgs = ...
        
        if typeof(self) ~= "Instance" then return NewIndex(...) end

        if table.find(ProtectedInstances, self) and not PropertyChangedData[self] then
            if rawequal(Property, "Parent") then
                local NewParent = Value;
                local OldParent = self.Parent;
                InstanceConnections[self] = {}

                for _, ConnectionType in next, EventMethods do
                    if NewParent and NewParent.Parent ~= nil then
                        for _, Connection in next, Connections(NewParent[ConnectionType]) do
                            table.insert(InstanceConnections[self], Connection);
                            Connection:Disable();
                        end
                    end
                    if OldParent and OldParent ~= nil then
                        for _, Connection in next, Connections(OldParent[ConnectionType]) do
                            table.insert(InstanceConnections[self], Connection);
                            Connection:Disable();
                        end
                    end
                end

                for _, ParentObject in next, GetParents(self) do
                    if ParentObject and ParentObject.Parent ~= nil then
                        for _, ConnectionType in next, EventMethods do
                            for _, Connection in next, Connections(ParentObject[ConnectionType]) do
                                table.insert(InstanceConnections[self], Connection);
                                Connection:Disable();
                            end
                        end
                    end
                end

                for _, ParentObject in next, GetParents(NewParent) do
                    if ParentObject and ParentObject.Parent ~= nil then
                        for _, ConnectionType in next, EventMethods do
                            for _, Connection in next, Connections(ParentObject[ConnectionType]) do
                                table.insert(InstanceConnections[self], Connection);
                                Connection:Disable();
                            end
                        end
                    end
                end

                for _, Connection in next, Connections(game.ItemChanged) do
                    table.insert(InstanceConnections[self], Connection);
                    Connection:Disable();
                end
                for _, Connection in next, Connections(game.itemChanged) do
                    table.insert(InstanceConnections[self], Connection);
                    Connection:Disable();
                end

                PropertyChangedData[self] = true;
                self.Parent = NewParent;
                PropertyChangedData[self] = false;

               
                table.foreach(InstanceConnections[self], function(_,Connect) 
                    Connect:Enable();
                end)

            end
        end
    end
    return NewIndex(...)
end)


return {
    protectInstance = function(NewInstance)
        table.insert(ProtectedInstances, NewInstance)
    end,
    unprotectInstance = function(NewInstance)
        table.remove(ProtectedInstances, table.find(ProtectedInstances, NewInstance));
    end
} end, newEnv("Pombium.vendor.protect-instance"))() end)

newModule("save-manager", "ModuleScript", "Pombium.vendor.save-manager", "Pombium.vendor", function () return setfenv(function() local httpService = game:GetService('HttpService')

local SaveManager = {} do
	SaveManager.Folder = 'LinoriaLibSettings'
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) 
				return { type = 'Toggle', idx = idx, value = object.Value } 
			end,
			Load = function(idx, data)
				if Toggles[idx] then 
					Toggles[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = 'Slider', idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		ColorPicker = {
			Save = function(idx, object)
				return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex() }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValueRGB(Color3.fromHex(data.value))
				end
			end,
		},
		KeyPicker = {
			Save = function(idx, object)
				return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue({ data.key, data.mode })
				end
			end,
		},

		Input = {
			Save = function(idx, object)
				return { type = 'Input', idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] and type(data.text) == 'string' then
					Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end

	function SaveManager:Save(name)
		local fullPath = self.Folder .. '/settings/' .. name .. '.json'

		local data = {
			objects = {}
		}

		for idx, toggle in next, Toggles do
			if self.Ignore[idx] then continue end

			table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
		end

		for idx, option in next, Options do
			if not self.Parser[option.Type] then continue end
			if self.Ignore[idx] then continue end

			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end	

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then
			return false, 'failed to encode data'
		end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:Load(name)
		local file = self.Folder .. '/settings/' .. name .. '.json'
		if not isfile(file) then return false, 'invalid file' end

		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then return false, 'decode error' end

		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				self.Parser[option.type].Load(option.idx, option)
			end
		end

		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({ 
			"BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", -- themes
			"ThemeManager_ThemeList", 'ThemeManager_CustomThemeList', 'ThemeManager_CustomThemeName', -- themes
		})
	end

	function SaveManager:BuildFolderTree()
		local paths = {
			self.Folder,
			self.Folder .. '/settings'
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder .. '/settings')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1, start - 1))
				end
			end
		end
		
		return out
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
	end

	function SaveManager:LoadAutoloadConfig()
		if isfile(self.Folder .. '/settings/autoload.txt') then
			local name = readfile(self.Folder .. '/settings/autoload.txt')

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify('Failed to load autoload config: ' .. err)
			end

			self.Library:Notify(string.format('Auto loaded config %q', name))
		end
	end


	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, 'Must set SaveManager.Library')

		local section = tab:AddRightGroupbox('Configuration')

		section:AddDropdown('SaveManager_ConfigList', { Text = 'Config list', Values = self:RefreshConfigList(), AllowNull = true })
		section:AddInput('SaveManager_ConfigName',    { Text = 'Config name' })

		section:AddDivider()

		section:AddButton('Create config', function()
			local name = Options.SaveManager_ConfigName.Value

			if name:gsub(' ', '') == '' then 
				return self.Library:Notify('Invalid config name (empty)', 2)
			end

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify('Failed to save config: ' .. err)
			end

			self.Library:Notify(string.format('Created config %q', name))

			Options.SaveManager_ConfigList.Values = self:RefreshConfigList()
			Options.SaveManager_ConfigList:SetValues()
			Options.SaveManager_ConfigList:SetValue(nil)
		end):AddButton('Load config', function()
			local name = Options.SaveManager_ConfigList.Value

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify('Failed to load config: ' .. err)
			end

			self.Library:Notify(string.format('Loaded config %q', name))
		end)

		section:AddButton('Overwrite config', function()
			local name = Options.SaveManager_ConfigList.Value

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify('Failed to overwrite config: ' .. err)
			end

			self.Library:Notify(string.format('Overwrote config %q', name))
		end)
		
		section:AddButton('Autoload config', function()
			local name = Options.SaveManager_ConfigList.Value
			writefile(self.Folder .. '/settings/autoload.txt', name)
			SaveManager.AutoloadLabel:SetText('Current autoload config: ' .. name)
			self.Library:Notify(string.format('Set %q to auto load', name))
		end)

		section:AddButton('Refresh config list', function()
			Options.SaveManager_ConfigList.Values = self:RefreshConfigList()
			Options.SaveManager_ConfigList:SetValues()
			Options.SaveManager_ConfigList:SetValue(nil)
		end)

		SaveManager.AutoloadLabel = section:AddLabel('Current autoload config: none', true)

		if isfile(self.Folder .. '/settings/autoload.txt') then
			local name = readfile(self.Folder .. '/settings/autoload.txt')
			SaveManager.AutoloadLabel:SetText('Current autoload config: ' .. name)
		end

		SaveManager:SetIgnoreIndexes({ 'SaveManager_ConfigList', 'SaveManager_ConfigName' })
	end

	SaveManager:BuildFolderTree()
end

return {
    default = SaveManager
} end, newEnv("Pombium.vendor.save-manager"))() end)

newModule("theme-manager", "ModuleScript", "Pombium.vendor.theme-manager", "Pombium.vendor", function () return setfenv(function() local httpService = game:GetService('HttpService')
local ThemeManager = {} do
	ThemeManager.Folder = 'LinoriaLibSettings'

	local RainbowConnection
	ThemeManager.Library = nil
	ThemeManager.BuiltInThemes = {
		['Default'] 		= { 1, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}') },
		['Dracula'] 		= { 2, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"232533","AccentColor":"6271a5","BackgroundColor":"1b1c27","OutlineColor":"7c82a7"}') },
		['Bitch Bot'] 		= { 3, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}') },
		['Kiriot Hub'] 		= { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"30333b","AccentColor":"ffaa00","BackgroundColor":"1a1c20","OutlineColor":"141414"}') },
		['Fatality'] 		= { 5, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}') },
		['Green'] 			= { 6, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"141414","AccentColor":"00ff8b","BackgroundColor":"1c1c1c","OutlineColor":"3c3c3c"}') },
		['Jester'] 			= { 7, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Mint'] 			= { 8, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Tokyo Night'] 	= { 9, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}') },
		['Ubuntu'] 			= { 10, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}') },
	}

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then return end

		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			self.Library[idx] = Color3.fromHex(col)
			
			if Options[idx] then
				Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		self.Library.FontColor = Options.FontColor.Value
		self.Library.MainColor = Options.MainColor.Value
		self.Library.AccentColor = Options.AccentColor.Value
		self.Library.BackgroundColor = Options.BackgroundColor.Value
		self.Library.OutlineColor = Options.OutlineColor.Value

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()		
		local theme = 'Default'
		local content = isfile(self.Folder .. '/themes/default.json') and readfile(self.Folder .. '/themes/default.json')

		local isDefault = true
		if content then
			content = httpService:JSONDecode(content)

			local name = content["theme"]
			if self.BuiltInThemes[name] then
				theme = name
			elseif self:GetCustomTheme(name) then
				theme = name
				isDefault = false;
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
		 	theme = self.DefaultTheme
		end

		if isDefault then
			Options.ThemeManager_ThemeList:SetValue(theme)
		else
			self:ApplyTheme(theme)
		end
		
		if content then
			Toggles.RainbowToggle:SetValue(content["rainbow"])
		end
	end

	function ThemeManager:SaveDefault(theme, rainbow)
		writefile(self.Folder .. '/themes/default.json', httpService:JSONEncode({ theme = theme; rainbow = not not rainbow}))
	end

	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('Main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddToggle('RainbowToggle', { Text = 'Rainbow Accent Color', Tooltip = 'This will override the accent color' });
		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('Font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })

		groupbox:AddButton('Set as default', function()
			self:SaveDefault(Options.ThemeManager_ThemeList.Value, Toggles.RainbowToggle.Value)
			self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_ThemeList.Value))
		end)

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })

		groupbox:AddButton('Load custom theme', function() 
			self:ApplyTheme(Options.ThemeManager_CustomThemeList.Value) 
		end)

		groupbox:AddButton('Save custom theme', function() 
			self:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)

			Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
			Options.ThemeManager_CustomThemeList:SetValues()
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton('Refresh list', function()
			Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
			Options.ThemeManager_CustomThemeList:SetValues()
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton('Set as default', function()
			if Options.ThemeManager_CustomThemeList.Value ~= nil and Options.ThemeManager_CustomThemeList.Value ~= '' then
				self:SaveDefault(Options.ThemeManager_CustomThemeList.Value, Toggles.RainbowToggle.Value)
				self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_CustomThemeList.Value))
			end
		end)

		ThemeManager:LoadDefault()

		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. '/themes/' .. file
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(httpService.JSONDecode, httpService, data)
		
		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			return self.Library:Notify('Invalid file name for theme (empty)', 3)
		end

		local theme = {}
		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

		for _, field in next, fields do
			theme[field] = Options[field].Value:ToHex()
		end

		writefile(self.Folder .. '/themes/' .. file .. '.json', httpService:JSONEncode(theme))
	end

	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/themes')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local char = file:sub(pos, pos)

				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1))
				end
			end
		end

		return out
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}

		-- build the entire tree if a path is like some-hub/phantom-forces
		-- makefolder builds the entire tree on Synapse X but not other exploits

		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		table.insert(paths, self.Folder .. '/themes')

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end

return {
    default = ThemeManager
} end, newEnv("Pombium.vendor.theme-manager"))() end)

newModule("ts-thing", "ModuleScript", "Pombium.vendor.ts-thing", "Pombium.vendor", function () return setfenv(function() local TS = require(script.Parent.Parent.include.RuntimeLib)

return {
	default = {
		getModule = function(...)
			local args = { ... }
			TS.import(...)
		end
	}
} end, newEnv("Pombium.vendor.ts-thing"))() end)

newInstance("include", "Folder", "Pombium.include", "Pombium")

newModule("Promise", "ModuleScript", "Pombium.include.Promise", "Pombium.include", function () return setfenv(function() --[[
	An implementation of Promises similar to Promise/A+.
]]

local ERROR_NON_PROMISE_IN_LIST = "Non-promise value passed into %s at index %s"
local ERROR_NON_LIST = "Please pass a list of promises to %s"
local ERROR_NON_FUNCTION = "Please pass a handler function to %s!"
local MODE_KEY_METATABLE = { __mode = "k" }

local function isCallable(value)
	if type(value) == "function" then
		return true
	end

	if type(value) == "table" then
		local metatable = getmetatable(value)
		if metatable and type(rawget(metatable, "__call")) == "function" then
			return true
		end
	end

	return false
end

--[[
	Creates an enum dictionary with some metamethods to prevent common mistakes.
]]
local function makeEnum(enumName, members)
	local enum = {}

	for _, memberName in ipairs(members) do
		enum[memberName] = memberName
	end

	return setmetatable(enum, {
		__index = function(_, k)
			error(string.format("%s is not in %s!", k, enumName), 2)
		end,
		__newindex = function()
			error(string.format("Creating new members in %s is not allowed!", enumName), 2)
		end,
	})
end

--[=[
	An object to represent runtime errors that occur during execution.
	Promises that experience an error like this will be rejected with
	an instance of this object.

	@class Error
]=]
local Error
do
	Error = {
		Kind = makeEnum("Promise.Error.Kind", {
			"ExecutionError",
			"AlreadyCancelled",
			"NotResolvedInTime",
			"TimedOut",
		}),
	}
	Error.__index = Error

	function Error.new(options, parent)
		options = options or {}
		return setmetatable({
			error = tostring(options.error) or "[This error has no error text.]",
			trace = options.trace,
			context = options.context,
			kind = options.kind,
			parent = parent,
			createdTick = os.clock(),
			createdTrace = debug.traceback(),
		}, Error)
	end

	function Error.is(anything)
		if type(anything) == "table" then
			local metatable = getmetatable(anything)

			if type(metatable) == "table" then
				return rawget(anything, "error") ~= nil and type(rawget(metatable, "extend")) == "function"
			end
		end

		return false
	end

	function Error.isKind(anything, kind)
		assert(kind ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

		return Error.is(anything) and anything.kind == kind
	end

	function Error:extend(options)
		options = options or {}

		options.kind = options.kind or self.kind

		return Error.new(options, self)
	end

	function Error:getErrorChain()
		local runtimeErrors = { self }

		while runtimeErrors[#runtimeErrors].parent do
			table.insert(runtimeErrors, runtimeErrors[#runtimeErrors].parent)
		end

		return runtimeErrors
	end

	function Error:__tostring()
		local errorStrings = {
			string.format("-- Promise.Error(%s) --", self.kind or "?"),
		}

		for _, runtimeError in ipairs(self:getErrorChain()) do
			table.insert(
				errorStrings,
				table.concat({
					runtimeError.trace or runtimeError.error,
					runtimeError.context,
				}, "\n")
			)
		end

		return table.concat(errorStrings, "\n")
	end
end

--[[
	Packs a number of arguments into a table and returns its length.

	Used to cajole varargs without dropping sparse values.
]]
local function pack(...)
	return select("#", ...), { ... }
end

--[[
	Returns first value (success), and packs all following values.
]]
local function packResult(success, ...)
	return success, select("#", ...), { ... }
end

local function makeErrorHandler(traceback)
	assert(traceback ~= nil, "traceback is nil")

	return function(err)
		-- If the error object is already a table, forward it directly.
		-- Should we extend the error here and add our own trace?

		if type(err) == "table" then
			return err
		end

		return Error.new({
			error = err,
			kind = Error.Kind.ExecutionError,
			trace = debug.traceback(tostring(err), 2),
			context = "Promise created at:\n\n" .. traceback,
		})
	end
end

--[[
	Calls a Promise executor with error handling.
]]
local function runExecutor(traceback, callback, ...)
	return packResult(xpcall(callback, makeErrorHandler(traceback), ...))
end

--[[
	Creates a function that invokes a callback with correct error handling and
	resolution mechanisms.
]]
local function createAdvancer(traceback, callback, resolve, reject)
	return function(...)
		local ok, resultLength, result = runExecutor(traceback, callback, ...)

		if ok then
			resolve(unpack(result, 1, resultLength))
		else
			reject(result[1])
		end
	end
end

local function isEmpty(t)
	return next(t) == nil
end

--[=[
	An enum value used to represent the Promise's status.
	@interface Status
	@tag enum
	@within Promise
	.Started "Started" -- The Promise is executing, and not settled yet.
	.Resolved "Resolved" -- The Promise finished successfully.
	.Rejected "Rejected" -- The Promise was rejected.
	.Cancelled "Cancelled" -- The Promise was cancelled before it finished.
]=]
--[=[
	@prop Status Status
	@within Promise
	@readonly
	@tag enums
	A table containing all members of the `Status` enum, e.g., `Promise.Status.Resolved`.
]=]
--[=[
	A Promise is an object that represents a value that will exist in the future, but doesn't right now.
	Promises allow you to then attach callbacks that can run once the value becomes available (known as *resolving*),
	or if an error has occurred (known as *rejecting*).

	@class Promise
	@__index prototype
]=]
local Promise = {
	Error = Error,
	Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
	_getTime = os.clock,
	_timeEvent = game:GetService("RunService").Heartbeat,
	_unhandledRejectionCallbacks = {},
}
Promise.prototype = {}
Promise.__index = Promise.prototype

function Promise._new(traceback, callback, parent)
	if parent ~= nil and not Promise.is(parent) then
		error("Argument #2 to Promise.new must be a promise or nil", 2)
	end

	local self = {
		-- Used to locate where a promise was created
		_source = traceback,

		_status = Promise.Status.Started,

		-- A table containing a list of all results, whether success or failure.
		-- Only valid if _status is set to something besides Started
		_values = nil,

		-- Lua doesn't like sparse arrays very much, so we explicitly store the
		-- length of _values to handle middle nils.
		_valuesLength = -1,

		-- Tracks if this Promise has no error observers..
		_unhandledRejection = true,

		-- Queues representing functions we should invoke when we update!
		_queuedResolve = {},
		_queuedReject = {},
		_queuedFinally = {},

		-- The function to run when/if this promise is cancelled.
		_cancellationHook = nil,

		-- The "parent" of this promise in a promise chain. Required for
		-- cancellation propagation upstream.
		_parent = parent,

		-- Consumers are Promises that have chained onto this one.
		-- We track them for cancellation propagation downstream.
		_consumers = setmetatable({}, MODE_KEY_METATABLE),
	}

	if parent and parent._status == Promise.Status.Started then
		parent._consumers[self] = true
	end

	setmetatable(self, Promise)

	local function resolve(...)
		self:_resolve(...)
	end

	local function reject(...)
		self:_reject(...)
	end

	local function onCancel(cancellationHook)
		if cancellationHook then
			if self._status == Promise.Status.Cancelled then
				cancellationHook()
			else
				self._cancellationHook = cancellationHook
			end
		end

		return self._status == Promise.Status.Cancelled
	end

	coroutine.wrap(function()
		local ok, _, result = runExecutor(self._source, callback, resolve, reject, onCancel)

		if not ok then
			reject(result[1])
		end
	end)()

	return self
end

--[=[
	Construct a new Promise that will be resolved or rejected with the given callbacks.

	If you `resolve` with a Promise, it will be chained onto.

	You can safely yield within the executor function and it will not block the creating thread.

	```lua
	local myFunction()
		return Promise.new(function(resolve, reject, onCancel)
			wait(1)
			resolve("Hello world!")
		end)
	end

	myFunction():andThen(print)
	```

	You do not need to use `pcall` within a Promise. Errors that occur during execution will be caught and turned into a rejection automatically. If `error()` is called with a table, that table will be the rejection value. Otherwise, string errors will be converted into `Promise.Error(Promise.Error.Kind.ExecutionError)` objects for tracking debug information.

	You may register an optional cancellation hook by using the `onCancel` argument:

	* This should be used to abort any ongoing operations leading up to the promise being settled.
	* Call the `onCancel` function with a function callback as its only argument to set a hook which will in turn be called when/if the promise is cancelled.
	* `onCancel` returns `true` if the Promise was already cancelled when you called `onCancel`.
	* Calling `onCancel` with no argument will not override a previously set cancellation hook, but it will still return `true` if the Promise is currently cancelled.
	* You can set the cancellation hook at any time before resolving.
	* When a promise is cancelled, calls to `resolve` or `reject` will be ignored, regardless of if you set a cancellation hook or not.

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
function Promise.new(executor)
	return Promise._new(debug.traceback(nil, 2), executor)
end

function Promise:__tostring()
	return string.format("Promise(%s)", self._status)
end

--[=[
	The same as [Promise.new](/api/Promise#new), except execution begins after the next `Heartbeat` event.

	This is a spiritual replacement for `spawn`, but it does not suffer from the same [issues](https://eryn.io/gist/3db84579866c099cdd5bb2ff37947cec) as `spawn`.

	```lua
	local function waitForChild(instance, childName, timeout)
	  return Promise.defer(function(resolve, reject)
		local child = instance:WaitForChild(childName, timeout)

		;(child and resolve or reject)(child)
	  end)
	end
	```

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
function Promise.defer(executor)
	local traceback = debug.traceback(nil, 2)
	local promise
	promise = Promise._new(traceback, function(resolve, reject, onCancel)
		local connection
		connection = Promise._timeEvent:Connect(function()
			connection:Disconnect()
			local ok, _, result = runExecutor(traceback, executor, resolve, reject, onCancel)

			if not ok then
				reject(result[1])
			end
		end)
	end)

	return promise
end

-- Backwards compatibility
Promise.async = Promise.defer

--[=[
	Creates an immediately resolved Promise with the given value.

	```lua
	-- Example using Promise.resolve to deliver cached values:
	function getSomething(name)
		if cache[name] then
			return Promise.resolve(cache[name])
		else
			return Promise.new(function(resolve, reject)
				local thing = getTheThing()
				cache[name] = thing

				resolve(thing)
			end)
		end
	end
	```

	@param ... any
	@return Promise<...any>
]=]
function Promise.resolve(...)
	local length, values = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(resolve)
		resolve(unpack(values, 1, length))
	end)
end

--[=[
	Creates an immediately rejected Promise with the given value.

	:::caution
	Something needs to consume this rejection (i.e. `:catch()` it), otherwise it will emit an unhandled Promise rejection warning on the next frame. Thus, you should not create and store rejected Promises for later use. Only create them on-demand as needed.
	:::

	@param ... any
	@return Promise<...any>
]=]
function Promise.reject(...)
	local length, values = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(_, reject)
		reject(unpack(values, 1, length))
	end)
end

--[[
	Runs a non-promise-returning function as a Promise with the
  given arguments.
]]
function Promise._try(traceback, callback, ...)
	local valuesLength, values = pack(...)

	return Promise._new(traceback, function(resolve)
		resolve(callback(unpack(values, 1, valuesLength)))
	end)
end

--[=[
	Begins a Promise chain, calling a function and returning a Promise resolving with its return value. If the function errors, the returned Promise will be rejected with the error. You can safely yield within the Promise.try callback.

	:::info
	`Promise.try` is similar to [Promise.promisify](#promisify), except the callback is invoked immediately instead of returning a new function.
	:::

	```lua
	Promise.try(function()
		return math.random(1, 2) == 1 and "ok" or error("Oh an error!")
	end)
		:andThen(function(text)
			print(text)
		end)
		:catch(function(err)
			warn("Something went wrong")
		end)
	```

	@param callback (...: T...) -> ...any
	@param ... T... -- Additional arguments passed to `callback`
	@return Promise
]=]
function Promise.try(callback, ...)
	return Promise._try(debug.traceback(nil, 2), callback, ...)
end

--[[
	Returns a new promise that:
		* is resolved when all input promises resolve
		* is rejected if ANY input promises reject
]]
function Promise._all(traceback, promises, amount)
	if type(promises) ~= "table" then
		error(string.format(ERROR_NON_LIST, "Promise.all"), 3)
	end

	-- We need to check that each value is a promise here so that we can produce
	-- a proper error rather than a rejected promise with our error.
	for i, promise in pairs(promises) do
		if not Promise.is(promise) then
			error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.all", tostring(i)), 3)
		end
	end

	-- If there are no values then return an already resolved promise.
	if #promises == 0 or amount == 0 then
		return Promise.resolve({})
	end

	return Promise._new(traceback, function(resolve, reject, onCancel)
		-- An array to contain our resolved values from the given promises.
		local resolvedValues = {}
		local newPromises = {}

		-- Keep a count of resolved promises because just checking the resolved
		-- values length wouldn't account for promises that resolve with nil.
		local resolvedCount = 0
		local rejectedCount = 0
		local done = false

		local function cancel()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end

		-- Called when a single value is resolved and resolves if all are done.
		local function resolveOne(i, ...)
			if done then
				return
			end

			resolvedCount = resolvedCount + 1

			if amount == nil then
				resolvedValues[i] = ...
			else
				resolvedValues[resolvedCount] = ...
			end

			if resolvedCount >= (amount or #promises) then
				done = true
				resolve(resolvedValues)
				cancel()
			end
		end

		onCancel(cancel)

		-- We can assume the values inside `promises` are all promises since we
		-- checked above.
		for i, promise in ipairs(promises) do
			newPromises[i] = promise:andThen(function(...)
				resolveOne(i, ...)
			end, function(...)
				rejectedCount = rejectedCount + 1

				if amount == nil or #promises - rejectedCount < amount then
					cancel()
					done = true

					reject(...)
				end
			end)
		end

		if done then
			cancel()
		end
	end)
end

--[=[
	Accepts an array of Promises and returns a new promise that:
	* is resolved after all input promises resolve.
	* is rejected if *any* input promises reject.

	:::info
	Only the first return value from each promise will be present in the resulting array.
	:::

	After any input Promise rejects, all other input Promises that are still pending will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.all(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{T}>
]=]
function Promise.all(promises)
	return Promise._all(debug.traceback(nil, 2), promises)
end

--[=[
	Folds an array of values or promises into a single value. The array is traversed sequentially.

	The reducer function can return a promise or value directly. Each iteration receives the resolved value from the previous, and the first receives your defined initial value.

	The folding will stop at the first rejection encountered.
	```lua
	local basket = {"blueberry", "melon", "pear", "melon"}
	Promise.fold(basket, function(cost, fruit)
		if fruit == "blueberry" then
			return cost -- blueberries are free!
		else
			-- call a function that returns a promise with the fruit price
			return fetchPrice(fruit):andThen(function(fruitCost)
				return cost + fruitCost
			end)
		end
	end, 0)
	```

	@since v3.1.0
	@param list {T | Promise<T>}
	@param reducer (accumulator: U, value: T, index: number) -> U | Promise<U>
	@param initialValue U
]=]
function Promise.fold(list, reducer, initialValue)
	assert(type(list) == "table", "Bad argument #1 to Promise.fold: must be a table")
	assert(isCallable(reducer), "Bad argument #2 to Promise.fold: must be a function")

	local accumulator = Promise.resolve(initialValue)
	return Promise.each(list, function(resolvedElement, i)
		accumulator = accumulator:andThen(function(previousValueResolved)
			return reducer(previousValueResolved, resolvedElement, i)
		end)
	end):andThen(function()
		return accumulator
	end)
end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as `count` Promises are resolved from the input array. The resolved array values are in the order that the Promises resolved in. When this Promise resolves, all other pending Promises are cancelled if they have no other consumers.

	`count` 0 results in an empty array. The resultant array will never have more than `count` elements.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.some(promises, 2) -- Only resolves with first 2 promises to resolve
	```

	@param promises {Promise<T>}
	@param count number
	@return Promise<{T}>
]=]
function Promise.some(promises, count)
	assert(type(count) == "number", "Bad argument #2 to Promise.some: must be a number")

	return Promise._all(debug.traceback(nil, 2), promises, count)
end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as *any* of the input Promises resolves. It will reject only if *all* input Promises reject. As soon as one Promises resolves, all other pending Promises are cancelled if they have no other consumers.

	Resolves directly with the value of the first resolved Promise. This is essentially [[Promise.some]] with `1` count, except the Promise resolves with the value directly instead of an array with one element.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.any(promises) -- Resolves with first value to resolve (only rejects if all 3 rejected)
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
function Promise.any(promises)
	return Promise._all(debug.traceback(nil, 2), promises, 1):andThen(function(values)
		return values[1]
	end)
end

--[=[
	Accepts an array of Promises and returns a new Promise that resolves with an array of in-place Statuses when all input Promises have settled. This is equivalent to mapping `promise:finally` over the array of Promises.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.allSettled(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{Status}>
]=]
function Promise.allSettled(promises)
	if type(promises) ~= "table" then
		error(string.format(ERROR_NON_LIST, "Promise.allSettled"), 2)
	end

	-- We need to check that each value is a promise here so that we can produce
	-- a proper error rather than a rejected promise with our error.
	for i, promise in pairs(promises) do
		if not Promise.is(promise) then
			error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.allSettled", tostring(i)), 2)
		end
	end

	-- If there are no values then return an already resolved promise.
	if #promises == 0 then
		return Promise.resolve({})
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
		-- An array to contain our resolved values from the given promises.
		local fates = {}
		local newPromises = {}

		-- Keep a count of resolved promises because just checking the resolved
		-- values length wouldn't account for promises that resolve with nil.
		local finishedCount = 0

		-- Called when a single value is resolved and resolves if all are done.
		local function resolveOne(i, ...)
			finishedCount = finishedCount + 1

			fates[i] = ...

			if finishedCount >= #promises then
				resolve(fates)
			end
		end

		onCancel(function()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end)

		-- We can assume the values inside `promises` are all promises since we
		-- checked above.
		for i, promise in ipairs(promises) do
			newPromises[i] = promise:finally(function(...)
				resolveOne(i, ...)
			end)
		end
	end)
end

--[=[
	Accepts an array of Promises and returns a new promise that is resolved or rejected as soon as any Promise in the array resolves or rejects.

	:::warning
	If the first Promise to settle from the array settles with a rejection, the resulting Promise from `race` will reject.

	If you instead want to tolerate rejections, and only care about at least one Promise resolving, you should use [Promise.any](#any) or [Promise.some](#some) instead.
	:::

	All other Promises that don't win the race will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.race(promises) -- Only returns 1st value to resolve or reject
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
function Promise.race(promises)
	assert(type(promises) == "table", string.format(ERROR_NON_LIST, "Promise.race"))

	for i, promise in pairs(promises) do
		assert(Promise.is(promise), string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.race", tostring(i)))
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
		local newPromises = {}
		local finished = false

		local function cancel()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end

		local function finalize(callback)
			return function(...)
				cancel()
				finished = true
				return callback(...)
			end
		end

		if onCancel(finalize(reject)) then
			return
		end

		for i, promise in ipairs(promises) do
			newPromises[i] = promise:andThen(finalize(resolve), finalize(reject))
		end

		if finished then
			cancel()
		end
	end)
end

--[=[
	Iterates serially over the given an array of values, calling the predicate callback on each value before continuing.

	If the predicate returns a Promise, we wait for that Promise to resolve before moving on to the next item
	in the array.

	:::info
	`Promise.each` is similar to `Promise.all`, except the Promises are ran in order instead of all at once.

	But because Promises are eager, by the time they are created, they're already running. Thus, we need a way to defer creation of each Promise until a later time.

	The predicate function exists as a way for us to operate on our data instead of creating a new closure for each Promise. If you would prefer, you can pass in an array of functions, and in the predicate, call the function and return its return value.
	:::

	```lua
	Promise.each({
		"foo",
		"bar",
		"baz",
		"qux"
	}, function(value, index)
		return Promise.delay(1):andThen(function()
		print(("%d) Got %s!"):format(index, value))
		end)
	end)

	--[[
		(1 second passes)
		> 1) Got foo!
		(1 second passes)
		> 2) Got bar!
		(1 second passes)
		> 3) Got baz!
		(1 second passes)
		> 4) Got qux!
	]]
	```

	If the Promise a predicate returns rejects, the Promise from `Promise.each` is also rejected with the same value.

	If the array of values contains a Promise, when we get to that point in the list, we wait for the Promise to resolve before calling the predicate with the value.

	If a Promise in the array of values is already Rejected when `Promise.each` is called, `Promise.each` rejects with that value immediately (the predicate callback will never be called even once). If a Promise in the list is already Cancelled when `Promise.each` is called, `Promise.each` rejects with `Promise.Error(Promise.Error.Kind.AlreadyCancelled`). If a Promise in the array of values is Started at first, but later rejects, `Promise.each` will reject with that value and iteration will not continue once iteration encounters that value.

	Returns a Promise containing an array of the returned/resolved values from the predicate for each item in the array of values.

	If this Promise returned from `Promise.each` rejects or is cancelled for any reason, the following are true:
	- Iteration will not continue.
	- Any Promises within the array of values will now be cancelled if they have no other consumers.
	- The Promise returned from the currently active predicate will be cancelled if it hasn't resolved yet.

	@since 3.0.0
	@param list {T | Promise<T>}
	@param predicate (value: T, index: number) -> U | Promise<U>
	@return Promise<{U}>
]=]
function Promise.each(list, predicate)
	assert(type(list) == "table", string.format(ERROR_NON_LIST, "Promise.each"))
	assert(isCallable(predicate), string.format(ERROR_NON_FUNCTION, "Promise.each"))

	return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
		local results = {}
		local promisesToCancel = {}

		local cancelled = false

		local function cancel()
			for _, promiseToCancel in ipairs(promisesToCancel) do
				promiseToCancel:cancel()
			end
		end

		onCancel(function()
			cancelled = true

			cancel()
		end)

		-- We need to preprocess the list of values and look for Promises.
		-- If we find some, we must register our andThen calls now, so that those Promises have a consumer
		-- from us registered. If we don't do this, those Promises might get cancelled by something else
		-- before we get to them in the series because it's not possible to tell that we plan to use it
		-- unless we indicate it here.

		local preprocessedList = {}

		for index, value in ipairs(list) do
			if Promise.is(value) then
				if value:getStatus() == Promise.Status.Cancelled then
					cancel()
					return reject(Error.new({
						error = "Promise is cancelled",
						kind = Error.Kind.AlreadyCancelled,
						context = string.format(
							"The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
							index,
							value._source
						),
					}))
				elseif value:getStatus() == Promise.Status.Rejected then
					cancel()
					return reject(select(2, value:await()))
				end

				-- Chain a new Promise from this one so we only cancel ours
				local ourPromise = value:andThen(function(...)
					return ...
				end)

				table.insert(promisesToCancel, ourPromise)
				preprocessedList[index] = ourPromise
			else
				preprocessedList[index] = value
			end
		end

		for index, value in ipairs(preprocessedList) do
			if Promise.is(value) then
				local success
				success, value = value:await()

				if not success then
					cancel()
					return reject(value)
				end
			end

			if cancelled then
				return
			end

			local predicatePromise = Promise.resolve(predicate(value, index))

			table.insert(promisesToCancel, predicatePromise)

			local success, result = predicatePromise:await()

			if not success then
				cancel()
				return reject(result)
			end

			results[index] = result
		end

		resolve(results)
	end)
end

--[=[
	Checks whether the given object is a Promise via duck typing. This only checks if the object is a table and has an `andThen` method.

	@param object any
	@return boolean -- `true` if the given `object` is a Promise.
]=]
function Promise.is(object)
	if type(object) ~= "table" then
		return false
	end

	local objectMetatable = getmetatable(object)

	if objectMetatable == Promise then
		-- The Promise came from this library.
		return true
	elseif objectMetatable == nil then
		-- No metatable, but we should still chain onto tables with andThen methods
		return isCallable(object.andThen)
	elseif
		type(objectMetatable) == "table"
		and type(rawget(objectMetatable, "__index")) == "table"
		and isCallable(rawget(rawget(objectMetatable, "__index"), "andThen"))
	then
		-- Maybe this came from a different or older Promise library.
		return true
	end

	return false
end

--[=[
	Wraps a function that yields into one that returns a Promise.

	Any errors that occur while executing the function will be turned into rejections.

	:::info
	`Promise.promisify` is similar to [Promise.try](#try), except the callback is returned as a callable function instead of being invoked immediately.
	:::

	```lua
	local sleep = Promise.promisify(wait)

	sleep(1):andThen(print)
	```

	```lua
	local isPlayerInGroup = Promise.promisify(function(player, groupId)
		return player:IsInGroup(groupId)
	end)
	```

	@param callback (...: any) -> ...any
	@return (...: any) -> Promise
]=]
function Promise.promisify(callback)
	return function(...)
		return Promise._try(debug.traceback(nil, 2), callback, ...)
	end
end

--[=[
	Returns a Promise that resolves after `seconds` seconds have passed. The Promise resolves with the actual amount of time that was waited.

	This function is **not** a wrapper around `wait`. `Promise.delay` uses a custom scheduler which provides more accurate timing. As an optimization, cancelling this Promise instantly removes the task from the scheduler.

	:::warning
	Passing `NaN`, infinity, or a number less than 1/60 is equivalent to passing 1/60.
	:::

	```lua
		Promise.delay(5):andThenCall(print, "This prints after 5 seconds")
	```

	@function delay
	@within Promise
	@param seconds number
	@return Promise<number>
]=]
do
	-- uses a sorted doubly linked list (queue) to achieve O(1) remove operations and O(n) for insert

	-- the initial node in the linked list
	local first
	local connection

	function Promise.delay(seconds)
		assert(type(seconds) == "number", "Bad argument #1 to Promise.delay, must be a number.")
		-- If seconds is -INF, INF, NaN, or less than 1 / 60, assume seconds is 1 / 60.
		-- This mirrors the behavior of wait()
		if not (seconds >= 1 / 60) or seconds == math.huge then
			seconds = 1 / 60
		end

		return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
			local startTime = Promise._getTime()
			local endTime = startTime + seconds

			local node = {
				resolve = resolve,
				startTime = startTime,
				endTime = endTime,
			}

			if connection == nil then -- first is nil when connection is nil
				first = node
				connection = Promise._timeEvent:Connect(function()
					local threadStart = Promise._getTime()

					while first ~= nil and first.endTime < threadStart do
						local current = first
						first = current.next

						if first == nil then
							connection:Disconnect()
							connection = nil
						else
							first.previous = nil
						end

						current.resolve(Promise._getTime() - current.startTime)
					end
				end)
			else -- first is non-nil
				if first.endTime < endTime then -- if `node` should be placed after `first`
					-- we will insert `node` between `current` and `next`
					-- (i.e. after `current` if `next` is nil)
					local current = first
					local next = current.next

					while next ~= nil and next.endTime < endTime do
						current = next
						next = current.next
					end

					-- `current` must be non-nil, but `next` could be `nil` (i.e. last item in list)
					current.next = node
					node.previous = current

					if next ~= nil then
						node.next = next
						next.previous = node
					end
				else
					-- set `node` to `first`
					node.next = first
					first.previous = node
					first = node
				end
			end

			onCancel(function()
				-- remove node from queue
				local next = node.next

				if first == node then
					if next == nil then -- if `node` is the first and last
						connection:Disconnect()
						connection = nil
					else -- if `node` is `first` and not the last
						next.previous = nil
					end
					first = next
				else
					local previous = node.previous
					-- since `node` is not `first`, then we know `previous` is non-nil
					previous.next = next

					if next ~= nil then
						next.previous = previous
					end
				end
			end)
		end)
	end
end

--[=[
	Returns a new Promise that resolves if the chained Promise resolves within `seconds` seconds, or rejects if execution time exceeds `seconds`. The chained Promise will be cancelled if the timeout is reached.

	Rejects with `rejectionValue` if it is non-nil. If a `rejectionValue` is not given, it will reject with a `Promise.Error(Promise.Error.Kind.TimedOut)`. This can be checked with [[Error.isKind]].

	```lua
	getSomething():timeout(5):andThen(function(something)
		-- got something and it only took at max 5 seconds
	end):catch(function(e)
		-- Either getting something failed or the time was exceeded.

		if Promise.Error.isKind(e, Promise.Error.Kind.TimedOut) then
			warn("Operation timed out!")
		else
			warn("Operation encountered an error!")
		end
	end)
	```

	Sugar for:

	```lua
	Promise.race({
		Promise.delay(seconds):andThen(function()
			return Promise.reject(
				rejectionValue == nil
				and Promise.Error.new({ kind = Promise.Error.Kind.TimedOut })
				or rejectionValue
			)
		end),
		promise
	})
	```

	@param seconds number
	@param rejectionValue? any -- The value to reject with if the timeout is reached
	@return Promise
]=]
function Promise.prototype:timeout(seconds, rejectionValue)
	local traceback = debug.traceback(nil, 2)

	return Promise.race({
		Promise.delay(seconds):andThen(function()
			return Promise.reject(rejectionValue == nil and Error.new({
				kind = Error.Kind.TimedOut,
				error = "Timed out",
				context = string.format(
					"Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s",
					seconds,
					traceback
				),
			}) or rejectionValue)
		end),
		self,
	})
end

--[=[
	Returns the current Promise status.

	@return Status
]=]
function Promise.prototype:getStatus()
	return self._status
end

--[[
	Creates a new promise that receives the result of this promise.

	The given callbacks are invoked depending on that result.
]]
function Promise.prototype:_andThen(traceback, successHandler, failureHandler)
	self._unhandledRejection = false

	-- Create a new promise to follow this part of the chain
	return Promise._new(traceback, function(resolve, reject)
		-- Our default callbacks just pass values onto the next promise.
		-- This lets success and failure cascade correctly!

		local successCallback = resolve
		if successHandler then
			successCallback = createAdvancer(traceback, successHandler, resolve, reject)
		end

		local failureCallback = reject
		if failureHandler then
			failureCallback = createAdvancer(traceback, failureHandler, resolve, reject)
		end

		if self._status == Promise.Status.Started then
			-- If we haven't resolved yet, put ourselves into the queue
			table.insert(self._queuedResolve, successCallback)
			table.insert(self._queuedReject, failureCallback)
		elseif self._status == Promise.Status.Resolved then
			-- This promise has already resolved! Trigger success immediately.
			successCallback(unpack(self._values, 1, self._valuesLength))
		elseif self._status == Promise.Status.Rejected then
			-- This promise died a terrible death! Trigger failure immediately.
			failureCallback(unpack(self._values, 1, self._valuesLength))
		elseif self._status == Promise.Status.Cancelled then
			-- We don't want to call the success handler or the failure handler,
			-- we just reject this promise outright.
			reject(Error.new({
				error = "Promise is cancelled",
				kind = Error.Kind.AlreadyCancelled,
				context = "Promise created at\n\n" .. traceback,
			}))
		end
	end, self)
end

--[=[
	Chains onto an existing Promise and returns a new Promise.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::

	Return a Promise from the success or failure handler and it will be chained onto.

	@param successHandler (...: any) -> ...any
	@param failureHandler? (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:andThen(successHandler, failureHandler)
	assert(successHandler == nil or isCallable(successHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))
	assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))

	return self:_andThen(debug.traceback(nil, 2), successHandler, failureHandler)
end

--[=[
	Shorthand for `Promise:andThen(nil, failureHandler)`.

	Returns a Promise that resolves if the `failureHandler` worked without encountering an additional error.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::


	@param failureHandler (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:catch(failureHandler)
	assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:catch"))
	return self:_andThen(debug.traceback(nil, 2), nil, failureHandler)
end

--[=[
	Similar to [Promise.andThen](#andThen), except the return value is the same as the value passed to the handler. In other words, you can insert a `:tap` into a Promise chain without affecting the value that downstream Promises receive.

	```lua
		getTheValue()
		:tap(print)
		:andThen(function(theValue)
			print("Got", theValue, "even though print returns nil!")
		end)
	```

	If you return a Promise from the tap handler callback, its value will be discarded but `tap` will still wait until it resolves before passing the original value through.

	@param tapHandler (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:tap(tapHandler)
	assert(isCallable(tapHandler), string.format(ERROR_NON_FUNCTION, "Promise:tap"))
	return self:_andThen(debug.traceback(nil, 2), function(...)
		local callbackReturn = tapHandler(...)

		if Promise.is(callbackReturn) then
			local length, values = pack(...)
			return callbackReturn:andThen(function()
				return unpack(values, 1, length)
			end)
		end

		return ...
	end)
end

--[=[
	Attaches an `andThen` handler to this Promise that calls the given callback with the predefined arguments. The resolved value is discarded.

	```lua
		promise:andThenCall(someFunction, "some", "arguments")
	```

	This is sugar for

	```lua
		promise:andThen(function()
		return someFunction("some", "arguments")
		end)
	```

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:andThenCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:andThenCall"))
	local length, values = pack(...)
	return self:_andThen(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end)
end

--[=[
	Attaches an `andThen` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:andThenReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:andThen(function()
			return "some", "values"
		end)
	```

	:::caution
	Promises are eager, so if you pass a Promise to `andThenReturn`, it will begin executing before `andThenReturn` is reached in the chain. Likewise, if you pass a Promise created from [[Promise.reject]] into `andThenReturn`, it's possible that this will trigger the unhandled rejection warning. If you need to return a Promise, it's usually best practice to use [[Promise.andThen]].
	:::

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:andThenReturn(...)
	local length, values = pack(...)
	return self:_andThen(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end)
end

--[=[
	Cancels this promise, preventing the promise from resolving or rejecting. Does not do anything if the promise is already settled.

	Cancellations will propagate upwards and downwards through chained promises.

	Promises will only be cancelled if all of their consumers are also cancelled. This is to say that if you call `andThen` twice on the same promise, and you cancel only one of the child promises, it will not cancel the parent promise until the other child promise is also cancelled.

	```lua
		promise:cancel()
	```
]=]
function Promise.prototype:cancel()
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Cancelled

	if self._cancellationHook then
		self._cancellationHook()
	end

	if self._parent then
		self._parent:_consumerCancelled(self)
	end

	for child in pairs(self._consumers) do
		child:cancel()
	end

	self:_finalize()
end

--[[
	Used to decrease the number of consumers by 1, and if there are no more,
	cancel this promise.
]]
function Promise.prototype:_consumerCancelled(consumer)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._consumers[consumer] = nil

	if next(self._consumers) == nil then
		self:cancel()
	end
end

--[[
	Used to set a handler for when the promise resolves, rejects, or is
	cancelled. Returns a new promise chained from this promise.
]]
function Promise.prototype:_finally(traceback, finallyHandler, onlyOk)
	if not onlyOk then
		self._unhandledRejection = false
	end

	-- Return a promise chained off of this promise
	return Promise._new(traceback, function(resolve, reject)
		local finallyCallback = resolve
		if finallyHandler then
			finallyCallback = createAdvancer(traceback, finallyHandler, resolve, reject)
		end

		if onlyOk then
			local callback = finallyCallback
			finallyCallback = function(...)
				if self._status == Promise.Status.Rejected then
					return resolve(self)
				end

				return callback(...)
			end
		end

		if self._status == Promise.Status.Started then
			-- The promise is not settled, so queue this.
			table.insert(self._queuedFinally, finallyCallback)
		else
			-- The promise already settled or was cancelled, run the callback now.
			finallyCallback(self._status)
		end
	end, self)
end

--[=[
	Set a handler that will be called regardless of the promise's fate. The handler is called when the promise is resolved, rejected, *or* cancelled.

	Returns a new promise chained from this promise.

	:::caution
	If the Promise is cancelled, any Promises chained off of it with `andThen` won't run. Only Promises chained with `finally` or `done` will run in the case of cancellation.
	:::

	```lua
	local thing = createSomething()

	doSomethingWith(thing)
		:andThen(function()
			print("It worked!")
			-- do something..
		end)
		:catch(function()
			warn("Oh no it failed!")
		end)
		:finally(function()
			-- either way, destroy thing

			thing:Destroy()
		end)

	```

	@param finallyHandler (status: Status) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:finally(finallyHandler)
	assert(finallyHandler == nil or isCallable(finallyHandler), string.format(ERROR_NON_FUNCTION, "Promise:finally"))
	return self:_finally(debug.traceback(nil, 2), finallyHandler)
end

--[=[
	Same as `andThenCall`, except for `finally`.

	Attaches a `finally` handler to this Promise that calls the given callback with the predefined arguments.

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:finallyCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:finallyCall"))
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end)
end

--[=[
	Attaches a `finally` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:finallyReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:finally(function()
			return "some", "values"
		end)
	```

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:finallyReturn(...)
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end)
end

--[=[
	Set a handler that will be called only if the Promise resolves or is cancelled. This method is similar to `finally`, except it doesn't catch rejections.

	:::caution
	`done` should be reserved specifically when you want to perform some operation after the Promise is finished (like `finally`), but you don't want to consume rejections (like in <a href="/roblox-lua-promise/lib/Examples.html#cancellable-animation-sequence">this example</a>). You should use `andThen` instead if you only care about the Resolved case.
	:::

	:::warning
	Like `finally`, if the Promise is cancelled, any Promises chained off of it with `andThen` won't run. Only Promises chained with `done` and `finally` will run in the case of cancellation.
	:::

	Returns a new promise chained from this promise.

	@param doneHandler (status: Status) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:done(doneHandler)
	assert(doneHandler == nil or isCallable(doneHandler), string.format(ERROR_NON_FUNCTION, "Promise:done"))
	return self:_finally(debug.traceback(nil, 2), doneHandler, true)
end

--[=[
	Same as `andThenCall`, except for `done`.

	Attaches a `done` handler to this Promise that calls the given callback with the predefined arguments.

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:doneCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:doneCall"))
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end, true)
end

--[=[
	Attaches a `done` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:doneReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:done(function()
			return "some", "values"
		end)
	```

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:doneReturn(...)
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end, true)
end

--[=[
	Yields the current thread until the given Promise completes. Returns the Promise's status, followed by the values that the promise resolved or rejected with.

	@yields
	@return Status -- The Status representing the fate of the Promise
	@return ...any -- The values the Promise resolved or rejected with.
]=]
function Promise.prototype:awaitStatus()
	self._unhandledRejection = false

	if self._status == Promise.Status.Started then
		local bindable = Instance.new("BindableEvent")

		self:finally(function()
			bindable:Fire()
		end)

		bindable.Event:Wait()
		bindable:Destroy()
	end

	if self._status == Promise.Status.Resolved then
		return self._status, unpack(self._values, 1, self._valuesLength)
	elseif self._status == Promise.Status.Rejected then
		return self._status, unpack(self._values, 1, self._valuesLength)
	end

	return self._status
end

local function awaitHelper(status, ...)
	return status == Promise.Status.Resolved, ...
end

--[=[
	Yields the current thread until the given Promise completes. Returns true if the Promise resolved, followed by the values that the promise resolved or rejected with.

	:::caution
	If the Promise gets cancelled, this function will return `false`, which is indistinguishable from a rejection. If you need to differentiate, you should use [[Promise.awaitStatus]] instead.
	:::

	```lua
		local worked, value = getTheValue():await()

	if worked then
		print("got", value)
	else
		warn("it failed")
	end
	```

	@yields
	@return boolean -- `true` if the Promise successfully resolved
	@return ...any -- The values the Promise resolved or rejected with.
]=]
function Promise.prototype:await()
	return awaitHelper(self:awaitStatus())
end

local function expectHelper(status, ...)
	if status ~= Promise.Status.Resolved then
		error((...) == nil and "Expected Promise rejected with no value." or (...), 3)
	end

	return ...
end

--[=[
	Yields the current thread until the given Promise completes. Returns the values that the promise resolved with.

	```lua
	local worked = pcall(function()
		print("got", getTheValue():expect())
	end)

	if not worked then
		warn("it failed")
	end
	```

	This is essentially sugar for:

	```lua
	select(2, assert(promise:await()))
	```

	**Errors** if the Promise rejects or gets cancelled.

	@error any -- Errors with the rejection value if this Promise rejects or gets cancelled.
	@yields
	@return ...any -- The values the Promise resolved with.
]=]
function Promise.prototype:expect()
	return expectHelper(self:awaitStatus())
end

-- Backwards compatibility
Promise.prototype.awaitValue = Promise.prototype.expect

--[[
	Intended for use in tests.

	Similar to await(), but instead of yielding if the promise is unresolved,
	_unwrap will throw. This indicates an assumption that a promise has
	resolved.
]]
function Promise.prototype:_unwrap()
	if self._status == Promise.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	local success = self._status == Promise.Status.Resolved

	return success, unpack(self._values, 1, self._valuesLength)
end

function Promise.prototype:_resolve(...)
	if self._status ~= Promise.Status.Started then
		if Promise.is((...)) then
			(...):_consumerCancelled(self)
		end
		return
	end

	-- If the resolved value was a Promise, we chain onto it!
	if Promise.is((...)) then
		-- Without this warning, arguments sometimes mysteriously disappear
		if select("#", ...) > 1 then
			local message = string.format(
				"When returning a Promise from andThen, extra arguments are " .. "discarded! See:\n\n%s",
				self._source
			)
			warn(message)
		end

		local chainedPromise = ...

		local promise = chainedPromise:andThen(function(...)
			self:_resolve(...)
		end, function(...)
			local maybeRuntimeError = chainedPromise._values[1]

			-- Backwards compatibility < v2
			if chainedPromise._error then
				maybeRuntimeError = Error.new({
					error = chainedPromise._error,
					kind = Error.Kind.ExecutionError,
					context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
				})
			end

			if Error.isKind(maybeRuntimeError, Error.Kind.ExecutionError) then
				return self:_reject(maybeRuntimeError:extend({
					error = "This Promise was chained to a Promise that errored.",
					trace = "",
					context = string.format(
						"The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n",
						self._source
					),
				}))
			end

			self:_reject(...)
		end)

		if promise._status == Promise.Status.Cancelled then
			self:cancel()
		elseif promise._status == Promise.Status.Started then
			-- Adopt ourselves into promise for cancellation propagation.
			self._parent = promise
			promise._consumers[self] = true
		end

		return
	end

	self._status = Promise.Status.Resolved
	self._valuesLength, self._values = pack(...)

	-- We assume that these callbacks will not throw errors.
	for _, callback in ipairs(self._queuedResolve) do
		coroutine.wrap(callback)(...)
	end

	self:_finalize()
end

function Promise.prototype:_reject(...)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Rejected
	self._valuesLength, self._values = pack(...)

	-- If there are any rejection handlers, call those!
	if not isEmpty(self._queuedReject) then
		-- We assume that these callbacks will not throw errors.
		for _, callback in ipairs(self._queuedReject) do
			coroutine.wrap(callback)(...)
		end
	else
		-- At this point, no one was able to observe the error.
		-- An error handler might still be attached if the error occurred
		-- synchronously. We'll wait one tick, and if there are still no
		-- observers, then we should put a message in the console.

		local err = tostring((...))

		coroutine.wrap(function()
			Promise._timeEvent:Wait()

			-- Someone observed the error, hooray!
			if not self._unhandledRejection then
				return
			end

			-- Build a reasonable message
			local message = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", err, self._source)

			for _, callback in ipairs(Promise._unhandledRejectionCallbacks) do
				task.spawn(callback, self, unpack(self._values, 1, self._valuesLength))
			end

			if Promise.TEST then
				-- Don't spam output when we're running tests.
				return
			end

			warn(message)
		end)()
	end

	self:_finalize()
end

--[[
	Calls any :finally handlers. We need this to be a separate method and
	queue because we must call all of the finally callbacks upon a success,
	failure, *and* cancellation.
]]
function Promise.prototype:_finalize()
	for _, callback in ipairs(self._queuedFinally) do
		-- Purposefully not passing values to callbacks here, as it could be the
		-- resolved values, or rejected errors. If the developer needs the values,
		-- they should use :andThen or :catch explicitly.
		coroutine.wrap(callback)(self._status)
	end

	self._queuedFinally = nil
	self._queuedReject = nil
	self._queuedResolve = nil

	-- Clear references to other Promises to allow gc
	if not Promise.TEST then
		self._parent = nil
		self._consumers = nil
	end
end

--[=[
	Chains a Promise from this one that is resolved if this Promise is already resolved, and rejected if it is not resolved at the time of calling `:now()`. This can be used to ensure your `andThen` handler occurs on the same frame as the root Promise execution.

	```lua
	doSomething()
		:now()
		:andThen(function(value)
			print("Got", value, "synchronously.")
		end)
	```

	If this Promise is still running, Rejected, or Cancelled, the Promise returned from `:now()` will reject with the `rejectionValue` if passed, otherwise with a `Promise.Error(Promise.Error.Kind.NotResolvedInTime)`. This can be checked with [[Error.isKind]].

	@param rejectionValue? any -- The value to reject with if the Promise isn't resolved
	@return Promise
]=]
function Promise.prototype:now(rejectionValue)
	local traceback = debug.traceback(nil, 2)
	if self._status == Promise.Status.Resolved then
		return self:_andThen(traceback, function(...)
			return ...
		end)
	else
		return Promise.reject(rejectionValue == nil and Error.new({
			kind = Error.Kind.NotResolvedInTime,
			error = "This Promise was not resolved in time for :now()",
			context = ":now() was called at:\n\n" .. traceback,
		}) or rejectionValue)
	end
end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	```lua
	local function canFail(a, b, c)
		return Promise.new(function(resolve, reject)
			-- do something that can fail

			local failed, thing = doSomethingThatCanFail(a, b, c)

			if failed then
				reject("it failed")
			else
				resolve(thing)
			end
		end)
	end

	local MAX_RETRIES = 10
	local value = Promise.retry(canFail, MAX_RETRIES, "foo", "bar", "baz") -- args to send to canFail
	```

	@since 3.0.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param ...? P
]=]
function Promise.retry(callback, times, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
	assert(type(times) == "number", "Parameter #2 to Promise.retry must be a number")

	local args, length = { ... }, select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if times > 0 then
			return Promise.retry(callback, times - 1, unpack(args, 1, length))
		else
			return Promise.reject(...)
		end
	end)
end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, waiting `seconds` seconds between each
	retry, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	@since v3.2.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param seconds number
	@param ...? P
]=]
function Promise.retryWithDelay(callback, times, seconds, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
	assert(type(times) == "number", "Parameter #2 (times) to Promise.retry must be a number")
	assert(type(seconds) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

	local args, length = { ... }, select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if times > 0 then
			Promise.delay(seconds):await()

			return Promise.retryWithDelay(callback, times - 1, seconds, unpack(args, 1, length))
		else
			return Promise.reject(...)
		end
	end)
end

--[=[
	Converts an event into a Promise which resolves the next time the event fires.

	The optional `predicate` callback, if passed, will receive the event arguments and should return `true` or `false`, based on if this fired event should resolve the Promise or not. If `true`, the Promise resolves. If `false`, nothing happens and the predicate will be rerun the next time the event fires.

	The Promise will resolve with the event arguments.

	:::tip
	This function will work given any object with a `Connect` method. This includes all Roblox events.
	:::

	```lua
	-- Creates a Promise which only resolves when `somePart` is touched
	-- by a part named `"Something specific"`.
	return Promise.fromEvent(somePart.Touched, function(part)
		return part.Name == "Something specific"
	end)
	```

	@since 3.0.0
	@param event Event -- Any object with a `Connect` method. This includes all Roblox events.
	@param predicate? (...: P) -> boolean -- A function which determines if the Promise should resolve with the given value, or wait for the next event to check again.
	@return Promise<P>
]=]
function Promise.fromEvent(event, predicate)
	predicate = predicate or function()
		return true
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
		local connection
		local shouldDisconnect = false

		local function disconnect()
			connection:Disconnect()
			connection = nil
		end

		-- We use shouldDisconnect because if the callback given to Connect is called before
		-- Connect returns, connection will still be nil. This happens with events that queue up
		-- events when there's nothing connected, such as RemoteEvents

		connection = event:Connect(function(...)
			local callbackValue = predicate(...)

			if callbackValue == true then
				resolve(...)

				if connection then
					disconnect()
				else
					shouldDisconnect = true
				end
			elseif type(callbackValue) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)

		if shouldDisconnect and connection then
			return disconnect()
		end

		onCancel(disconnect)
	end)
end

--[=[
	Registers a callback that runs when an unhandled rejection happens. An unhandled rejection happens when a Promise
	is rejected, and the rejection is not observed with `:catch`.

	The callback is called with the actual promise that rejected, followed by the rejection values.

	@since v3.2.0
	@param callback (promise: Promise, ...: any) -- A callback that runs when an unhandled rejection happens.
	@return () -> () -- Function that unregisters the `callback` when called
]=]
function Promise.onUnhandledRejection(callback)
	table.insert(Promise._unhandledRejectionCallbacks, callback)

	return function()
		local index = table.find(Promise._unhandledRejectionCallbacks, callback)

		if index then
			table.remove(Promise._unhandledRejectionCallbacks, index)
		end
	end
end

return Promise
 end, newEnv("Pombium.include.Promise"))() end)

newModule("RuntimeLib", "ModuleScript", "Pombium.include.RuntimeLib", "Pombium.include", function () return setfenv(function() local Promise = require(script.Parent.Promise)

local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local TS = {}

TS.Promise = Promise

local function isPlugin(object)
	return RunService:IsStudio() and object:FindFirstAncestorWhichIsA("Plugin") ~= nil
end

function TS.getModule(object, scope, moduleName)
	if moduleName == nil then
		moduleName = scope
		scope = "@rbxts"
	end

	if RunService:IsRunning() and object:IsDescendantOf(ReplicatedFirst) then
		warn("roblox-ts packages should not be used from ReplicatedFirst!")
	end

	-- ensure modules have fully replicated
	if RunService:IsRunning() and RunService:IsClient() and not isPlugin(object) and not game:IsLoaded() then
		game.Loaded:Wait()
	end

	local globalModules = script.Parent:FindFirstChild("node_modules")
	if not globalModules then
		error("Could not find any modules!", 2)
	end

	repeat
		local modules = object:FindFirstChild("node_modules")
		if modules and modules ~= globalModules then
			modules = modules:FindFirstChild("@rbxts")
		end
		if modules then
			local module = modules:FindFirstChild(moduleName)
			if module then
				return module
			end
		end
		object = object.Parent
	until object == nil or object == globalModules

	local scopedModules = globalModules:FindFirstChild(scope or "@rbxts");
	return (scopedModules or globalModules):FindFirstChild(moduleName) or error("Could not find module: " .. moduleName, 2)
end

-- This is a hash which TS.import uses as a kind of linked-list-like history of [Script who Loaded] -> Library
local currentlyLoading = {}
local registeredLibraries = {}

function TS.import(caller, module, ...)
	for i = 1, select("#", ...) do
		module = module:WaitForChild((select(i, ...)))
	end

	if module.ClassName ~= "ModuleScript" then
		error("Failed to import! Expected ModuleScript, got " .. module.ClassName, 2)
	end

	currentlyLoading[caller] = module

	-- Check to see if a case like this occurs:
	-- module -> Module1 -> Module2 -> module

	-- WHERE currentlyLoading[module] is Module1
	-- and currentlyLoading[Module1] is Module2
	-- and currentlyLoading[Module2] is module

	local currentModule = module
	local depth = 0

	while currentModule do
		depth = depth + 1
		currentModule = currentlyLoading[currentModule]

		if currentModule == module then
			local str = currentModule.Name -- Get the string traceback

			for _ = 1, depth do
				currentModule = currentlyLoading[currentModule]
				str = str .. "  ⇒ " .. currentModule.Name
			end

			error("Failed to import! Detected a circular dependency chain: " .. str, 2)
		end
	end

	if not registeredLibraries[module] then
		if _G[module] then
			error(
				"Invalid module access! Do you have two TS runtimes trying to import this? " .. module:GetFullName(),
				2
			)
		end

		_G[module] = TS
		registeredLibraries[module] = true -- register as already loaded for subsequent calls
	end

	local data = require(module)

	if currentlyLoading[caller] == module then -- Thread-safe cleanup!
		currentlyLoading[caller] = nil
	end

	return data
end

function TS.instanceof(obj, class)
	-- custom Class.instanceof() check
	if type(class) == "table" and type(class.instanceof) == "function" then
		return class.instanceof(obj)
	end

	-- metatable check
	if type(obj) == "table" then
		obj = getmetatable(obj)
		while obj ~= nil do
			if obj == class then
				return true
			end
			local mt = getmetatable(obj)
			if mt then
				obj = mt.__index
			else
				obj = nil
			end
		end
	end

	return false
end

function TS.async(callback)
	return function(...)
		local n = select("#", ...)
		local args = { ... }
		return Promise.new(function(resolve, reject)
			coroutine.wrap(function()
				local ok, result = pcall(callback, unpack(args, 1, n))
				if ok then
					resolve(result)
				else
					reject(result)
				end
			end)()
		end)
	end
end

function TS.await(promise)
	if not Promise.is(promise) then
		return promise
	end

	local status, value = promise:awaitStatus()
	if status == Promise.Status.Resolved then
		return value
	elseif status == Promise.Status.Rejected then
		error(value, 2)
	else
		error("The awaited Promise was cancelled", 2)
	end
end

function TS.bit_lrsh(a, b)
	local absA = math.abs(a)
	local result = bit32.rshift(absA, b)
	if a == absA then
		return result
	else
		return -result - 1
	end
end

TS.TRY_RETURN = 1
TS.TRY_BREAK = 2
TS.TRY_CONTINUE = 3

function TS.try(func, catch, finally)
	local err, traceback
	local success, exitType, returns = xpcall(
		func,
		function(errInner)
			err = errInner
			traceback = debug.traceback()
		end
	)
	if not success and catch then
		local newExitType, newReturns = catch(err, traceback)
		if newExitType then
			exitType, returns = newExitType, newReturns
		end
	end
	if finally then
		local newExitType, newReturns = finally()
		if newExitType then
			exitType, returns = newExitType, newReturns
		end
	end
	return exitType, returns
end

function TS.generator(callback)
	local co = coroutine.create(callback)
	return {
		next = function(...)
			if coroutine.status(co) == "dead" then
				return { done = true }
			else
				local success, value = coroutine.resume(co, ...)
				if success == false then
					error(value, 2)
				end
				return {
					value = value,
					done = coroutine.status(co) == "dead",
				}
			end
		end,
	}
end

return TS
 end, newEnv("Pombium.include.RuntimeLib"))() end)

newInstance("node_modules", "Folder", "Pombium.include.node_modules", "Pombium.include")

newInstance("bin", "Folder", "Pombium.include.node_modules.bin", "Pombium.include.node_modules")

newModule("out", "ModuleScript", "Pombium.include.node_modules.bin.out", "Pombium.include.node_modules.bin", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
--[[
	*
	* Tracks connections, instances, functions, and objects to be later destroyed.
]]
local Bin
do
	Bin = setmetatable({}, {
		__tostring = function()
			return "Bin"
		end,
	})
	Bin.__index = Bin
	function Bin.new(...)
		local self = setmetatable({}, Bin)
		return self:constructor(...) or self
	end
	function Bin:constructor()
	end
	function Bin:add(item)
		local node = {
			item = item,
		}
		if self.head == nil then
			self.head = node
		end
		if self.tail then
			self.tail.next = node
		end
		self.tail = node
		return item
	end
	function Bin:destroy()
		while self.head do
			local item = self.head.item
			if type(item) == "function" then
				item()
			elseif typeof(item) == "RBXScriptConnection" then
				item:Disconnect()
			elseif item.destroy ~= nil then
				item:destroy()
			elseif item.Destroy ~= nil then
				item:Destroy()
			end
			self.head = self.head.next
		end
	end
	function Bin:isEmpty()
		return self.head == nil
	end
end
return {
	Bin = Bin,
}
 end, newEnv("Pombium.include.node_modules.bin.out"))() end)

newInstance("compiler-types", "Folder", "Pombium.include.node_modules.compiler-types", "Pombium.include.node_modules")

newInstance("types", "Folder", "Pombium.include.node_modules.compiler-types.types", "Pombium.include.node_modules.compiler-types")

newInstance("dumpster", "Folder", "Pombium.include.node_modules.dumpster", "Pombium.include.node_modules")

newModule("Dumpster", "ModuleScript", "Pombium.include.node_modules.dumpster.Dumpster", "Pombium.include.node_modules.dumpster", function () return setfenv(function() local DESTROY_METHODS = { "destroy", "Destroy", "Disconnect" }

local Dumpster = {} do
	Dumpster.__index = Dumpster

	local finalizers = {
		["function"] = function(item)
			item()
		end,
		["Instance"] = function(item)
			item:Destroy()
		end,
		["RBXScriptConnection"] = function(item)
			item:Disconnect()
		end,
		["table"] = function(item)
			for _, methodName in ipairs(DESTROY_METHODS) do
				if item[methodName] then
					item[methodName](item)
				end
			end
		end
	}

	function Dumpster.new()
		return setmetatable({}, Dumpster)
	end

	function Dumpster:dump(item, finalizer)
		self[item] = finalizer or finalizers[typeof(item)]
		return self
	end

	function Dumpster:burn()
		local item, finalizer = next(self)
		while item ~= nil do
			finalizer(item)
			self[item] = nil
			item, finalizer = next(self)
		end
	end

	Dumpster.destroy = Dumpster.burn
end

return {
	Dumpster = Dumpster
}
 end, newEnv("Pombium.include.node_modules.dumpster.Dumpster"))() end)

newInstance("finite-state-machine", "Folder", "Pombium.include.node_modules.finite-state-machine", "Pombium.include.node_modules")

newModule("out", "ModuleScript", "Pombium.include.node_modules.finite-state-machine.out", "Pombium.include.node_modules.finite-state-machine", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local TS = _G[script]
local exports = {}
for _k, _v in pairs(TS.import(script, script, "classes", "FiniteStateMachine")) do
	exports[_k] = _v
end
return exports
 end, newEnv("Pombium.include.node_modules.finite-state-machine.out"))() end)

newInstance("classes", "Folder", "Pombium.include.node_modules.finite-state-machine.out.classes", "Pombium.include.node_modules.finite-state-machine.out")

newModule("FiniteStateMachine", "ModuleScript", "Pombium.include.node_modules.finite-state-machine.out.classes.FiniteStateMachine", "Pombium.include.node_modules.finite-state-machine.out.classes", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local TS = _G[script]
local Bin = TS.import(script, TS.getModule(script, "@rbxts", "bin").out).Bin
local SignalFactory = TS.import(script, script.Parent.Parent, "factories", "SignalFactory").SignalFactory
local function convertTupleKeysToNestedMap(tupleKeysMap)
	local tupleKeysLookUpMap = {}
	for tupleKey, value in pairs(tupleKeysMap) do
		local _arg0 = tupleKey[1]
		if not (tupleKeysLookUpMap[_arg0] ~= nil) then
			local _arg0_1 = tupleKey[1]
			-- ▼ Map.set ▼
			tupleKeysLookUpMap[_arg0_1] = {}
			-- ▲ Map.set ▲
		end
		local _arg0_1 = tupleKey[1]
		local _exp = tupleKeysLookUpMap[_arg0_1]
		local _arg0_2 = tupleKey[2]
		-- ▼ Map.set ▼
		_exp[_arg0_2] = value
		-- ▲ Map.set ▲
	end
	return tupleKeysLookUpMap
end
local FiniteStateMachine
do
	FiniteStateMachine = setmetatable({}, {
		__tostring = function()
			return "FiniteStateMachine"
		end,
	})
	FiniteStateMachine.__index = FiniteStateMachine
	function FiniteStateMachine.new(...)
		local self = setmetatable({}, FiniteStateMachine)
		return self:constructor(...) or self
	end
	function FiniteStateMachine:constructor(currentState, signalFactory, tupleKeyStateTransitions)
		self.currentState = currentState
		self.isDestroyed = false
		self.bin = Bin.new()
		self.stateTransitions = convertTupleKeysToNestedMap(tupleKeyStateTransitions)
		self.stateChangedFireable = signalFactory:createInstance()
		self.stateChanged = self.stateChangedFireable
		self.bin:add(self.stateChangedFireable)
		self.bin:add(function()
			self.isDestroyed = true
			return self.isDestroyed
		end)
	end
	function FiniteStateMachine:create(initialState, stateTransitions)
		return FiniteStateMachine.new(initialState, SignalFactory.new(), stateTransitions)
	end
	function FiniteStateMachine:destroy()
		if self.isDestroyed then
			warn(debug.traceback('Attempt to destroy an already destroyed instance of type "' .. (tostring((getmetatable(self))) .. '"')))
		end
		self.bin:destroy()
	end
	function FiniteStateMachine:getCurrentState()
		self:assertIsNotDestroyed()
		return self.currentState
	end
	function FiniteStateMachine:handleEvent(event)
		self:assertIsNotDestroyed()
		local _stateTransitions = self.stateTransitions
		local _currentState = self.currentState
		local _newState = _stateTransitions[_currentState]
		if _newState ~= nil then
			_newState = _newState[event]
		end
		local newState = _newState
		if newState == nil then
			error("Invalid event '" .. (tostring(event) .. ("' while in state '" .. (tostring(self.currentState) .. "'"))))
		end
		local oldState = self.currentState
		self.currentState = newState
		self.stateChangedFireable:fire(newState, oldState, event)
	end
	function FiniteStateMachine:assertIsNotDestroyed()
		if self.isDestroyed then
			error('Attempt to call a method on an already destroyed instance of type "' .. (tostring((getmetatable(self))) .. '"'))
		end
	end
end
return {
	FiniteStateMachine = FiniteStateMachine,
}
 end, newEnv("Pombium.include.node_modules.finite-state-machine.out.classes.FiniteStateMachine"))() end)

newModule("FiniteStateMachine.spec", "ModuleScript", "Pombium.include.node_modules.finite-state-machine.out.classes.FiniteStateMachine.spec", "Pombium.include.node_modules.finite-state-machine.out.classes", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local TS = _G[script]
-- eslint-disable @typescript-eslint/no-non-null-assertion
-- eslint-disable @typescript-eslint/consistent-type-assertions
-- / <reference types="@rbxts/testez/globals" />
local SignalFactory = TS.import(script, script.Parent.Parent, "factories", "SignalFactory").SignalFactory
local FiniteStateMachine = TS.import(script, script.Parent, "FiniteStateMachine").FiniteStateMachine
local ALL_STATES = { "A", "B", "C" }
local DEFAULT_STATE_TRANSITIONS = {
	[{ "A", "A-B" }] = "B",
	[{ "A", "A-C" }] = "C",
	[{ "A", "Loop" }] = "A",
	[{ "B", "B-C" }] = "C",
	[{ "B", "Loop" }] = "B",
	[{ "C", "C-A" }] = "A",
	[{ "C", "Loop" }] = "C",
}
local UnitTestableFiniteStateMachine
do
	local super = FiniteStateMachine
	UnitTestableFiniteStateMachine = setmetatable({}, {
		__tostring = function()
			return "UnitTestableFiniteStateMachine"
		end,
		__index = super,
	})
	UnitTestableFiniteStateMachine.__index = UnitTestableFiniteStateMachine
	function UnitTestableFiniteStateMachine.new(...)
		local self = setmetatable({}, UnitTestableFiniteStateMachine)
		return self:constructor(...) or self
	end
	function UnitTestableFiniteStateMachine:constructor(args)
		local _result = args
		if _result ~= nil then
			_result = _result.currentState
		end
		local _condition = _result
		if _condition == nil then
			_condition = "A"
		end
		local _result_1 = args
		if _result_1 ~= nil then
			_result_1 = _result_1.signalFactory
		end
		local _condition_1 = _result_1
		if _condition_1 == nil then
			_condition_1 = SignalFactory.new()
		end
		local _result_2 = args
		if _result_2 ~= nil then
			_result_2 = _result_2.tupleKeyStateTransitions
		end
		local _condition_2 = _result_2
		if _condition_2 == nil then
			_condition_2 = DEFAULT_STATE_TRANSITIONS
		end
		super.constructor(self, _condition, _condition_1, _condition_2)
	end
end
return function()
	describe("initialState", function()
		it("should reflect whatever it is given at initialization", function()
			for _, state in ipairs(ALL_STATES) do
				local fsm = UnitTestableFiniteStateMachine.new({
					currentState = state,
				})
				expect(fsm:getCurrentState()).to.equal(state)
			end
		end)
	end)
	describe("getCurrentState", function() end)
	describe("handleEvent", function()
		it("should properly update state and fire stateChanged when given an event with a valid transition from the current state", function()
			for _binding, newState in pairs(DEFAULT_STATE_TRANSITIONS) do
				local startState = _binding[1]
				local event = _binding[2]
				local fsm = UnitTestableFiniteStateMachine.new({
					currentState = startState,
				})
				expect(fsm:getCurrentState()).to.equal(startState)
				local eventArgsTuple = nil
				fsm.stateChanged:Connect(function(newState, oldState, event)
					expect(eventArgsTuple).never.to.be.ok()
					eventArgsTuple = { newState, oldState, event }
				end)
				fsm:handleEvent(event)
				expect(fsm:getCurrentState()).to.equal(newState)
				expect(eventArgsTuple).to.be.ok()
				expect(eventArgsTuple[1]).to.equal(newState)
				expect(eventArgsTuple[2]).to.equal(startState)
				expect(eventArgsTuple[3]).to.equal(event)
			end
		end)
		it("should throw when given an invalid event for the current state", function()
			local fsm = UnitTestableFiniteStateMachine.new({
				currentState = "B",
			})
			expect(function()
				return fsm:handleEvent("A-C")
			end).to.throw()
		end)
	end)
end
 end, newEnv("Pombium.include.node_modules.finite-state-machine.out.classes.FiniteStateMachine.spec"))() end)

newInstance("factories", "Folder", "Pombium.include.node_modules.finite-state-machine.out.factories", "Pombium.include.node_modules.finite-state-machine.out")

newModule("SignalFactory", "ModuleScript", "Pombium.include.node_modules.finite-state-machine.out.factories.SignalFactory", "Pombium.include.node_modules.finite-state-machine.out.factories", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local TS = _G[script]
local Signal = TS.import(script, TS.getModule(script, "@rbxts", "signals-tooling").out).Signal
local SignalFactory
do
	SignalFactory = setmetatable({}, {
		__tostring = function()
			return "SignalFactory"
		end,
	})
	SignalFactory.__index = SignalFactory
	function SignalFactory.new(...)
		local self = setmetatable({}, SignalFactory)
		return self:constructor(...) or self
	end
	function SignalFactory:constructor()
	end
	function SignalFactory:createInstance()
		return Signal.new()
	end
end
return {
	SignalFactory = SignalFactory,
}
 end, newEnv("Pombium.include.node_modules.finite-state-machine.out.factories.SignalFactory"))() end)

newInstance("interfaces", "Folder", "Pombium.include.node_modules.finite-state-machine.out.interfaces", "Pombium.include.node_modules.finite-state-machine.out")

newModule("IReadonlyFiniteStateMachine", "ModuleScript", "Pombium.include.node_modules.finite-state-machine.out.interfaces.IReadonlyFiniteStateMachine", "Pombium.include.node_modules.finite-state-machine.out.interfaces", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
return nil
 end, newEnv("Pombium.include.node_modules.finite-state-machine.out.interfaces.IReadonlyFiniteStateMachine"))() end)

newInstance("fitumi", "Folder", "Pombium.include.node_modules.fitumi", "Pombium.include.node_modules")

newInstance("log", "Folder", "Pombium.include.node_modules.log", "Pombium.include.node_modules")

newModule("out", "ModuleScript", "Pombium.include.node_modules.log.out", "Pombium.include.node_modules.log", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local exports = {}
local LogEventRobloxOutputSink = TS.import(script, script, "Core", "LogEventRobloxOutputSink").LogEventRobloxOutputSink
local Logger = TS.import(script, script, "Logger").Logger
exports.Logger = TS.import(script, script, "Logger").Logger
exports.LogLevel = TS.import(script, script, "Core").LogLevel
local Log = {}
do
	local _container = Log
	local defaultLogger = Logger:default()
	local function SetLogger(logger)
		defaultLogger = logger
	end
	_container.SetLogger = SetLogger
	local function Default()
		return defaultLogger
	end
	_container.Default = Default
	--[[
		*
		* Configure a custom logger
	]]
	local function Configure()
		return Logger:configure()
	end
	_container.Configure = Configure
	--[[
		*
		* Creates a custom logger
		* @returns The logger configuration, use `Initialize` to get the logger once configured
		* @deprecated Use {@link Configure}. This will be removed in future.
	]]
	local Create = Configure
	_container.Create = Create
	--[[
		*
		* The default roblox output sink
		* @param options Options for the sink
	]]
	local RobloxOutput = function(options)
		if options == nil then
			options = {}
		end
		return LogEventRobloxOutputSink.new(options)
	end
	_container.RobloxOutput = RobloxOutput
	--[[
		*
		* Write a "Fatal" message to the default logger
		* @param template
		* @param args
	]]
	local function Fatal(template, ...)
		local args = { ... }
		return defaultLogger:Fatal(template, ...)
	end
	_container.Fatal = Fatal
	--[[
		*
		* Write a "Verbose" message to the default logger
		* @param template
		* @param args
	]]
	local function Verbose(template, ...)
		local args = { ... }
		defaultLogger:Verbose(template, ...)
	end
	_container.Verbose = Verbose
	--[[
		*
		* Write an "Information" message to the default logger
		* @param template
		* @param args
	]]
	local function Info(template, ...)
		local args = { ... }
		defaultLogger:Info(template, ...)
	end
	_container.Info = Info
	--[[
		*
		* Write a "Debugging" message to the default logger
		* @param template
		* @param args
	]]
	local function Debug(template, ...)
		local args = { ... }
		defaultLogger:Debug(template, ...)
	end
	_container.Debug = Debug
	--[[
		*
		* Write a "Warning" message to the default logger
		* @param template
		* @param args
	]]
	local function Warn(template, ...)
		local args = { ... }
		defaultLogger:Warn(template, ...)
	end
	_container.Warn = Warn
	--[[
		*
		* Write an "Error" message to the default logger
		* @param template
		* @param args
	]]
	local function Error(template, ...)
		local args = { ... }
		return defaultLogger:Error(template, ...)
	end
	_container.Error = Error
	--[[
		*
		* Creates a logger that enriches log events with the specified context as the property `SourceContext`.
		* @param context The tag to use
	]]
	local function ForContext(context, contextConfiguration)
		return defaultLogger:ForContext(context, contextConfiguration)
	end
	_container.ForContext = ForContext
	--[[
		*
		* Creates a logger that nriches log events with the specified property
		* @param name The name of the property
		* @param value The value of the property
	]]
	local function ForProperty(name, value)
		return defaultLogger:ForProperty(name, value)
	end
	_container.ForProperty = ForProperty
	--[[
		*
		* Creates a logger that enriches log events with the specified properties
		* @param props The properties
	]]
	local function ForProperties(props)
		return defaultLogger:ForProperties(props)
	end
	_container.ForProperties = ForProperties
	--[[
		*
		* Creates a logger that enriches log events with the `SourceContext` as the containing script
	]]
	local function ForScript(scriptContextConfiguration)
		-- Unfortunately have to duplicate here, since `debug.info`.
		local s = debug.info(2, "s")
		local copy = defaultLogger:Copy()
		local _result = scriptContextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		return copy:EnrichWithProperties({
			SourceContext = s,
			SourceKind = "Script",
		}):Create()
	end
	_container.ForScript = ForScript
	--[[
		*
		* Set the minimum log level for the default logger
	]]
	local function SetMinLogLevel(logLevel)
		defaultLogger:SetMinLogLevel(logLevel)
	end
	_container.SetMinLogLevel = SetMinLogLevel
	--[[
		*
		* Creates a logger that enriches log events with `SourceContext` as the specified function
	]]
	local function ForFunction(func, funcContextConfiguration)
		return defaultLogger:ForFunction(func, funcContextConfiguration)
	end
	_container.ForFunction = ForFunction
end
local default = Log
exports.default = default
return exports
 end, newEnv("Pombium.include.node_modules.log.out"))() end)

newModule("Configuration", "ModuleScript", "Pombium.include.node_modules.log.out.Configuration", "Pombium.include.node_modules.log.out", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local LogEventPropertyEnricher = TS.import(script, script.Parent, "Core", "LogEventPropertyEnricher").LogEventPropertyEnricher
local LogLevel = TS.import(script, script.Parent, "Core").LogLevel
local LogEventCallbackSink = TS.import(script, script.Parent, "Core", "LogEventCallbackSink").LogEventCallbackSink
local RunService = game:GetService("RunService")
local LogConfiguration
do
	LogConfiguration = setmetatable({}, {
		__tostring = function()
			return "LogConfiguration"
		end,
	})
	LogConfiguration.__index = LogConfiguration
	function LogConfiguration.new(...)
		local self = setmetatable({}, LogConfiguration)
		return self:constructor(...) or self
	end
	function LogConfiguration:constructor(logger)
		self.logger = logger
		self.sinks = {}
		self.enrichers = {}
		self.logLevel = RunService:IsStudio() and LogLevel.Debugging or LogLevel.Information
	end
	function LogConfiguration:WriteTo(sink, configure)
		local _result = configure
		if _result ~= nil then
			_result(sink)
		end
		local _sinks = self.sinks
		table.insert(_sinks, sink)
		return self
	end
	function LogConfiguration:WriteToCallback(sinkCallback, configure)
		local sink = LogEventCallbackSink.new(sinkCallback)
		local _result = configure
		if _result ~= nil then
			_result(sink)
		end
		local _sinks = self.sinks
		table.insert(_sinks, sink)
		return self
	end
	function LogConfiguration:Enrich(enricher)
		if type(enricher) == "function" then
		else
			local _enrichers = self.enrichers
			table.insert(_enrichers, enricher)
		end
		return self
	end
	function LogConfiguration:EnrichWithProperty(propertyName, value, configure)
		return self:EnrichWithProperties({
			[propertyName] = value,
		}, configure)
	end
	function LogConfiguration:EnrichWithProperties(props, configure)
		local enricher = LogEventPropertyEnricher.new(props)
		local _result = configure
		if _result ~= nil then
			_result(enricher)
		end
		local _enrichers = self.enrichers
		table.insert(_enrichers, enricher)
		return self
	end
	function LogConfiguration:SetMinLogLevel(logLevel)
		self.logLevel = logLevel
		return self
	end
	function LogConfiguration:Create()
		self.logger:SetSinks(self.sinks)
		self.logger:SetEnrichers(self.enrichers)
		self.logger:SetMinLogLevel(self.logLevel)
		return self.logger
	end
end
return {
	LogConfiguration = LogConfiguration,
}
 end, newEnv("Pombium.include.node_modules.log.out.Configuration"))() end)

newModule("Core", "ModuleScript", "Pombium.include.node_modules.log.out.Core", "Pombium.include.node_modules.log.out", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local LogLevel
do
	local _inverse = {}
	LogLevel = setmetatable({}, {
		__index = _inverse,
	})
	LogLevel.Verbose = 0
	_inverse[0] = "Verbose"
	LogLevel.Debugging = 1
	_inverse[1] = "Debugging"
	LogLevel.Information = 2
	_inverse[2] = "Information"
	LogLevel.Warning = 3
	_inverse[3] = "Warning"
	LogLevel.Error = 4
	_inverse[4] = "Error"
	LogLevel.Fatal = 5
	_inverse[5] = "Fatal"
end
return {
	LogLevel = LogLevel,
}
 end, newEnv("Pombium.include.node_modules.log.out.Core"))() end)

newModule("LogEventCallbackSink", "ModuleScript", "Pombium.include.node_modules.log.out.Core.LogEventCallbackSink", "Pombium.include.node_modules.log.out.Core", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local LogEventCallbackSink
do
	LogEventCallbackSink = setmetatable({}, {
		__tostring = function()
			return "LogEventCallbackSink"
		end,
	})
	LogEventCallbackSink.__index = LogEventCallbackSink
	function LogEventCallbackSink.new(...)
		local self = setmetatable({}, LogEventCallbackSink)
		return self:constructor(...) or self
	end
	function LogEventCallbackSink:constructor(callback)
		self.callback = callback
	end
	function LogEventCallbackSink:Emit(message)
		local _binding = self
		local minLogLevel = _binding.minLogLevel
		if minLogLevel == nil or message.Level >= minLogLevel then
			self.callback(message)
		end
	end
	function LogEventCallbackSink:SetMinLogLevel(logLevel)
		self.minLogLevel = logLevel
	end
end
return {
	LogEventCallbackSink = LogEventCallbackSink,
}
 end, newEnv("Pombium.include.node_modules.log.out.Core.LogEventCallbackSink"))() end)

newModule("LogEventPropertyEnricher", "ModuleScript", "Pombium.include.node_modules.log.out.Core.LogEventPropertyEnricher", "Pombium.include.node_modules.log.out.Core", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local LogEventPropertyEnricher
do
	LogEventPropertyEnricher = setmetatable({}, {
		__tostring = function()
			return "LogEventPropertyEnricher"
		end,
	})
	LogEventPropertyEnricher.__index = LogEventPropertyEnricher
	function LogEventPropertyEnricher.new(...)
		local self = setmetatable({}, LogEventPropertyEnricher)
		return self:constructor(...) or self
	end
	function LogEventPropertyEnricher:constructor(props)
		self.props = props
	end
	function LogEventPropertyEnricher:Enrich(message, properties)
		local minLogLevel = self.minLogLevel
		if minLogLevel == nil or message.Level >= minLogLevel then
			for k, v in pairs(self.props) do
				properties[k] = v
			end
		end
	end
	function LogEventPropertyEnricher:SetMinLogLevel(minLogLevel)
		self.minLogLevel = minLogLevel
	end
end
return {
	LogEventPropertyEnricher = LogEventPropertyEnricher,
}
 end, newEnv("Pombium.include.node_modules.log.out.Core.LogEventPropertyEnricher"))() end)

newModule("LogEventRobloxOutputSink", "ModuleScript", "Pombium.include.node_modules.log.out.Core.LogEventRobloxOutputSink", "Pombium.include.node_modules.log.out.Core", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local _message_templates = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out)
local MessageTemplateParser = _message_templates.MessageTemplateParser
local PlainTextMessageTemplateRenderer = _message_templates.PlainTextMessageTemplateRenderer
local LogLevel = TS.import(script, script.Parent).LogLevel
local LogEventRobloxOutputSink
do
	LogEventRobloxOutputSink = setmetatable({}, {
		__tostring = function()
			return "LogEventRobloxOutputSink"
		end,
	})
	LogEventRobloxOutputSink.__index = LogEventRobloxOutputSink
	function LogEventRobloxOutputSink.new(...)
		local self = setmetatable({}, LogEventRobloxOutputSink)
		return self:constructor(...) or self
	end
	function LogEventRobloxOutputSink:constructor(options)
		self.options = options
	end
	function LogEventRobloxOutputSink:Emit(message)
		local _binding = self.options
		local TagFormat = _binding.TagFormat
		if TagFormat == nil then
			TagFormat = "short"
		end
		local ErrorsTreatedAsExceptions = _binding.ErrorsTreatedAsExceptions
		local Prefix = _binding.Prefix
		if message.Level >= LogLevel.Error and ErrorsTreatedAsExceptions then
			return nil
		end
		local template = PlainTextMessageTemplateRenderer.new(MessageTemplateParser.GetTokens(message.Template))
		local _time = DateTime.fromIsoDate(message.Timestamp)
		if _time ~= nil then
			_time = _time:FormatLocalTime("HH:mm:ss", "en-us")
		end
		local time = _time
		local tag
		local _exp = message.Level
		repeat
			if _exp == (LogLevel.Verbose) then
				tag = TagFormat == "short" and "VRB" or "VERBOSE"
				break
			end
			if _exp == (LogLevel.Debugging) then
				tag = TagFormat == "short" and "DBG" or "DEBUG"
				break
			end
			if _exp == (LogLevel.Information) then
				tag = TagFormat == "short" and "INF" or "INFO"
				break
			end
			if _exp == (LogLevel.Warning) then
				tag = TagFormat == "short" and "WRN" or "WARNING"
				break
			end
			if _exp == (LogLevel.Error) then
				tag = TagFormat == "short" and "ERR" or "ERROR"
				break
			end
			if _exp == (LogLevel.Fatal) then
				tag = TagFormat == "short" and "FTL" or "FATAL"
				break
			end
		until true
		local messageRendered = template:Render(message)
		local formattedMessage = Prefix ~= nil and "[" .. (Prefix .. ("] [" .. (tag .. ("] " .. messageRendered)))) or "[" .. (tag .. ("] " .. messageRendered))
		if message.Level >= LogLevel.Warning then
			warn(formattedMessage)
		else
			print(formattedMessage)
		end
	end
end
return {
	LogEventRobloxOutputSink = LogEventRobloxOutputSink,
}
 end, newEnv("Pombium.include.node_modules.log.out.Core.LogEventRobloxOutputSink"))() end)

newModule("Logger", "ModuleScript", "Pombium.include.node_modules.log.out.Logger", "Pombium.include.node_modules.log.out", function () return setfenv(function() -- Compiled with roblox-ts v1.3.3
local TS = _G[script]
local MessageTemplateParser = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out.MessageTemplateParser).MessageTemplateParser
local _MessageTemplateToken = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out.MessageTemplateToken)
local DestructureMode = _MessageTemplateToken.DestructureMode
local TemplateTokenKind = _MessageTemplateToken.TemplateTokenKind
local LogLevel = TS.import(script, script.Parent, "Core").LogLevel
local LogConfiguration = TS.import(script, script.Parent, "Configuration").LogConfiguration
local PlainTextMessageTemplateRenderer = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out).PlainTextMessageTemplateRenderer
local RbxSerializer = TS.import(script, TS.getModule(script, "@rbxts", "message-templates").out.RbxSerializer).RbxSerializer
local Logger
do
	Logger = setmetatable({}, {
		__tostring = function()
			return "Logger"
		end,
	})
	Logger.__index = Logger
	function Logger.new(...)
		local self = setmetatable({}, Logger)
		return self:constructor(...) or self
	end
	function Logger:constructor()
		self.logLevel = LogLevel.Information
		self.sinks = {}
		self.enrichers = {}
	end
	function Logger:configure()
		return LogConfiguration.new(Logger.new())
	end
	function Logger:SetSinks(sinks)
		self.sinks = sinks
	end
	function Logger:SetEnrichers(enrichers)
		self.enrichers = enrichers
	end
	function Logger:SetMinLogLevel(logLevel)
		self.logLevel = logLevel
	end
	function Logger:default()
		return self.defaultLogger
	end
	function Logger:_serializeValue(value)
		if typeof(value) == "Vector3" then
			return {
				X = value.X,
				Y = value.Y,
				Z = value.Z,
			}
		elseif typeof(value) == "Vector2" then
			return {
				X = value.X,
				Y = value.Y,
			}
		elseif typeof(value) == "Instance" then
			return value:GetFullName()
		elseif typeof(value) == "EnumItem" then
			return tostring(value)
		elseif type(value) == "string" or (type(value) == "number" or (type(value) == "boolean" or type(value) == "table")) then
			return value
		else
			return tostring(value)
		end
	end
	function Logger:Write(logLevel, template, ...)
		local args = { ... }
		local message = {
			Level = logLevel,
			SourceContext = nil,
			Template = template,
			Timestamp = DateTime.now():ToIsoDate(),
		}
		local tokens = MessageTemplateParser.GetTokens(template)
		local _arg0 = function(t)
			return t.kind == TemplateTokenKind.Property
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(tokens) do
			if _arg0(_v, _k - 1, tokens) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local propertyTokens = _newValue
		local idx = 0
		for _, token in ipairs(propertyTokens) do
			local _exp = args
			local _original = idx
			idx += 1
			local arg = _exp[_original + 1]
			if idx <= #args then
				if arg ~= nil then
					if token.destructureMode == DestructureMode.ToString then
						message[token.propertyName] = tostring(arg)
					else
						message[token.propertyName] = type(arg) == "table" and arg or RbxSerializer.Serialize(arg)
					end
				end
			end
		end
		for _, enricher in ipairs(self.enrichers) do
			local toApply = {}
			enricher:Enrich(message, toApply)
			for key, value in pairs(toApply) do
				message[key] = type(value) == "table" and value or RbxSerializer.Serialize(value)
			end
		end
		for _, sink in ipairs(self.sinks) do
			sink:Emit(message)
		end
		return PlainTextMessageTemplateRenderer.new(tokens):Render(message)
	end
	function Logger:GetLevel()
		return self.logLevel
	end
	function Logger:Verbose(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Verbose then
			return nil
		end
		self:Write(LogLevel.Verbose, template, ...)
	end
	function Logger:Info(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Information then
			return nil
		end
		self:Write(LogLevel.Information, template, ...)
	end
	function Logger:Debug(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Debugging then
			return nil
		end
		self:Write(LogLevel.Debugging, template, ...)
	end
	function Logger:Warn(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Warning then
			return nil
		end
		self:Write(LogLevel.Warning, template, ...)
	end
	function Logger:Error(template, ...)
		local args = { ... }
		if self:GetLevel() > LogLevel.Error then
			return nil
		end
		return self:Write(LogLevel.Error, template, ...)
	end
	function Logger:Fatal(template, ...)
		local args = { ... }
		return self:Write(LogLevel.Fatal, template, ...)
	end
	function Logger:Copy()
		local config = LogConfiguration.new(Logger.new())
		config:SetMinLogLevel(self:GetLevel())
		for _, sink in ipairs(self.sinks) do
			config:WriteTo(sink)
		end
		for _, enricher in ipairs(self.enrichers) do
			config:Enrich(enricher)
		end
		return config
	end
	function Logger:ForContext(context, contextConfiguration)
		local copy = self:Copy()
		local sourceContext
		if typeof(context) == "Instance" then
			sourceContext = context:GetFullName()
		else
			sourceContext = tostring(context)
		end
		local _result = contextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		return copy:EnrichWithProperties({
			SourceContext = sourceContext,
			SourceKind = "Context",
		}):Create()
	end
	function Logger:ForScript(scriptContextConfiguration)
		local s = debug.info(2, "s")
		local copy = self:Copy()
		local _result = scriptContextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		return copy:EnrichWithProperties({
			SourceContext = s,
			SourceKind = "Script",
		}):Create()
	end
	function Logger:ForFunction(func, funcContextConfiguration)
		local funcName, funcLine, funcSource = debug.info(func, "nls")
		local copy = self:Copy()
		local _result = funcContextConfiguration
		if _result ~= nil then
			_result(copy)
		end
		local _fn = copy
		local _object = {}
		local _left = "SourceContext"
		local _condition = funcName
		if _condition == nil then
			_condition = "(anonymous)"
		end
		_object[_left] = "function '" .. (_condition .. "'")
		_object.SourceLine = funcLine
		_object.SourceFile = funcSource
		_object.SourceKind = "Function"
		return _fn:EnrichWithProperties(_object):Create()
	end
	function Logger:ForProperty(name, value)
		return self:Copy():EnrichWithProperty(name, value):Create()
	end
	function Logger:ForProperties(props)
		return self:Copy():EnrichWithProperties(props):Create()
	end
	Logger.defaultLogger = Logger.new()
end
return {
	Logger = Logger,
}
 end, newEnv("Pombium.include.node_modules.log.out.Logger"))() end)

newInstance("message-templates", "Folder", "Pombium.include.node_modules.message-templates", "Pombium.include.node_modules")

newModule("out", "ModuleScript", "Pombium.include.node_modules.message-templates.out", "Pombium.include.node_modules.message-templates", function () return setfenv(function() -- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local exports = {}
exports.MessageTemplateParser = TS.import(script, script, "MessageTemplateParser").MessageTemplateParser
exports.MessageTemplateRenderer = TS.import(script, script, "MessageTemplateRenderer").MessageTemplateRenderer
exports.PlainTextMessageTemplateRenderer = TS.import(script, script, "PlainTextMessageTemplateRenderer").PlainTextMessageTemplateRenderer
exports.TemplateTokenKind = TS.import(script, script, "MessageTemplateToken").TemplateTokenKind
return exports
 end, newEnv("Pombium.include.node_modules.message-templates.out"))() end)

newModule("MessageTemplate", "ModuleScript", "Pombium.include.node_modules.message-templates.out.MessageTemplate", "Pombium.include.node_modules.message-templates.out", function () return setfenv(function() -- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local TemplateTokenKind = TS.import(script, script.Parent, "MessageTemplateToken").TemplateTokenKind
local HttpService = game:GetService("HttpService")
local MessageTemplate
do
	MessageTemplate = setmetatable({}, {
		__tostring = function()
			return "MessageTemplate"
		end,
	})
	MessageTemplate.__index = MessageTemplate
	function MessageTemplate.new(...)
		local self = setmetatable({}, MessageTemplate)
		return self:constructor(...) or self
	end
	function MessageTemplate:constructor(template, tokens)
		self.template = template
		self.tokens = tokens
		local _arg0 = function(f)
			return f.kind == TemplateTokenKind.Property
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(tokens) do
			if _arg0(_v, _k - 1, tokens) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		self.properties = _newValue
	end
	function MessageTemplate:GetTokens()
		return self.tokens
	end
	function MessageTemplate:GetProperties()
		return self.properties
	end
	function MessageTemplate:GetText()
		return self.template
	end
end
return {
	MessageTemplate = MessageTemplate,
}
 end, newEnv("Pombium.include.node_modules.message-templates.out.MessageTemplate"))() end)

newModule("MessageTemplateParser", "ModuleScript", "Pombium.include.node_modules.message-templates.out.MessageTemplateParser", "Pombium.include.node_modules.message-templates.out", function () return setfenv(function() -- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local _MessageTemplateToken = TS.import(script, script.Parent, "MessageTemplateToken")
local DestructureMode = _MessageTemplateToken.DestructureMode
local TemplateTokenKind = _MessageTemplateToken.TemplateTokenKind
local MessageTemplateParser = {}
do
	local _container = MessageTemplateParser
	local tokenize
	local function GetTokens(message)
		local tokens = {}
		for _result in tokenize(message).next do
			if _result.done then
				break
			end
			local token = _result.value
			-- ▼ Array.push ▼
			tokens[#tokens + 1] = token
			-- ▲ Array.push ▲
		end
		return tokens
	end
	_container.GetTokens = GetTokens
	local parseText, parseProperty
	function tokenize(messageTemplate)
		return TS.generator(function()
			if #messageTemplate == 0 then
				local _arg0 = {
					kind = TemplateTokenKind.Text,
					text = "",
				}
				coroutine.yield(_arg0)
				return nil
			end
			local nextIndex = 0
			while true do
				local startIndex = nextIndex
				local textToken
				local _binding = parseText(nextIndex, messageTemplate)
				nextIndex = _binding[1]
				textToken = _binding[2]
				if nextIndex > startIndex then
					coroutine.yield(textToken)
				end
				if nextIndex >= #messageTemplate then
					break
				end
				startIndex = nextIndex
				local propertyToken
				local _binding_1 = parseProperty(nextIndex, messageTemplate)
				nextIndex = _binding_1[1]
				propertyToken = _binding_1[2]
				if startIndex < nextIndex then
					coroutine.yield(propertyToken)
				end
				if nextIndex > #messageTemplate then
					break
				end
			end
		end)
	end
	function parseText(startAt, messageTemplate)
		local results = {}
		repeat
			do
				local char = string.sub(messageTemplate, startAt, startAt)
				if char == "{" then
					local _arg0 = startAt + 1
					local _arg1 = startAt + 1
					local nextChar = string.sub(messageTemplate, _arg0, _arg1)
					if nextChar == "{" then
						-- ▼ Array.push ▼
						results[#results + 1] = char
						-- ▲ Array.push ▲
						startAt += 1
					else
						break
					end
				else
					-- ▼ Array.push ▼
					results[#results + 1] = char
					-- ▲ Array.push ▲
					local _arg0 = startAt + 1
					local _arg1 = startAt + 1
					local nextChar = string.sub(messageTemplate, _arg0, _arg1)
					if char == "}" then
						if nextChar == "}" then
							startAt += 1
						end
					end
				end
				startAt += 1
			end
		until not (startAt <= #messageTemplate)
		local _ptr = {
			kind = TemplateTokenKind.Text,
		}
		local _left = "text"
		-- ▼ ReadonlyArray.join ▼
		local _arg0 = ""
		if _arg0 == nil then
			_arg0 = ", "
		end
		-- ▲ ReadonlyArray.join ▲
		_ptr[_left] = table.concat(results, _arg0)
		return { startAt, _ptr }
	end
	local function readWhile(startAt, text, condition)
		local result = ""
		while startAt < #text and condition(string.sub(text, startAt, startAt)) do
			local char = string.sub(text, startAt, startAt)
			result ..= char
			startAt += 1
		end
		return { startAt, result }
	end
	local function isValidNameCharacter(char)
		return (string.match(char, "[%w_]")) ~= nil
	end
	local function isValidDestructureHint(char)
		return (string.match(char, "[@$]")) ~= nil
	end
	function parseProperty(index, messageTemplate)
		index += 1
		local propertyName
		local _binding = readWhile(index, messageTemplate, function(c)
			return isValidDestructureHint(c) or (isValidNameCharacter(c) and c ~= "}")
		end)
		index = _binding[1]
		propertyName = _binding[2]
		if index > #messageTemplate then
			local _arg0 = {
				kind = TemplateTokenKind.Text,
				text = propertyName,
			}
			return { index, _arg0 }
		end
		local destructureMode = DestructureMode.Default
		local char = string.sub(propertyName, 1, 1)
		if isValidDestructureHint(char) then
			repeat
				if char == ("@") then
					destructureMode = DestructureMode.Destructure
					break
				end
				if char == ("$") then
					destructureMode = DestructureMode.ToString
					break
				end
				destructureMode = DestructureMode.Default
			until true
			propertyName = string.sub(propertyName, 2)
		end
		local _exp = index + 1
		local _arg0 = {
			kind = TemplateTokenKind.Property,
			propertyName = propertyName,
			destructureMode = destructureMode,
		}
		return { _exp, _arg0 }
	end
end
return {
	MessageTemplateParser = MessageTemplateParser,
}
 end, newEnv("Pombium.include.node_modules.message-templates.out.MessageTemplateParser"))() end)

newModule("MessageTemplateRenderer", "ModuleScript", "Pombium.include.node_modules.message-templates.out.MessageTemplateRenderer", "Pombium.include.node_modules.message-templates.out", function () return setfenv(function() -- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local TemplateTokenKind = TS.import(script, script.Parent, "MessageTemplateToken").TemplateTokenKind
local MessageTemplateRenderer
do
	MessageTemplateRenderer = {}
	function MessageTemplateRenderer:constructor(tokens)
		self.tokens = tokens
	end
	function MessageTemplateRenderer:Render(properties)
		local result = ""
		for _, token in ipairs(self.tokens) do
			local _exp = token.kind
			repeat
				local _fallthrough = false
				if _exp == (TemplateTokenKind.Property) then
					result ..= self:RenderPropertyToken(token, properties[token.propertyName])
					break
				end
				if _exp == (TemplateTokenKind.Text) then
					result ..= self:RenderTextToken(token)
				end
			until true
		end
		return result
	end
end
return {
	MessageTemplateRenderer = MessageTemplateRenderer,
}
 end, newEnv("Pombium.include.node_modules.message-templates.out.MessageTemplateRenderer"))() end)

newModule("MessageTemplateToken", "ModuleScript", "Pombium.include.node_modules.message-templates.out.MessageTemplateToken", "Pombium.include.node_modules.message-templates.out", function () return setfenv(function() -- Compiled with roblox-ts v1.2.2
local TemplateTokenKind
do
	local _inverse = {}
	TemplateTokenKind = setmetatable({}, {
		__index = _inverse,
	})
	TemplateTokenKind.Text = 0
	_inverse[0] = "Text"
	TemplateTokenKind.Property = 1
	_inverse[1] = "Property"
end
local DestructureMode
do
	local _inverse = {}
	DestructureMode = setmetatable({}, {
		__index = _inverse,
	})
	DestructureMode.Default = 0
	_inverse[0] = "Default"
	DestructureMode.ToString = 1
	_inverse[1] = "ToString"
	DestructureMode.Destructure = 2
	_inverse[2] = "Destructure"
end
local function createNode(prop)
	return prop
end
return {
	createNode = createNode,
	TemplateTokenKind = TemplateTokenKind,
	DestructureMode = DestructureMode,
}
 end, newEnv("Pombium.include.node_modules.message-templates.out.MessageTemplateToken"))() end)

newModule("PlainTextMessageTemplateRenderer", "ModuleScript", "Pombium.include.node_modules.message-templates.out.PlainTextMessageTemplateRenderer", "Pombium.include.node_modules.message-templates.out", function () return setfenv(function() -- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local RbxSerializer = TS.import(script, script.Parent, "RbxSerializer").RbxSerializer
local MessageTemplateRenderer = TS.import(script, script.Parent, "MessageTemplateRenderer").MessageTemplateRenderer
local HttpService = game:GetService("HttpService")
local PlainTextMessageTemplateRenderer
do
	local super = MessageTemplateRenderer
	PlainTextMessageTemplateRenderer = setmetatable({}, {
		__tostring = function()
			return "PlainTextMessageTemplateRenderer"
		end,
		__index = super,
	})
	PlainTextMessageTemplateRenderer.__index = PlainTextMessageTemplateRenderer
	function PlainTextMessageTemplateRenderer.new(...)
		local self = setmetatable({}, PlainTextMessageTemplateRenderer)
		return self:constructor(...) or self
	end
	function PlainTextMessageTemplateRenderer:constructor(...)
		super.constructor(self, ...)
	end
	function PlainTextMessageTemplateRenderer:RenderPropertyToken(propertyToken, value)
		local serialized = RbxSerializer.Serialize(value, propertyToken.destructureMode)
		if type(serialized) == "table" then
			return HttpService:JSONEncode(serialized)
		else
			return tostring(serialized)
		end
	end
	function PlainTextMessageTemplateRenderer:RenderTextToken(textToken)
		return textToken.text
	end
end
return {
	PlainTextMessageTemplateRenderer = PlainTextMessageTemplateRenderer,
}
 end, newEnv("Pombium.include.node_modules.message-templates.out.PlainTextMessageTemplateRenderer"))() end)

newModule("RbxSerializer", "ModuleScript", "Pombium.include.node_modules.message-templates.out.RbxSerializer", "Pombium.include.node_modules.message-templates.out", function () return setfenv(function() -- Compiled with roblox-ts v1.2.2
local TS = _G[script]
local DestructureMode = TS.import(script, script.Parent, "MessageTemplateToken").DestructureMode
--[[
	*
	* Handles serialization of Roblox objects for use in event data
]]
local RbxSerializer = {}
do
	local _container = RbxSerializer
	local HttpService = game:GetService("HttpService")
	local function SerializeVector3(value)
		return {
			X = value.X,
			Y = value.Y,
			Z = value.Z,
		}
	end
	_container.SerializeVector3 = SerializeVector3
	local function SerializeVector2(value)
		return {
			X = value.X,
			Y = value.Y,
		}
	end
	_container.SerializeVector2 = SerializeVector2
	local function SerializeNumberRange(numberRange)
		return {
			Min = numberRange.Min,
			Max = numberRange.Max,
		}
	end
	_container.SerializeNumberRange = SerializeNumberRange
	local function SerializeDateTime(dateTime)
		return dateTime:ToIsoDate()
	end
	_container.SerializeDateTime = SerializeDateTime
	local function SerializeEnumItem(enumItem)
		return tostring(enumItem)
	end
	_container.SerializeEnumItem = SerializeEnumItem
	local function SerializeUDim(value)
		return {
			Offset = value.Offset,
			Scale = value.Scale,
		}
	end
	_container.SerializeUDim = SerializeUDim
	local function SerializeUDim2(value)
		return {
			X = SerializeUDim(value.X),
			Y = SerializeUDim(value.Y),
		}
	end
	_container.SerializeUDim2 = SerializeUDim2
	local function SerializeColor3(color3)
		return {
			R = color3.R,
			G = color3.G,
			B = color3.B,
		}
	end
	_container.SerializeColor3 = SerializeColor3
	local function SerializeBrickColor(color)
		return SerializeColor3(color.Color)
	end
	_container.SerializeBrickColor = SerializeBrickColor
	local function SerializeRect(value)
		return {
			RectMin = SerializeVector2(value.Min),
			RectMax = SerializeVector2(value.Max),
			RectHeight = value.Height,
			RectWidth = value.Width,
		}
	end
	_container.SerializeRect = SerializeRect
	local function SerializePathWaypoint(value)
		return {
			WaypointAction = SerializeEnumItem(value.Action),
			WaypointPosition = SerializeVector3(value.Position),
		}
	end
	_container.SerializePathWaypoint = SerializePathWaypoint
	local function SerializeColorSequenceKeypoint(value)
		return {
			ColorTime = value.Time,
			ColorValue = SerializeColor3(value.Value),
		}
	end
	_container.SerializeColorSequenceKeypoint = SerializeColorSequenceKeypoint
	local function SerializeColorSequence(value)
		local _ptr = {}
		local _left = "ColorKeypoints"
		local _keypoints = value.Keypoints
		local _arg0 = function(v)
			return SerializeColorSequenceKeypoint(v)
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_keypoints)
		for _k, _v in ipairs(_keypoints) do
			_newValue[_k] = _arg0(_v, _k - 1, _keypoints)
		end
		-- ▲ ReadonlyArray.map ▲
		_ptr[_left] = _newValue
		return _ptr
	end
	_container.SerializeColorSequence = SerializeColorSequence
	local function SerializeNumberSequenceKeypoint(value)
		return {
			NumberTime = value.Time,
			NumberValue = value.Value,
		}
	end
	_container.SerializeNumberSequenceKeypoint = SerializeNumberSequenceKeypoint
	local function SerializeNumberSequence(value)
		local _ptr = {}
		local _left = "NumberKeypoints"
		local _keypoints = value.Keypoints
		local _arg0 = function(v)
			return SerializeNumberSequenceKeypoint(v)
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_keypoints)
		for _k, _v in ipairs(_keypoints) do
			_newValue[_k] = _arg0(_v, _k - 1, _keypoints)
		end
		-- ▲ ReadonlyArray.map ▲
		_ptr[_left] = _newValue
		return _ptr
	end
	_container.SerializeNumberSequence = SerializeNumberSequence
	local function Serialize(value, destructureMode)
		if destructureMode == nil then
			destructureMode = DestructureMode.Default
		end
		if destructureMode == DestructureMode.ToString then
			return tostring(value)
		end
		if typeof(value) == "Instance" then
			return value:GetFullName()
		elseif type(value) == "vector" or typeof(value) == "Vector3int16" then
			return SerializeVector3(value)
		elseif typeof(value) == "Vector2" or typeof(value) == "Vector2int16" then
			return SerializeVector2(value)
		elseif typeof(value) == "DateTime" then
			return SerializeDateTime(value)
		elseif typeof(value) == "EnumItem" then
			return SerializeEnumItem(value)
		elseif typeof(value) == "NumberRange" then
			return SerializeNumberRange(value)
		elseif typeof(value) == "UDim" then
			return SerializeUDim(value)
		elseif typeof(value) == "UDim2" then
			return SerializeUDim2(value)
		elseif typeof(value) == "Color3" then
			return SerializeColor3(value)
		elseif typeof(value) == "BrickColor" then
			return SerializeBrickColor(value)
		elseif typeof(value) == "Rect" then
			return SerializeRect(value)
		elseif typeof(value) == "PathWaypoint" then
			return SerializePathWaypoint(value)
		elseif typeof(value) == "ColorSequenceKeypoint" then
			return SerializeColorSequenceKeypoint(value)
		elseif typeof(value) == "ColorSequence" then
			return SerializeColorSequence(value)
		elseif typeof(value) == "NumberSequenceKeypoint" then
			return SerializeNumberSequenceKeypoint(value)
		elseif typeof(value) == "NumberSequence" then
			return SerializeNumberSequence(value)
		elseif type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
			return value
		elseif type(value) == "table" then
			return HttpService:JSONEncode(value)
		elseif type(value) == "nil" then
			return nil
		else
			error("Destructuring of '" .. typeof(value) .. "' not supported by Serializer")
		end
	end
	_container.Serialize = Serialize
end
return {
	RbxSerializer = RbxSerializer,
}
 end, newEnv("Pombium.include.node_modules.message-templates.out.RbxSerializer"))() end)

newModule("promise-character", "ModuleScript", "Pombium.include.node_modules.promise-character", "Pombium.include.node_modules", function () return setfenv(function() -- Compiled with roblox-ts v1.2.3
local TS = _G[script]
local promiseTree = TS.import(script, TS.getModule(script, "@rbxts", "validate-tree")).promiseTree
local CharacterRigR6 = {
	["$className"] = "Model",
	Head = {
		["$className"] = "Part",
		FaceCenterAttachment = "Attachment",
		FaceFrontAttachment = "Attachment",
		HairAttachment = "Attachment",
		HatAttachment = "Attachment",
	},
	HumanoidRootPart = {
		["$className"] = "BasePart",
		RootAttachment = "Attachment",
		RootJoint = "Motor6D",
	},
	Humanoid = {
		["$className"] = "Humanoid",
		Animator = "Animator",
		HumanoidDescription = "HumanoidDescription",
	},
	["Left Arm"] = {
		["$className"] = "BasePart",
		LeftGripAttachment = "Attachment",
		LeftShoulderAttachment = "Attachment",
	},
	["Left Leg"] = {
		["$className"] = "BasePart",
		LeftFootAttachment = "Attachment",
	},
	["Right Arm"] = {
		["$className"] = "BasePart",
		RightGripAttachment = "Attachment",
		RightShoulderAttachment = "Attachment",
	},
	["Right Leg"] = {
		["$className"] = "BasePart",
		RightFootAttachment = "Attachment",
	},
	Torso = {
		["$className"] = "BasePart",
		["Left Hip"] = "Motor6D",
		["Left Shoulder"] = "Motor6D",
		["Right Hip"] = "Motor6D",
		["Right Shoulder"] = "Motor6D",
		Neck = "Motor6D",
		BodyBackAttachment = "Attachment",
		BodyFrontAttachment = "Attachment",
		LeftCollarAttachment = "Attachment",
		NeckAttachment = "Attachment",
		RightCollarAttachment = "Attachment",
		WaistBackAttachment = "Attachment",
		WaistCenterAttachment = "Attachment",
		WaistFrontAttachment = "Attachment",
	},
	["Body Colors"] = "BodyColors",
}
local CharacterRigR15 = {
	["$className"] = "Model",
	HumanoidRootPart = {
		["$className"] = "BasePart",
		RootRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		OriginalSize = "Vector3Value",
	},
	LeftHand = {
		["$className"] = "MeshPart",
		LeftWristRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftGripAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftWrist = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	LeftLowerArm = {
		["$className"] = "MeshPart",
		LeftElbowRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftWristRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftElbow = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	LeftUpperArm = {
		["$className"] = "MeshPart",
		LeftShoulderRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftElbowRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftShoulderAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftShoulder = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	RightHand = {
		["$className"] = "MeshPart",
		RightWristRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightGripAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightWrist = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	RightLowerArm = {
		["$className"] = "MeshPart",
		RightElbowRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightWristRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightElbow = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	RightUpperArm = {
		["$className"] = "MeshPart",
		RightShoulderRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightElbowRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightShoulderAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightShoulder = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	UpperTorso = {
		["$className"] = "MeshPart",
		WaistRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		NeckRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftShoulderRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightShoulderRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		BodyFrontAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		BodyBackAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftCollarAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightCollarAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		NeckAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		Waist = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	LeftFoot = {
		["$className"] = "MeshPart",
		LeftAnkleRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftAnkle = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	LeftLowerLeg = {
		["$className"] = "MeshPart",
		LeftKneeRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftAnkleRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftKnee = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	LeftUpperLeg = {
		["$className"] = "MeshPart",
		LeftHipRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftKneeRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftHip = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	RightFoot = {
		["$className"] = "MeshPart",
		RightAnkleRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightAnkle = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	RightLowerLeg = {
		["$className"] = "MeshPart",
		RightKneeRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightAnkleRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightKnee = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	RightUpperLeg = {
		["$className"] = "MeshPart",
		RightHipRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightKneeRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightHip = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	LowerTorso = {
		["$className"] = "MeshPart",
		RootRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		WaistRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		LeftHipRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		RightHipRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		WaistCenterAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		WaistFrontAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		WaistBackAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		Root = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	Humanoid = {
		["$className"] = "Humanoid",
		Animator = "Animator",
		BodyTypeScale = "NumberValue",
		BodyProportionScale = "NumberValue",
		BodyWidthScale = "NumberValue",
		BodyHeightScale = "NumberValue",
		BodyDepthScale = "NumberValue",
		HeadScale = "NumberValue",
		HumanoidDescription = "HumanoidDescription",
	},
	Head = {
		["$className"] = "MeshPart",
		FaceCenterAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		FaceFrontAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		HairAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		HatAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		NeckRigAttachment = {
			["$className"] = "Attachment",
			OriginalPosition = "Vector3Value",
		},
		Neck = "Motor6D",
		OriginalSize = "Vector3Value",
	},
	["Body Colors"] = "BodyColors",
}
-- * Yields until every member of CharacterRigR6 exists
local function promiseR6(character)
	return promiseTree(character, CharacterRigR6)
end
-- * Yields until every member of CharacterRigR15 exists
local function promiseR15(character)
	return promiseTree(character, CharacterRigR15)
end
local default = promiseR15
return {
	promiseR6 = promiseR6,
	promiseR15 = promiseR15,
	CharacterRigR6 = CharacterRigR6,
	CharacterRigR15 = CharacterRigR15,
	default = default,
}
 end, newEnv("Pombium.include.node_modules.promise-character"))() end)

newInstance("node_modules", "Folder", "Pombium.include.node_modules.promise-character.node_modules", "Pombium.include.node_modules.promise-character")

newInstance("@rbxts", "Folder", "Pombium.include.node_modules.promise-character.node_modules.@rbxts", "Pombium.include.node_modules.promise-character.node_modules")

newInstance("compiler-types", "Folder", "Pombium.include.node_modules.promise-character.node_modules.@rbxts.compiler-types", "Pombium.include.node_modules.promise-character.node_modules.@rbxts")

newInstance("types", "Folder", "Pombium.include.node_modules.promise-character.node_modules.@rbxts.compiler-types.types", "Pombium.include.node_modules.promise-character.node_modules.@rbxts.compiler-types")

newModule("promise-child", "ModuleScript", "Pombium.include.node_modules.promise-child", "Pombium.include.node_modules", function () return setfenv(function() -- Compiled with roblox-ts v1.2.3
local TS = _G[script]
local function promiseChildWhichIsA(parent, className)
	local child = parent:FindFirstChildWhichIsA(className)
	if child then
		return TS.Promise.resolve(child)
	end
	local warner = TS.Promise.delay(5)
	local _arg0 = function()
		return warn('[promiseChildWhichIsA] Infinite wait possible for a "' .. className .. '" to appear under ' .. parent:GetFullName())
	end
	warner:andThen(_arg0)
	local connection1
	local connection2
	local promise = TS.Promise.new(function(resolve, reject)
		connection1 = parent.ChildAdded:Connect(function(child)
			return child:IsA(className) and resolve(child)
		end)
		connection2 = parent.AncestryChanged:Connect(function(_, newParent)
			return newParent or reject(parent:GetFullName() .. " had its root parent set to nil")
		end)
	end)
	promise:finally(function()
		warner:cancel()
		connection1:Disconnect()
		connection2:Disconnect()
	end)
	return promise
end
local function promiseChildOfClass(parent, className)
	local child = parent:FindFirstChildOfClass(className)
	if child then
		return TS.Promise.resolve(child)
	end
	local warner = TS.Promise.delay(5)
	local _arg0 = function()
		return warn('[promiseChildOfClass] Infinite wait possible for a "' .. className .. '" to appear under ' .. parent:GetFullName())
	end
	warner:andThen(_arg0)
	local connection1
	local connection2
	local promise = TS.Promise.new(function(resolve, reject)
		connection1 = parent.ChildAdded:Connect(function(child)
			return child.ClassName == className and resolve(child)
		end)
		connection2 = parent.AncestryChanged:Connect(function(_, newParent)
			return newParent or reject(parent:GetFullName() .. " had its root parent set to nil")
		end)
	end)
	promise:finally(function()
		warner:cancel()
		connection1:Disconnect()
		connection2:Disconnect()
	end)
	return promise
end
local function promiseChild(parent, childName)
	local child = parent:FindFirstChild(childName)
	if child then
		return TS.Promise.resolve(child)
	end
	local connections = {}
	local warner = TS.Promise.delay(5)
	local _arg0 = function()
		return warn('[promiseChild] Infinite wait possible for "' .. tostring(childName) .. '" to appear under ' .. parent:GetFullName())
	end
	warner:andThen(_arg0)
	local promise = TS.Promise.new(function(resolve, reject)
		local _arg0_1 = parent.ChildAdded:Connect(function(child)
			if child.Name == childName then
				resolve(child)
			else
				local _arg0_2 = child:GetPropertyChangedSignal("Name"):Connect(function()
					return child.Name == childName and child.Parent == parent and resolve(child)
				end)
				-- ▼ Array.push ▼
				connections[#connections + 1] = _arg0_2
				-- ▲ Array.push ▲
			end
		end)
		-- ▼ Array.push ▼
		connections[#connections + 1] = _arg0_1
		-- ▲ Array.push ▲
		local _arg0_2 = parent.AncestryChanged:Connect(function(_, newParent)
			return newParent or reject(parent:GetFullName() .. " had its root parent set to nil")
		end)
		-- ▼ Array.push ▼
		connections[#connections + 1] = _arg0_2
		-- ▲ Array.push ▲
	end)
	promise:finally(function()
		warner:cancel()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
	end)
	return promise
end
return {
	promiseChildWhichIsA = promiseChildWhichIsA,
	promiseChildOfClass = promiseChildOfClass,
	promiseChild = promiseChild,
}
 end, newEnv("Pombium.include.node_modules.promise-child"))() end)

newModule("services", "ModuleScript", "Pombium.include.node_modules.services", "Pombium.include.node_modules", function () return setfenv(function() return setmetatable({}, {
	__index = function(self, serviceName)
		local service = game:GetService(serviceName)
		self[serviceName] = service
		return service
	end,
})
 end, newEnv("Pombium.include.node_modules.services"))() end)

newModule("signal", "ModuleScript", "Pombium.include.node_modules.signal", "Pombium.include.node_modules", function () return setfenv(function() local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		Bindable = Instance.new("BindableEvent");
	}, Signal)
end

function Signal:Connect(Callback)
	return self.Bindable.Event:Connect(function(GetArguments)
		Callback(GetArguments())
	end)
end

function Signal:Fire(...)
	local Arguments = { ... }
	local n = select("#", ...)

	self.Bindable:Fire(function()
		return table.unpack(Arguments, 1, n)
	end)
end

function Signal:Wait()
	return self.Bindable.Event:Wait()()
end

function Signal:Destroy()
	self.Bindable:Destroy()
end

return Signal
 end, newEnv("Pombium.include.node_modules.signal"))() end)

newInstance("signals-tooling", "Folder", "Pombium.include.node_modules.signals-tooling", "Pombium.include.node_modules")

newModule("out", "ModuleScript", "Pombium.include.node_modules.signals-tooling.out", "Pombium.include.node_modules.signals-tooling", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local TS = _G[script]
local exports = {}
-- Interfaces
-- Classes
for _k, _v in pairs(TS.import(script, script, "Implementation", "ConnectionManager")) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script, "Implementation", "Signal")) do
	exports[_k] = _v
end
-- Types
-- Functions
for _k, _v in pairs(TS.import(script, script, "Functions", "ListenOnce")) do
	exports[_k] = _v
end
for _k, _v in pairs(TS.import(script, script, "Functions", "WaitForFirstSignal")) do
	exports[_k] = _v
end
return exports
 end, newEnv("Pombium.include.node_modules.signals-tooling.out"))() end)

newInstance("Functions", "Folder", "Pombium.include.node_modules.signals-tooling.out.Functions", "Pombium.include.node_modules.signals-tooling.out")

newModule("ListenOnce", "ModuleScript", "Pombium.include.node_modules.signals-tooling.out.Functions.ListenOnce", "Pombium.include.node_modules.signals-tooling.out.Functions", function () return setfenv(function() local exports = {}

function exports.listenOnce(signal, callback)
	local connection
	connection = signal:Connect(function(...)
		connection:Disconnect()
		callback(...)
	end)
	return connection
end

return exports
 end, newEnv("Pombium.include.node_modules.signals-tooling.out.Functions.ListenOnce"))() end)

newModule("WaitForFirstSignal", "ModuleScript", "Pombium.include.node_modules.signals-tooling.out.Functions.WaitForFirstSignal", "Pombium.include.node_modules.signals-tooling.out.Functions", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local TS = _G[script]
local Signal = TS.import(script, script.Parent.Parent, "Implementation", "Signal").Signal
-- Credit to Tiffblocks
-- Adapted to TypeScript by NoahWillCode
local function waitForFirstSignal(...)
	local signals = { ... }
	local finalSignal = Signal.new()
	local connections = {}
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #signals) then
				break
			end
			local signal = signals[i + 1]
			local _arg0 = signal:Connect(function(...)
				local args = { ... }
				finalSignal:fire(signal, args)
			end)
			-- ▼ Array.push ▼
			connections[#connections + 1] = _arg0
			-- ▲ Array.push ▲
		end
	end
	local finalArgs = { finalSignal:Wait() }
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #connections) then
				break
			end
			connections[i + 1]:Disconnect()
		end
	end
	return unpack(finalArgs)
end
return {
	waitForFirstSignal = waitForFirstSignal,
}
 end, newEnv("Pombium.include.node_modules.signals-tooling.out.Functions.WaitForFirstSignal"))() end)

newInstance("Implementation", "Folder", "Pombium.include.node_modules.signals-tooling.out.Implementation", "Pombium.include.node_modules.signals-tooling.out")

newModule("ConnectionManager", "ModuleScript", "Pombium.include.node_modules.signals-tooling.out.Implementation.ConnectionManager", "Pombium.include.node_modules.signals-tooling.out.Implementation", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local ConnectionManager
do
	ConnectionManager = setmetatable({}, {
		__tostring = function()
			return "ConnectionManager"
		end,
	})
	ConnectionManager.__index = ConnectionManager
	function ConnectionManager.new(...)
		local self = setmetatable({}, ConnectionManager)
		return self:constructor(...) or self
	end
	function ConnectionManager:constructor()
		self.connectionData = {}
	end
	function ConnectionManager:addConnectionData(signal, handlerFunction)
		local _connectionData = self.connectionData
		local _arg0 = {
			HandlerFunction = handlerFunction,
			Signal = signal,
		}
		-- ▼ Array.push ▼
		_connectionData[#_connectionData + 1] = _arg0
		-- ▲ Array.push ▲
	end
	function ConnectionManager:connectAll()
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #self.connectionData) then
					break
				end
				local connectionInfo = self.connectionData[i + 1]
				if connectionInfo.Connection == nil then
					connectionInfo.Connection = connectionInfo.Signal:Connect(connectionInfo.HandlerFunction)
				end
			end
		end
	end
	function ConnectionManager:connectToEvent(signal, handlerFunction)
		local connection = signal:Connect(handlerFunction)
		local _connectionData = self.connectionData
		local _arg0 = {
			Connection = connection,
			HandlerFunction = handlerFunction,
			Signal = signal,
		}
		-- ▼ Array.push ▼
		_connectionData[#_connectionData + 1] = _arg0
		-- ▲ Array.push ▲
	end
	function ConnectionManager:disconnectAll()
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #self.connectionData) then
					break
				end
				local connectionInfo = self.connectionData[i + 1]
				if connectionInfo.Connection ~= nil then
					connectionInfo.Connection:Disconnect()
					connectionInfo.Connection = nil
				end
			end
		end
	end
	function ConnectionManager:reset()
		self:disconnectAll()
		self.connectionData = {}
	end
end
return {
	ConnectionManager = ConnectionManager,
}
 end, newEnv("Pombium.include.node_modules.signals-tooling.out.Implementation.ConnectionManager"))() end)

newModule("Signal", "ModuleScript", "Pombium.include.node_modules.signals-tooling.out.Implementation.Signal", "Pombium.include.node_modules.signals-tooling.out.Implementation", function () return setfenv(function() -- Compiled with roblox-ts v1.2.7
local TS = _G[script]
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local SignalConnection
do
	SignalConnection = setmetatable({}, {
		__tostring = function()
			return "SignalConnection"
		end,
	})
	SignalConnection.__index = SignalConnection
	function SignalConnection.new(...)
		local self = setmetatable({}, SignalConnection)
		return self:constructor(...) or self
	end
	function SignalConnection:constructor(disconnectCallback)
		self.Connected = true
		self.disconnectCallback = disconnectCallback
	end
	function SignalConnection:Disconnect()
		if not self.Connected then
			return nil
		end
		self.disconnectCallback()
		self.Connected = false
	end
end
local Signal
do
	Signal = setmetatable({}, {
		__tostring = function()
			return "Signal"
		end,
	})
	Signal.__index = Signal
	function Signal.new(...)
		local self = setmetatable({}, Signal)
		return self:constructor(...) or self
	end
	function Signal:constructor()
		self.connections = {}
		self.connectionsHandlersMap = {}
		self.lastFiredTick = 0
		self.isDestroyed = false
	end
	function Signal:Connect(onFiredCallback)
		if self.isDestroyed then
			error("Cannot connect to a destroyed signal")
		end
		local connection
		connection = SignalConnection.new(function()
			if not (self.connectionsHandlersMap[connection] ~= nil) then
				return nil
			end
			-- ▼ Map.delete ▼
			self.connectionsHandlersMap[connection] = nil
			-- ▲ Map.delete ▲
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < #self.connections) then
						break
					end
					if self.connections[i + 1] == connection then
						local _connections = self.connections
						local _i = i
						table.remove(_connections, _i + 1)
					end
				end
			end
		end)
		-- ▼ Map.set ▼
		self.connectionsHandlersMap[connection] = onFiredCallback
		-- ▲ Map.set ▲
		local _connections = self.connections
		-- ▼ Array.push ▼
		_connections[#_connections + 1] = connection
		-- ▲ Array.push ▲
		return connection
	end
	function Signal:disconnectAll()
		if self.isDestroyed then
			error("Cannot disconnect connections to a destroyed signal")
		end
		-- Clear the handlers mapping first so that we don't get an O(n^2) runtime complexity (see disconnect callback)
		-- ▼ Map.clear ▼
		table.clear(self.connectionsHandlersMap)
		-- ▲ Map.clear ▲
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #self.connections) then
					break
				end
				self.connections[i + 1]:Disconnect()
			end
		end
		self.connections = {}
	end
	function Signal:destroy()
		if self.isDestroyed then
			return nil
		end
		self:disconnectAll()
		self.isDestroyed = true
	end
	function Signal:fire(...)
		local args = { ... }
		if self.isDestroyed then
			error("Cannot fire a destroyed signal")
		end
		self.lastFiredArgs = args
		self.lastFiredTick = tick()
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < #self.connections) then
					break
				end
				local _connectionsHandlersMap = self.connectionsHandlersMap
				local _arg0 = self.connections[i + 1]
				local handlerFunction = _connectionsHandlersMap[_arg0]
				if handlerFunction ~= nil then
					coroutine.wrap(handlerFunction)(...)
				end
			end
		end
	end
	function Signal:Wait()
		if self.isDestroyed then
			error("Cannot wait for a destroyed signal")
		end
		local lastFiredTickAtStart = self.lastFiredTick
		while self.lastFiredTick == lastFiredTickAtStart do
			RunService.Heartbeat:Wait()
		end
		-- eslint-disable-next-line
		return unpack(self.lastFiredArgs)
	end
end
return {
	Signal = Signal,
}
 end, newEnv("Pombium.include.node_modules.signals-tooling.out.Implementation.Signal"))() end)

newInstance("Interfaces", "Folder", "Pombium.include.node_modules.signals-tooling.out.Interfaces", "Pombium.include.node_modules.signals-tooling.out")

newInstance("testez", "Folder", "Pombium.include.node_modules.testez", "Pombium.include.node_modules")

newInstance("types", "Folder", "Pombium.include.node_modules.types", "Pombium.include.node_modules")

newInstance("include", "Folder", "Pombium.include.node_modules.types.include", "Pombium.include.node_modules.types")

newInstance("generated", "Folder", "Pombium.include.node_modules.types.include.generated", "Pombium.include.node_modules.types.include")

newModule("validate-tree", "ModuleScript", "Pombium.include.node_modules.validate-tree", "Pombium.include.node_modules", function () return setfenv(function() -- Compiled with roblox-ts v1.2.3
local TS = _G[script]
-- * Defines a Rojo-esque tree type which defines an abstract object tree.
-- * Evaluates a Rojo-esque tree and transforms it into an indexable type.
local function getService(serviceName)
	return game:GetService(serviceName)
end
--[[
	* Returns whether a given Instance matches a particular Rojo-esque InstanceTree.
	* @param object The object which needs validation
	* @param tree The tree to validate
	* @param violators
]]
local function validateTree(object, tree, violators)
	if tree["$className"] ~= nil and not object:IsA(tree["$className"]) then
		return false
	end
	local matches = true
	if object.ClassName == "DataModel" then
		for serviceName, classOrTree in pairs(tree) do
			if serviceName ~= "$className" then
				local result = { pcall(getService, serviceName) }
				if not result[1] then
					if violators then
						matches = false
						local _arg0 = 'game.GetService("' .. serviceName .. '")'
						-- ▼ Array.push ▼
						violators[#violators + 1] = _arg0
						-- ▲ Array.push ▲
					end
					return false
				end
				local _binding = result
				local value = _binding[2]
				if value and (type(classOrTree) == "string" or validateTree(value, classOrTree, violators)) then
					if value.Name ~= serviceName then
						value.Name = serviceName
					end
				else
					if violators then
						matches = false
						local _arg0 = 'game.GetService("' .. serviceName .. '")'
						-- ▼ Array.push ▼
						violators[#violators + 1] = _arg0
						-- ▲ Array.push ▲
					else
						return false
					end
				end
			end
		end
	else
		local whitelistedKeys = {
			["$className"] = true,
		}
		for _, child in ipairs(object:GetChildren()) do
			local childName = child.Name
			if childName ~= "$className" then
				local classOrTree = tree[childName]
				local _result
				if type(classOrTree) == "string" then
					_result = child:IsA(classOrTree)
				else
					_result = classOrTree and validateTree(child, classOrTree, violators)
				end
				if _result then
					-- ▼ Set.add ▼
					whitelistedKeys[childName] = true
					-- ▲ Set.add ▲
				end
			end
		end
		for key in pairs(tree) do
			if not (whitelistedKeys[key] ~= nil) then
				if violators then
					matches = false
					local _arg0 = object:GetFullName() .. "." .. key
					-- ▼ Array.push ▼
					violators[#violators + 1] = _arg0
					-- ▲ Array.push ▲
				else
					return false
				end
			end
		end
	end
	return matches
end
--[[
	* Promises a given tree of objects exists within an object.
	* @param tree Must be an object tree similar to ones considered valid by Rojo.
	* Every tree must have a `$className` member, and can have any number of keys which represent
	* the name of a child instance, which should have a corresponding value which is this same kind of tree.
	* There is also a shorthand syntax available, where setting a key equal to a className is equivalent
	* to an object with `$className` defined. Hence `Things: "Folder"` is equivalent to `Things: { $className: "Folder" }`
]]
local function promiseTree(object, tree)
	if validateTree(object, tree) then
		return TS.Promise.resolve(object)
	end
	local connections = {}
	local warner = TS.Promise.delay(5)
	local _arg0 = function()
		local violators = {}
		if not validateTree(object, tree, violators) then
			-- ▼ ReadonlyArray.join ▼
			local _arg0_1 = ", "
			if _arg0_1 == nil then
				_arg0_1 = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			warn("[promiseTree] Infinite wait possible. Waiting for: " .. table.concat(violators, _arg0_1))
		end
	end
	warner:andThen(_arg0)
	local promise = TS.Promise.new(function(resolve)
		local function updateTree(violators)
			if validateTree(object, tree, violators) then
				resolve(object)
			end
		end
		for _, d in ipairs(object:GetDescendants()) do
			local _arg0_1 = d:GetPropertyChangedSignal("Name"):Connect(updateTree)
			-- ▼ Array.push ▼
			connections[#connections + 1] = _arg0_1
			-- ▲ Array.push ▲
		end
		local _arg0_1 = object.DescendantAdded:Connect(function(descendant)
			local _arg0_2 = descendant:GetPropertyChangedSignal("Name"):Connect(updateTree)
			-- ▼ Array.push ▼
			connections[#connections + 1] = _arg0_2
			-- ▲ Array.push ▲
			updateTree()
		end)
		-- ▼ Array.push ▼
		connections[#connections + 1] = _arg0_1
		-- ▲ Array.push ▲
	end)
	promise:finally(function()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		warner:cancel()
	end)
	return promise
end
return {
	validateTree = validateTree,
	promiseTree = promiseTree,
}
 end, newEnv("Pombium.include.node_modules.validate-tree"))() end)

newInstance("node_modules", "Folder", "Pombium.include.node_modules.validate-tree.node_modules", "Pombium.include.node_modules.validate-tree")

newInstance("@rbxts", "Folder", "Pombium.include.node_modules.validate-tree.node_modules.@rbxts", "Pombium.include.node_modules.validate-tree.node_modules")

newInstance("compiler-types", "Folder", "Pombium.include.node_modules.validate-tree.node_modules.@rbxts.compiler-types", "Pombium.include.node_modules.validate-tree.node_modules.@rbxts")

newInstance("types", "Folder", "Pombium.include.node_modules.validate-tree.node_modules.@rbxts.compiler-types.types", "Pombium.include.node_modules.validate-tree.node_modules.@rbxts.compiler-types")

init()