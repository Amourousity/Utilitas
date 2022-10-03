  --[[]    [|] [|||||||||] [|||||||||] [|]        [|||||||||] [|||||||||] [|]      [||||||]
   [|]    [|]     [|]         [|]     [|]            [|]         [|]   [|] [|]   [|]    [|]
  [|]    [|]     [|]         [|]     [|]            [|]         [|]  [|]   [|]  [|]
 [|]    [|]     [|]         [|]     [|]            [|]         [|] [|||||||||]  [||||||]
[|]    [|]     [|]         [|]     [|]            [|]         [|] [|]     [|]        [|]
[|]  [|]      [|]         [|]     [|]            [|]         [|] [|]     [|] [|]    [|]
[||||]       [|]     [|||||||||] [||||||||] [|||||||||]     [|] [|]     [|]  [|||||]]
local function Load(...)
	local Nil,Connect = {},game.Close.Connect
	local Destroy,Wait,Service,Valid,WaitForSequence
	do
		local SignalWait,Services,DestroyObject,WaitForChild,DisconnectObject = game.Close.Wait,{},game.Destroy,game.WaitForChild,nil
		for _,Name in next,{
			"Ad",
			"VR",
			"Gui",
			"IXP",
			"Log",
			"Run",
			"Http",
			"Test",
			"Text",
			"User",
			"Asset",
			"Badge",
			"Chat.",
			"Group",
			"Mouse",
			"Sound",
			"Timer",
			"Tween",
			"Drafts",
			"Friend",
			"Haptic",
			"Insert",
			"Joints",
			"LuaWeb",
			"Points",
			"Policy",
			"Script",
			"Social",
			"Stats.",
			"Studio",
			"Teams.",
			"Tracer",
			"Visit.",
			"Browser",
			"Cookies",
			"Debris.",
			"Dragger",
			"Gamepad",
			"LodData",
			"Package",
			"Physics",
			"Publish",
			"Session",
			"Spawner",
			"TextBox",
			"CoreGui.",
			"DeviceId",
			"GamePass",
			"Keyboard",
			"Language",
			"Material",
			"Players.",
			"Teleport",
			"TextChat",
			"Analytics",
			"AppUpdate",
			"DataStore",
			"Flyweight",
			"Geometry.",
			"Lighting.",
			"Messaging",
			"PluginGui",
			"UserInput",
			"VoiceChat",
			"AppStorage",
			"Collection",
			"Controller",
			"HttpRbxApi",
			"MemStorage",
			"MessageBus",
			"Selection.",
			"TouchInput",
			"Workspace.",
			"EventIngest",
			"Marketplace",
			"MemoryStore",
			"Pathfinding",
			"Permissions",
			"PluginDebug",
			"RtMessaging",
			"StarterGui.",
			"StudioData.",
			"AvatarEditor",
			"FaceAnimator",
			"GuidRegistry",
			"Localization",
			"Notification",
			"RbxAnalytics",
			"ScriptEditor",
			"ServerScript",
			"StarterPack.",
			"VideoCapture",
			"VirtualUser.",
			"CSGDictionary",
			"ChangeHistory",
			"ContextAction",
			"CorePackages.",
			"RuntimeScript",
			"UGCValidation",
			"CoreScriptSync",
			"DataModelPatch",
			"NetworkClient.",
			"PlayerEmulator",
			"ScriptContext.",
			"ServerStorage.",
			"StarterPlayer.",
			"VersionControl",
			"ProximityPrompt",
			"ContentProvider.",
			"DebuggerManager.",
			"ReplicatedFirst.",
			"UnvalidatedAsset",
			"HeightmapImporter",
			"ReplicatedStorage.",
			"ScriptRegistration",
			"VoiceChatInternal.",
			"MeshContentProvider.",
			"VirtualInputManager.",
			"AnimationClipProvider.",
			"ProcessInstancePhysics",
			"HSRDataContentProvider.",
			"FacialAnimationStreaming",
			"IncrementalPatchBuilder.",
			"RobloxReplicatedStorage.",
			"AnimationFromVideoCreator",
			"KeyframeSequenceProvider.",
			"NonReplicatedCSGDictionary",
			"SolidModelContentProvider."
		} do
			Services[Name:gsub("%.$","")] = select(2,pcall(game.GetService,game,Name:sub(-1) == "." and Name:sub(1,-2) or ("%sService"):format(Name)))
		end
		do
			local Connection = Connect(game.Close,function() end)
			DisconnectObject = Connection.Disconnect
			DisconnectObject(Connection)
		end
		Destroy,Wait,Service,WaitForSequence = function(...)
			for _,Object in next,{
				...
			} do
				for Type,Function in next,{
					Instance = function()
						pcall(DestroyObject,Object)
					end,
					RBXScriptConnection = function()
						if Object.Connected then
							pcall(DisconnectObject,Object)
						end
					end,
					table = function()
						for Index,Value in next,Object do
							Object[Index] = nil
							Destroy(Index)
							Destroy(Value)
						end
					end
				} do
					if typeof(Object) == Type then
						Function()
					end
				end
			end
		end,function(Value)
			if typeof(Value) == "RBXScriptSignal" then
				return SignalWait(Value)
			end
			return task.wait(Value)
		end,function(Name)
			return type(Name) == "string" and Services[Name] or error(('Failed to get Service "%s"'):format(tostring(Name)),0)
		end,function(Object,...)
			Object = Valid.Instance(Object)
			for _,Name in next,{
				...
			 } do
				Name = Valid.String(Name)
				if Name and Object then
					Object = WaitForChild(Object,Name)
				end
			end
			return Object
		end
	end
	Valid = {
		Table = function(Table,Substitute)
			Table = type(Table) == "table" and Table or {}
			for Index,Value in next,type(Substitute) == "table" and Substitute or {} do
				Table[Index] = typeof(Table[Index]) == typeof(Value) and Table[Index] or Value
			end
			return Table
		end,
		Number = function(Number,Substitute)
			Number,Substitute = tonumber(Number),tonumber(Substitute)
			return Number == Number and Number or Substitute == Substitute and Substitute or nil
		end,
		String = function(String,Substitute)
			return type(String) == "string" and String or type(Substitute) == "string" and Substitute or nil
		end,
		Instance = function(Object,ClassName)
			return typeof(Object) == "Instance" and select(2,pcall(game.IsA,Object,Valid.String(ClassName,"Instance"))) == true and Object or nil
		end,
		Boolean = function(Boolean,Substitute)
			Boolean = tostring(Boolean):lower()
			for Names,Value in next,{
				true_yes_on_positive_1_i = true,
				false_no_off_negative_0_o = false
			} do
				for _,Name in next,Names:split"_" do
					if Boolean == Name then
						return Value
					end
				end
			end
			return Substitute
		end
	}
	local function RandomString(Settings)
		Settings = Valid.Table(Settings,{
			Format = "\0%s",
			Length = math.random(5,99),
			CharacterSet = {
				NumberRange.new(48,57),
				NumberRange.new(65,90),
				NumberRange.new(97,122)
			}
		})
		local AvailableCharacters = {}
		for _,Set in next,Settings.CharacterSet do
			for Character = Set.Min,Set.Max do
				table.insert(AvailableCharacters,string.char(Character))
			end
		end
		return Settings.Format:format(("A"):rep(Settings.Length):gsub(".",function()
			return AvailableCharacters[math.random(#AvailableCharacters)]
		end))
	end
	local function RandomBool(Chance)
		return math.random(math.round(1/math.min(Valid.Number(Chance,.5),1))) == 1
	end
	local function NilConvert(Value)
		if Value == nil then
			return Nil
		elseif Value == Nil then
			return nil
		end
		return Value
	end
	local function NewInstance(ClassName,Parent,Properties)
		local _,NewObject = pcall(Instance.new,ClassName)
		if typeof(NewObject) == "Instance" then
			Properties = Valid.Table(Properties,{
				Name = RandomString(),
				Archivable = RandomBool()
			})
			for Property,Value in next,Properties do
				local Success,Error = pcall(function()
					NewObject[Property] = NilConvert(Value)
				end)
				if not Success then
					warn(Error)
				end
			end
			NewObject.Parent = Valid.Instance(Parent)
			return NewObject
		else
			warn(NewObject)
		end
	end
	local function Create(Data)
		local Instances = {}
		for _,InstanceData in next,Valid.Table(Data) do
			if not Valid.String(InstanceData.ClassName) then
				error"Missing ClassName in InstanceData for function Create"
			elseif not Valid.String(InstanceData.Name) then
				warn"Missing Name in InstanceData for function Create, substituting with ClassName"
				InstanceData.Name = InstanceData.ClassName
			end
			Instances[InstanceData.Name] = NewInstance(InstanceData.ClassName,Valid.String(InstanceData.Parent) and Instances[InstanceData.Parent] or InstanceData.Parent,InstanceData.Properties)
		end
		return Instances
	end
	local function DecodeJSON(JSON,Substitute)
		local Success,Output = pcall(Service"Http".JSONDecode,Service"Http",Valid.String(JSON,"[]"))
		return Valid.Table(Success and Output or {},Substitute)
	end
	local function WaitForSignal(Signal,MaxYield)
		local Return = NewInstance"BindableEvent"
		Destroy(Return)
		if Valid.Number(MaxYield) then
			task.delay(MaxYield,Return.Fire,Return)
		end
		local SignalStart,Ready = os.clock()
		for Type,Functionality in next,{
			RBXScriptSignal = function()
				Return:Fire(Wait(Signal))
			end,
			["function"] = function()
				local Continue
				repeat
					(function(Success,...)
						if Success and ... then
							Continue = true
							if not Ready then
								Wait()
							end
							Return:Fire(...)
						end
					end)(pcall(Signal))
				until Continue or Valid.Number(MaxYield) and MaxYield < os.clock()-SignalStart
			end
		} do
			if typeof(Signal) == Type then
				task.spawn(Functionality)
				break
			end
		end
		Ready = true
		return Wait(Return.Event)
	end
	local function Animate(...)
		for Index = 1,select("#",...),2 do
			local Object,Data = select(Index,...)
			if Valid.Instance(Object) then
				Data = Valid.Table(Data,{
					Time = .5,
					DelayTime = 0,
					Yields = false,
					FinishDelay = 0,
					Properties = {},
					RepeatCount = 0,
					Reverses = false,
					EasingStyle = Enum.EasingStyle.Quad,
					EasingDirection = Enum.EasingDirection.Out
				})
				Service"Tween":Create(Object,TweenInfo.new(Data.Time,Data.EasingStyle,Data.EasingDirection,Data.RepeatCount,Data.Reverses,Data.DelayTime),Data.Properties):Play()
				if Data.Yields then
					Wait((Data.Time+Data.DelayTime)*(1+Data.RepeatCount))
				end
				if 0 < Data.FinishDelay then
					Wait(Data.FinishDelay)
				end
			end
		end
	end
	local function Assert(...)
		for Index = 1,select("#",...),2 do
			local Assertion,FailureMessage = select(Index,...)
			if not Assertion then
				warn(Valid.String(FailureMessage,"The command failed to run. No further information provided"))
				return false
			end
		end
		return true
	end
	local function GetCharacter(Player,MaxYield)
		Player = Valid.Instance(Player,"Player")
		if not Assert(Player,"Specified player does not exist or left") then
			return
		end
		if Valid.Instance(Player.Character,"Model") then
			return Player.Character
		end
		local Character = WaitForSignal(Player.CharacterAdded,MaxYield)
		if Assert(Character,"The player's character took too long to load") then
			return Character
		end
	end
	local function GetHumanoid(Character,MaxYield)
		MaxYield = Valid.Number(MaxYield,10)
		if Valid.Instance(Character,"Player") then
			local Duration = os.clock()
			local NewCharacter = GetCharacter(Character,MaxYield)
			if NewCharacter then
				Character = NewCharacter
				MaxYield -= os.clock()-Duration
			else
				return
			end
		elseif not Assert(Valid.Instance(Character,"Model"),"The player's character isn't valid") then
			return
		end
		local Humanoid = WaitForSignal(function()
			local Humanoid = Character:FindFirstChildOfClass"Humanoid" or Wait(Character.ChildAdded)
			if Valid.Instance(Humanoid,"Humanoid") then
				return Humanoid
			end
		end,MaxYield)
		if Assert(Humanoid,"The player's humanoid took too long to load") then
			return Humanoid
		end
	end
	local function ConvertTime(Time)
		local Sign = Time < 0
		Time = math.abs(Time)
		for _,Values in next,{
			{31536e3,"year"},
			{2628003,"month"},
			{604800,"week"},
			{86400,"day"},
			{3600,"hour"},
			{60,"minute"},
			{1,"second"},
			{.001,"millisecond"},
			{1e-6,"microsecond"},
			{1e-9,"nanosecond"}
		} do
			if Values[1] <= Time then
				Time = math.round(Time/Values[1]*100)/100
				return ("%s%s %s%s"):format(Sign and "-" or "",tostring(Time),Values[2],(Time ~= 1 or Sign) and "s" or "")
			end
		end
		return "no time"
	end
	local function GetContentText(String)
		local CheckTextBox = NewInstance("TextBox",nil,{
			Text = String,
			RichText = true
		})
		Destroy(CheckTextBox)
		return CheckTextBox.ContentText
	end
	local Owner = Service"Players".LocalPlayer
	if not Service"Run":IsServer() then
		while not Owner do
			Wait(Service"Players".PlayerAdded)
			Owner = Service"Players".LocalPlayer
		end
	end
	local Functions = {
		{"Nil",Nil},
		{"Connect",Connect},
		{"Destroy",Destroy},
		{"Wait",Wait},
		{"Service",Service},
		{"Valid",Valid},
		{"WaitForSequence",WaitForSequence},
		{"RandomString",RandomString},
		{"RandomBool",RandomBool},
		{"NilConvert",NilConvert},
		{"NewInstance",NewInstance},
		{"Create",Create},
		{"DecodeJSON",DecodeJSON},
		{"WaitForSignal",WaitForSignal},
		{"Animate",Animate},
		{"Assert",Assert},
		{"GetCharacter",GetCharacter},
		{"GetHumanoid",GetHumanoid},
		{"ConvertTime",ConvertTime},
		{"GetContentText",GetContentText},
		not Service"Run":IsServer() and {"Owner",Owner} or nil
	}
	for SelectionType,Function in next,{
		All = function() end,
		Disclude = function(...)
			for Index = 1,select("#",...) do
				for Key,Values in next,Functions do
					if Values[1] == Valid.String(select(Index,...),"") then
						table.remove(Functions,Key)
						break
					end
				end
			end
		end,
		Include = function(...)
			local NewFunctions = {}
			for Index = 1,select("#",...) do
				for _,Values in next,Functions do
					if Values[1] == Valid.String(select(Index,...),"")then
						table.insert(NewFunctions,Values)
						break
					end
				end
			end
			Functions = NewFunctions
		end
	} do
		if Valid.String((...),"All") == SelectionType then
			Function(select(2,...))
			break
		end
	end
	for Index,Values in next,Functions do
		Functions[Index] = Values[2]
	end
	return unpack(Functions)
end
if select("#",...) < 1 then
	return Load
end
return Load(...)
