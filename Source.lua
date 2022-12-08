  --[[]    [|] [|||||||||] [|||||||||] [|]        [|||||||||] [|||||||||] [|]      [||||||]
   [|]    [|]     [|]         [|]     [|]            [|]         [|]   [|] [|]   [|]    [|]
  [|]    [|]     [|]         [|]     [|]            [|]         [|]  [|]   [|]  [|]
 [|]    [|]     [|]         [|]     [|]            [|]         [|] [|||||||||]  [||||||]
[|]    [|]     [|]         [|]     [|]            [|]         [|] [|]     [|]        [|]
[|]  [|]      [|]         [|]     [|]            [|]         [|] [|]     [|] [|]    [|]
[||||]       [|]     [|||||||||] [||||||||] [|||||||||]     [|] [|]     [|]  [|||||]]
local function Load(Table)
	local Nil,Connect = {},game.Close.Connect
	local Destroy,Wait,Service,Valid,WaitForSequence,WaitForChildOfClass
	do
		local SignalWait,Services,DestroyObject,WaitForChild,DisconnectObject = game.Close.Wait,{},game.Destroy,game.WaitForChild,nil
		do
			local Connection = Connect(game.Close,function() end)
			DisconnectObject = Connection.Disconnect
			DisconnectObject(Connection)
		end
		Destroy,Wait,Service,WaitForSequence,WaitForChildOfClass = function(...)
			for _,Object in {...} do
				local Function = ({
					Instance = function()
						pcall(DestroyObject,Object)
					end,
					RBXScriptConnection = function()
						if Object.Connected then
							pcall(DisconnectObject,Object)
						end
					end,
					table = function()
						for Index,Value in Object do
							Object[Index] = nil
							Destroy(Index)
							Destroy(Value)
						end
					end
				})[typeof(Object)]
				if Function then
					Function()
				end
			end
		end,function(Value)
			if typeof(Value) == "RBXScriptSignal" then
				return SignalWait(Value)
			end
			return task.wait(Value)
		end,function(Name)
			Name = tostring(Name or 0)
			if Services[Name] then
				return Services[Name]
			end
			local Object = select(2,pcall(game.GetService,game,Name))
			if typeof(Object) ~= "Instance" then
				Object = select(2,pcall(game.GetService,game,("%sService"):format(Name)))
			end
			if typeof(Object) == "Instance" then
				Services[Name] = Object
				return Object
			end
			warn(debug.traceback("Invalid Service Name",2))
		end,function(Object,...)
			Object = Valid.Instance(Object)
			for _,Name in {...} do
				Name = Valid.String(Name)
				if Name and Object then
					Object = WaitForChild(Object,Name)
				end
			end
			return Object
		end,function(Object,ClassName)
			local Child = Object:FindFirstChildOfClass(ClassName)
			while not Child or Child.ClassName ~= ClassName do
				Child = Object.ChildAdded:Wait()
			end
			return Child
		end
	end
	Valid = {
		Table = function(Table,Substitute)
			Table = type(Table) == "table" and Table or {}
			for Index,Value in type(Substitute) == "table" and Substitute or {} do
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
			for Names,Value in {
				true_yes_on_positive_1_i = true,
				false_no_off_negative_0_o = false
			} do
				for _,Name in Names:split"_" do
					if Boolean == Name then
						return Value
					end
				end
			end
			return Substitute
		end,
		CFrame = function(CoordinateFrame,Substitute)
			Substitute = typeof(Substitute or 0) == "CFrame" and Substitute or CFrame.new()
			if typeof(CoordinateFrame or 0) == "Vector3" then
				CoordinateFrame = CFrame.new(CoordinateFrame)
			elseif typeof(CoordinateFrame or 0) ~= "CFrame" then
				return Substitute
			end
			local Components = {CoordinateFrame:GetComponents()}
			Substitute = {Substitute:GetComponents()}
			for Index,Component in Components do
				Components[Index] = Valid.Number(Component,Substitute[Component])
			end
			return CFrame.new(unpack(Components))
		end,
		Vector3 = function(Vector,Substitute)
			Substitute = typeof(Substitute or 0) == "Vector3" and Substitute or Vector3.new()
			if typeof(Vector or 0) == "CFrame" then
				Vector = Vector.Position
			elseif typeof(Vector or 0) ~= "Vector3" then
				return Substitute
			end
			local NewVector = Vector3.zero
			for _,Axis in {"X","Y","Z"} do
				NewVector += Vector3[("%sAxis"):format(Axis:lower())]*Valid.Number(Vector[Axis],Substitute[Axis])
			end
			return NewVector
		end
	}
	local function RandomString(Options)
		Options = Valid.Table(Options,{
			Format = "\0%s",
			Length = math.random(5,99),
			CharacterSet = {
				NumberRange.new(48,57),
				NumberRange.new(65,90),
				NumberRange.new(97,122)
			}
		})
		local AvailableCharacters = {}
		for _,Set in Options.CharacterSet do
			for Character = Set.Min,Set.Max do
				table.insert(AvailableCharacters,string.char(Character))
			end
		end
		local String = {}
		for _ = 1,Options.Length do
			table.insert(String,AvailableCharacters[math.random(#AvailableCharacters)])
		end
		return table.concat(String)
	end
	local function RandomBool(Chance)
		Chance = Valid.Number(Chance,.5)
		if Chance <= 0 then
			return false
		end
		return math.random(math.round(1/math.min(Chance,1))) == 1
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
			for Property,Value in Properties do
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
		for _,InstanceData in Valid.Table(Data) do
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
		local Functionality = ({
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
		})[typeof(Signal)]
		if Functionality then
			task.spawn(Functionality)
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
				local Tween = Service"Tween":Create(Object,TweenInfo.new(Data.Time,Data.EasingStyle,Data.EasingDirection,Data.RepeatCount,Data.Reverses,Data.DelayTime),Data.Properties)
				Tween:Play()
				if Data.Yields then
					Wait(Tween.Completed)
				end
				if 0 < Data.FinishDelay then
					Wait(Data.FinishDelay)
				end
			end
		end
	end
	local function GetCharacter(Player,MaxYield)
		Player = Valid.Instance(Player,"Player")
		if not Player then
			return
		end
		if Valid.Instance(Player.Character,"Model") then
			return Player.Character
		end
		local Character = WaitForSignal(Player.CharacterAdded,MaxYield)
		if Character then
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
		elseif not Valid.Instance(Character,"Model") then
			return
		end
		local Humanoid = WaitForSignal(function()
			local Humanoid = Character:FindFirstChildOfClass"Humanoid" or Wait(Character.ChildAdded)
			if Valid.Instance(Humanoid,"Humanoid") then
				return Humanoid
			end
		end,MaxYield)
		if Humanoid then
			return Humanoid
		end
	end
	local function ConvertTime(Time)
		local Sign = Time < 0
		Time = math.abs(Time)
		for _,Values in {
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
	local function DeltaLerp(Start,Goal,Alpha,Delta)
		Alpha = math.clamp((1-Valid.Number(Alpha,0))^Delta,0,1)
		return Valid.Number(Start) and Valid.Number(Goal) and Goal+(Start-Goal)*Alpha or Goal:Lerp(Start,Alpha)
	end
	Table.Owner = Service"Players".LocalPlayer
	if not Service"Run":IsServer() then
		while not Table.Owner do
			Wait(Service"Players".PlayerAdded)
			Table.Owner = Service"Players".LocalPlayer
		end
	end
	for Name,Value in {
		Nil = Nil,
		Wait = Wait,
		Valid = Valid,
		Create = Create,
		Animate = Animate,
		Connect = Connect,
		Destroy = Destroy,
		Service = Service,
		DeltaLerp = DeltaLerp,
		DecodeJSON = DecodeJSON,
		NilConvert = NilConvert,
		RandomBool = RandomBool,
		ConvertTime = ConvertTime,
		GetHumanoid = GetHumanoid,
		NewInstance = NewInstance,
		GetCharacter = GetCharacter,
		RandomString = RandomString,
		WaitForSignal = WaitForSignal,
		GetContentText = GetContentText,
		WaitForSequence = WaitForSequence,
		WaitForChildOfClass = WaitForChildOfClass
	} do
		Table[Name] = Value
	end
	return Table
end
if select("#",...) < 1 then
	return Load
end
return Load(...)
