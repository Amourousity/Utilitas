  --[[]    [|] [|||||||||] [|||||||||] [|]        [|||||||||] [|||||||||] [|]      [||||||]
   [|]    [|]     [|]         [|]     [|]            [|]         [|]   [|] [|]   [|]    [|]
  [|]    [|]     [|]         [|]     [|]            [|]         [|]  [|]   [|]  [|]
 [|]    [|]     [|]         [|]     [|]            [|]         [|] [|||||||||]  [||||||]
[|]    [|]     [|]         [|]     [|]            [|]         [|] [|]     [|]        [|]
[|]  [|]      [|]         [|]     [|]            [|]         [|] [|]     [|] [|]    [|]
[||||]       [|]     [|||||||||] [||||||||] [|||||||||]     [|] [|]     [|]  [|||||]]

local function load(loadData)
	local nil_, connect = {}, game.Close.Connect
	local
		destroy: (...any) -> (),
		wait:
			((value: RBXScriptSignal) -> ...any)
			& ((value: number?) -> number),
		service: (string) -> Instance,
		valid: {
			table: (table: { [any]: any? }?, substitute: { [any]: any? }?) -> { [any]: any? },
			number: (number: number?, subsitute: number?) -> number?,
			string: (string: string?, subsitute: string?) -> string?,
			instance: (object: Instance?, className: string?) -> Instance?,
			boolean: (boolean: string | boolean?, boolean?) -> boolean?,
			cframe: (cframe: CFrame?, substitute: CFrame?) -> CFrame,
			vector3: (vector: Vector3?, subsitute: Vector3?) -> Vector3,
		},
		waitForSequence: (object: Instance, ...string) -> Instance,
		waitForChildOfClass: (object: Instance, className: string) -> Instance
	do
		local signalWait, services, destroyObject, waitForChild, disconnectObject =
			game.Close.Wait, {}, game.Destroy, game.WaitForChild, nil
		do
			local connection = connect(game.Close, function() end)
			disconnectObject = connection.Disconnect
			disconnectObject(connection)
		end
		destroy, wait, service, waitForSequence, waitForChildOfClass =
			function(...)
				for _, object in { ... } do
					local func = ({
						Instance = function()
							pcall(destroyObject, object)
						end,
						RBXScriptConnection = function()
							if object.Connected then
								pcall(disconnectObject, object)
							end
						end,
						table = function()
							for Index, Value in object do
								object[Index] = nil
								destroy(Index)
								destroy(Value)
							end
						end,
					})[typeof(object)]
					if func then
						func()
					end
				end
			end, function(value)
				if typeof(value) == "RBXScriptSignal" then
					return signalWait(value)
				end
				return task.wait(value)
			end, function(Name)
				Name = tostring(Name or 0)
				if services[Name] then
					return services[Name]
				end
				local object = select(2, pcall(game.GetService, game, Name))
				if typeof(object) ~= "Instance" then
					object = select(2, pcall(game.GetService, game, ("%sService"):format(Name)))
				end
				if typeof(object) == "Instance" then
					services[Name] = object
					return object
				end
				warn(debug.traceback("Invalid service name", 2))
			end, function(object, ...)
				object = valid.instance(object)
				for _, Name in { ... } do
					Name = valid.string(Name)
					if Name and object then
						object = waitForChild(object, Name)
					end
				end
				return object
			end, function(object, className)
				local Child = object:FindFirstChildOfClass(className)
				while not Child or Child.ClassName ~= className do
					Child = object.ChildAdded:Wait()
				end
				return Child
			end
	end
	valid = {
		table = function(table, substitute)
			table = type(table) == "table" and table or {}
			for key, value in type(substitute) == "table" and substitute or {} do
				table[key] = typeof(table[key]) == typeof(value) and table[key] or value
			end
			return table
		end,
		number = function(number, substitute)
			number, substitute = tonumber(number), tonumber(substitute)
			return number == number and number or substitute == substitute and substitute or nil
		end,
		string = function(string, substitute)
			return type(string) == "string" and string or type(substitute) == "string" and substitute or nil
		end,
		instance = function(object, className)
			return if typeof(object) == "Instance"
					and select(2, pcall(game.IsA, object, valid.string(className, "Instance"))) == true
				then object
				else nil
		end,
		boolean = function(boolean, substitute)
			boolean = tostring(boolean):lower()
			for names: string, value: boolean in
				{
					true_yes_on_positive_1_i = true,
					false_no_off_negative_0_o = false,
				}
			do
				for _, name: string in names:split("_") do
					if boolean == name then
						return value
					end
				end
			end
			return substitute
		end,
		cframe = function(cframe, substitute)
			substitute = if typeof(substitute or 0) == "CFrame" then substitute else CFrame.new()
			if typeof(cframe or 0) == "Vector3" then
				cframe = CFrame.new(cframe)
			elseif typeof(cframe or 0) ~= "CFrame" then
				return substitute
			end
			local components = { cframe:GetComponents() }
			substitute = { substitute:GetComponents() }
			for index: number, component: number in components do
				components[index] = valid.number(component, substitute[component])
			end
			return CFrame.new(unpack(components))
		end,
		vector3 = function(vector, substitute)
			substitute = typeof(substitute or 0) == "Vector3" and substitute or Vector3.new()
			if typeof(vector or 0) == "CFrame" then
				vector = vector.Position
			elseif typeof(vector or 0) ~= "Vector3" then
				return substitute
			end
			local newVector = Vector3.zero
			for _, axis: string in { "X", "Y", "Z" } do
				newVector += Vector3[`{axis:lower()}Axis`] * valid.number(vector[axis], substitute[axis])
			end
			return newVector
		end,
	}
	local function randomString(options: {
		format: string,
		length: number,
		characterSet: { NumberRange },
	}): string
		options = valid.table(options, {
			format = "\0%s",
			length = math.random(5, 99),
			characterSet = {
				NumberRange.new(48, 57),
				NumberRange.new(65, 90),
				NumberRange.new(97, 122),
			},
		})
		local availableCharacters = {}
		for _, set: NumberRange in options.characterSet do
			for character = set.Min, set.Max do
				table.insert(availableCharacters, string.char(character))
			end
		end
		local outputString = {}
		for _ = 1, options.length do
			table.insert(outputString, availableCharacters[math.random(#availableCharacters)])
		end
		return table.concat(outputString)
	end
	local function randomBool(chance): boolean
		chance = valid.number(chance, 0.5)
		if chance <= 0 then
			return false
		end
		return math.random(math.round(1 / math.min(chance, 1))) == 1
	end
	local function nilConvert(value): any?
		return if value == nil then nil_ elseif value == nil_ then nil else value
	end
	local function newInstance(className: string, parent: Instance?, properties: { [string]: any }?): Instance
		local _, newObject = pcall(Instance.new, className)
		if typeof(newObject) == "Instance" then
			properties = valid.table(properties, {
				Name = randomString(),
				Archivable = randomBool(),
			})
			for property: string, value in properties do
				local success, error = pcall(function()
					newObject[property] = nilConvert(value)
				end)
				if not success then
					warn(error)
				end
			end
			newObject.Parent = valid.instance(parent)
			return newObject
		else
			warn(newObject)
		end
	end
	local function create(data: {
		{
			Name: string,
			Parent: Instance | string?,
			ClassName: string,
			Properties: { [string]: any? }?,
		}
	}): { Instance }
		local instances = {}
		for _, instanceData in valid.table(data) do
			if not valid.string(instanceData.ClassName) then
				error("Missing ClassName in InstanceData for function Create")
			elseif not valid.string(instanceData.Name) then
				warn("Missing Name in InstanceData for function Create, substituting with ClassName")
				instanceData.Name = instanceData.ClassName
			end
			instances[instanceData.Name] = newInstance(
				instanceData.ClassName,
				valid.string(instanceData.Parent) and instances[instanceData.Parent] or instanceData.Parent,
				instanceData.Properties
			)
		end
		return instances
	end
	local function jsonDecode(json: string, substitute: { [any]: any? }): { [any]: any? }
		local success, output = pcall(service("Http").JSONDecode, service("Http"), valid.string(json, "[]"))
		return valid.table(success and output or {}, substitute)
	end
	local function waitForSignal(signal: RBXScriptSignal | (...any) -> ...any, maxYield: number?): ...any
		local returnValue = newInstance("BindableEvent")
		destroy(returnValue)
		if valid.number(maxYield) then
			task.delay(maxYield, returnValue.Fire, returnValue)
		end
		local signalStart, ready = os.clock()
		local func = ({
			RBXScriptSignal = function()
				returnValue:Fire(wait(signal))
			end,
			["function"] = function()
				local Continue
				repeat
					(function(Success, ...)
						if Success and ... then
							Continue = true
							if not ready then
								wait()
							end
							returnValue:Fire(...)
						end
					end)(pcall(signal))
				until Continue or valid.number(maxYield) and maxYield < os.clock() - signalStart
			end,
		})[typeof(signal)]
		if func then
			task.spawn(func)
		end
		ready = true
		return wait(returnValue.Event)
	end
	local function animate(...)
		for index = 1, select("#", ...), 2 do
			local object: Instance, data: {
				secondsTime: number,
				delayTime: number,
				yields: boolean,
				finishDelay: number,
				properties: { [string]: any },
				repeatCount: number,
				reverses: boolean,
				easingStyle: Enum.EasingStyle,
				easingDirection: Enum.EasingDirection,
			} =
				select(index, ...)
			if valid.instance(object) then
				data = valid.table(data, {
					secondsTime = 0.5,
					delayTime = 0,
					yields = false,
					finishDelay = 0,
					properties = {},
					repeatCount = 0,
					reverses = false,
					easingStyle = Enum.EasingStyle.Quad,
					easingDirection = Enum.EasingDirection.Out,
				})
				local tween = service("Tween"):Create(
					object,
					TweenInfo.new(
						data.secondsTime,
						data.easingStyle,
						data.easingDirection,
						data.repeatCount,
						data.reverses,
						data.delayTime
					),
					data.properties
				)
				tween:Play()
				if data.yields then
					wait(tween.Completed)
				end
				if 0 < data.finishDelay then
					wait(data.finishDelay)
				end
			end
		end
	end
	local function getCharacter(player: Player, maxYield: number?): Model?
		player = valid.instance(player, "Player")
		if not player then
			return
		end
		if valid.instance(player.Character, "Model") then
			return player.Character
		end
		local character = waitForSignal(player.CharacterAdded, maxYield)
		if character then
			return character
		end
	end
	local function getHumanoid(character: Player | Model, maxYield: number?): Humanoid?
		maxYield = valid.number(maxYield, 10)
		if valid.instance(character, "Player") then
			local duration = os.clock()
			local newCharacter = getCharacter(character, maxYield)
			if newCharacter then
				character = newCharacter
				maxYield -= os.clock() - duration
			else
				return
			end
		elseif not valid.instance(character, "Model") then
			return
		end
		local humanoid = waitForSignal(function()
			local humanoid = character:FindFirstChildOfClass("Humanoid") or wait(character.ChildAdded)
			if valid.instance(humanoid, "Humanoid") then
				return humanoid
			end
		end, maxYield)
		if humanoid then
			return humanoid
		end
	end
	local function convertTime(time: number): string
		local sign = time < 0
		time = math.abs(time)
		for _, values in
			{
				{ 31536e3, "year" },
				{ 2628003, "month" },
				{ 604800, "week" },
				{ 86400, "day" },
				{ 3600, "hour" },
				{ 60, "minute" },
				{ 1, "second" },
				{ 1e-3, "millisecond" },
				{ 1e-6, "microsecond" },
				{ 1e-9, "nanosecond" },
			}
		do
			if values[1] <= time then
				time = math.round(time / values[1] * 100) / 100
				return `{if sign then "-" else ""}{time} {values[2]}{if time ~= 1 or sign then "s" else ""}`
			end
		end
		return "no time"
	end
	local function getContentText(string: string): string
		local checkTextBox = newInstance("TextBox", nil, {
			Text = string,
			RichText = true,
		})
		destroy(checkTextBox)
		return checkTextBox.ContentText
	end
	local function deltaLerp(start, goal, alpha: number, delta: number)
		alpha = math.clamp((1 - valid.number(alpha, 0)) ^ delta, 0, 1)
		return valid.number(start) and valid.number(goal) and goal + (start - goal) * alpha or goal:Lerp(start, alpha)
	end
	loadData.owner = service("Players").LocalPlayer
	if not service("Run"):IsServer() then
		while not loadData.owner do
			wait(service("Players").PlayerAdded)
			loadData.owner = service("Players").LocalPlayer
		end
	end
	for name: string, value in
		{
			nil_ = nil_,
			wait = wait,
			valid = valid,
			create = create,
			animate = animate,
			connect = connect,
			destroy = destroy,
			service = service,
			deltaLerp = deltaLerp,
			jsonDecode = jsonDecode,
			nilConvert = nilConvert,
			randomBool = randomBool,
			convertTime = convertTime,
			getHumanoid = getHumanoid,
			newInstance = newInstance,
			getCharacter = getCharacter,
			randomString = randomString,
			waitForSignal = waitForSignal,
			getContentText = getContentText,
			waitForSequence = waitForSequence,
			waitForChildOfClass = waitForChildOfClass,
		}
	do
		loadData[name] = value
	end
	return loadData
end
if select("#", ...) < 1 then
	return load
end
return load(...)
