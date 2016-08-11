local IdleEmotes = LorePlay

local idleTime = 15000 -- time period in miliseconds to check whether player is idle
local isPlayerStealthed
local currentPlayerX, currentPlayerY
local emoteFromEvent
local defaultIdleTable
local eventIdleTable
local didIdleEmote = false
local isActiveEmoting = false


function IdleEmotes.CreateEventIdleEmotesTable()
	eventIdleTable = {
		["isEnabled"] = false,
		[EVENT_TRADE_INVITE_ACCEPTED] = {
			[1] = 76,
			[2] = 35,
			[3] = 19,
			[4] = 36,
			[5] = 50,
			[6] = 41,
			[7] = 153,
			[8] = 15,
			[9] = 154
		}
	}
end


local function AddDrunkToCities()
	local numOfEmotes = #defaultIdleTable["City"]
	local drunkTable = {
		[1] = 8,
		[2] = 8,
		[3] = 139,
		[4] = 139,
		[5] = 163,
		[6] = 163,
		[7] = 79,
		[8] = 79,
		[9] = 115,
		[10] = 90
	}
	local numOfDrunks = #drunkTable
	for i = 1, numOfDrunks, 1 do
		defaultIdleTable["City"][numOfEmotes + i] = drunkTable[i]
	end
end


local function AddWorshipToDungeons()
	local numOfEmotes = #defaultIdleTable["Dungeon"]
	local worshipTable = {
		[1] = 104,
		[2] = 52,
		[3] = 172
	}
	local numOfWorships = #worshipTable
	for i = 1, numOfWorships, 1 do
		defaultIdleTable["Dungeon"][numOfEmotes + i] = worshipTable[i]
	end
end


local function AddWorshipToCities()
	local numOfEmotes = #defaultIdleTable["City"]
	local worshipTable = {
		[1] = 104,
		[2] = 52,
		[3] = 172
	}
	local numOfWorships = #worshipTable
	for i = 1, numOfWorships, 1 do
		defaultIdleTable["City"][numOfEmotes + i] = worshipTable[i]
	end
end


local function AddWorshipToZone()
	local numOfEmotes = #defaultIdleTable["Zone"]
	local worshipTable = {
		[1] = 104,
		[2] = 52,
		[3] = 172
	}
	local numOfWorships = #worshipTable
	for i = 1, numOfWorships, 1 do
		defaultIdleTable["Zone"][numOfEmotes + i] = worshipTable[i]
	end
end


local function AddExercisesToZone()
	local numOfEmotes = #defaultIdleTable["Zone"]
	local exerciseTable = {
		[1] = 84,
		[2] = 85,
		[3] = 113
	}
	local numOfExercises = #exerciseTable
	for i = 1, numOfExercises, 1 do
		defaultIdleTable["Zone"][numOfEmotes + i] = exerciseTable[i]
	end
end


local function AddDancesToCities()
	local numOfEmotes = #defaultIdleTable["City"]
	local danceTable = {
		[1] = 72,
		[2] = 190,
		[3] = 182,
		[4] = 183,
		[5] = 184,
		[6] = 181,
		[7] = 207,
		[8] = 186,
		[9] = 187,
		[10] = 188,
		[11] = 189
	}
	local numOfDances = #danceTable
	for i = 1, numOfDances, 1 do
		defaultIdleTable["City"][numOfEmotes + i] = danceTable[i]
	end
end


local function AddInstrumentsToCities()
	local numOfEmotes = #defaultIdleTable["City"]
	local instrumentsTable = {
		[1] = 5,
		[2] = 6,
		[3] = 7
	}
	local numOfInstruments = #instrumentsTable
	for i = 1, numOfInstruments, 1 do
		defaultIdleTable["City"][numOfEmotes + i] = instrumentsTable[i]
	end
end


function IdleEmotes.CreateDefaultIdleEmotesTable()
	defaultIdleTable = {
		["Zone"] = {
			[1] = 99,
			[2] = 119,
			[3] = 120,
			[4] = 121,
			[5] = 123,
			[6] = 102,
			[7] = 201,
			[8] = 15,
			[9] = 10,
			[10] = 38,
			[11] = 191
		},
		["City"] = {
			[1] = 202,
			[2] = 107,
			[3] = 195,
			[4] = 8,
			[5] = 174,
			[6] = 100,
			[7] = 38,
			[8] = 169,
			[9] = 9,
			[10] = 191,
			[11] = 199
		},
		["Dungeon"] = {
			[1] = 195,
			[2] = 1,
			[3] = 154,
			[4] = 1,
			[5] = 1,
			[6] = 122,
			[7] = 101
		}
	}

	if LorePlay.savedSettingsTable.canPlayInstrumentsInCities then
		AddInstrumentsToCities()
	end
	if LorePlay.savedSettingsTable.canDanceInCities then
		AddDancesToCities()
	end
	if LorePlay.savedSettingsTable.canExerciseInZone then
		AddExercisesToZone()
	end
	if LorePlay.savedSettingsTable.canWorship then
		AddWorshipToZone()
		AddWorshipToCities()
		AddWorshipToDungeons()
	end
	if LorePlay.savedSettingsTable.canBeDrunkInCities then
		AddDrunkToCities()
	end
end


function IdleEmotes.GetLocation()
	local location = GetPlayerLocationName()
	local zoneName = GetPlayerActiveZoneName()

	if LorePlay.IsPlayerInCity(location) then
		return "City"
	elseif LorePlay.IsPlayerInZone(zoneName) then
		return "Zone"
	elseif LorePlay.IsPlayerInDungeon(location, zoneName) then
		return "Dungeon"
	end
end


function IdleEmotes.PerformIdleEmote()
	if IsPlayerMoving() then return end
	local randomEmote
	local currIdleEmote
	if eventIdleTable["isEnabled"] then
		randomEmote = math.random(#emoteFromEvent)
		currIdleEmote = emoteFromEvent[randomEmote]
	else
		-- Doubles the time checked for Idling to allow current IdleEmote to persist longer
		if didIdleEmote then
			didIdleEmote = false
			return
		end
		local location = IdleEmotes.GetLocation()
		randomEmote = math.random(#defaultIdleTable[location])
		currIdleEmote = defaultIdleTable[location][randomEmote]
	end
	LPEventHandler:FireEvent(EVENT_ON_IDLE_EMOTE, false, true, currIdleEmote)
	PlayEmoteByIndex(currIdleEmote)
	didIdleEmote = true
end


function IdleEmotes.UpdateEmoteFromEvent(eventCode)
	emoteFromEvent = eventIdleTable[eventCode]
	if not eventIdleTable["isEnabled"] then
		eventIdleTable["isEnabled"] = true
	end
end


function IdleEmotes.UpdateStealthState(eventCode, unitTag, stealthState)
	if unitTag ~= LorePlay.player then return end
	if stealthState ~= STEALTH_STATE_NONE then
		isPlayerStealthed = true
	else
		isPlayerStealthed = false
	end
end


function IdleEmotes.IsCharacterIdle()
	if not isActiveEmoting then
		local x, y, didMove = LPUtilities.DidPlayerMove(currentPlayerX, currentPlayerY) 
		if not didMove then
			if isPlayerStealthed == nil then
				IdleEmotes.UpdateStealthState(EVENT_STEALTH_STATE_CHANGED, LorePlay.player, GetUnitStealthState(LorePlay.player))
			end
			if not isPlayerStealthed then
				local interactionType = GetInteractionType()
  				if interactionType == INTERACTION_NONE then
					return true
				end
			end
		else
			currentPlayerX = x
			currentPlayerY = y
			if didIdleEmote then
				didIdleEmote = false
			end
		end
	end
	return false
end


function IdleEmotes.CheckToPerformIdleEmote()
	if IdleEmotes.IsCharacterIdle() then
		IdleEmotes.PerformIdleEmote()
	end
end


function IdleEmotes.OnTradeEvent_For_EVENT_TRADE_INVITE_ACCEPTED(eventCode)
	if eventCode ~= EVENT_TRADE_INVITE_ACCEPTED then return end
	IdleEmotes.UpdateEmoteFromEvent(eventCode)
end


function IdleEmotes.OnTradeEvent_For_TRADE_CESSATION(eventCode)
	if emoteFromEvent == eventIdleTable[EVENT_TRADE_INVITE_ACCEPTED] then
		eventIdleTable["isEnabled"] = false
	end
end


function IdleEmotes.OnPlayerCombatStateEvent(eventCode, inCombat)
	if not inCombat then
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
		end
	else
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
		end
	end
end


function IdleEmotes.OnMountedEvent(eventCode, mounted)
	if not mounted then
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
		end
	else
		if LorePlay.savedSettingsTable.isIdleEmotesOn then
			EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
		end
	end
end


function IdleEmotes.OnChatterEvent(eventCode)
	if eventCode == EVENT_CHATTER_BEGIN then
		EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
	else
		EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
	end
end


local function OnActiveEmote(eventCode, isEmotingNow)
	if eventCode ~= EVENT_ACTIVE_EMOTE then return end
	if isEmotingNow then
		isActiveEmoting = true
		EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
	else
		isActiveEmoting = false
		if not IsMounted() then
			EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
		end
	end
end


function IdleEmotes.UnregisterIdleEvents()
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, IdleEmotes.OnMountedEvent)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, IdleEmotes.OnPlayerCombatStateEvent)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_STEALTH_STATE_CHANGED, IdleEmotes.UpdateStealthState)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_CHATTER_BEGIN, IdleEmotes.OnChatterEvent)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_CHATTER_END, IdleEmotes.OnChatterEvent)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_TRADE_INVITE_ACCEPTED, IdleEmotes.OnTradeEvent_For_EVENT_TRADE_INVITE_ACCEPTED)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_TRADE_SUCCEEDED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	LPEventHandler:UnregisterForEvent(LorePlay.name, EVENT_TRADE_CANCELED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	LPEventHandler:UnregisterForLocalEvent(EVENT_ACTIVE_EMOTE, OnActiveEmote)
	EVENT_MANAGER:UnregisterForUpdate("IdleEmotes")
end


function IdleEmotes.RegisterIdleEvents()
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_MOUNTED_STATE_CHANGED, IdleEmotes.OnMountedEvent)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_PLAYER_COMBAT_STATE, IdleEmotes.OnPlayerCombatStateEvent)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_STEALTH_STATE_CHANGED, IdleEmotes.UpdateStealthState)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_CHATTER_BEGIN, IdleEmotes.OnChatterEvent)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_CHATTER_END, IdleEmotes.OnChatterEvent)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_TRADE_INVITE_ACCEPTED, IdleEmotes.OnTradeEvent_For_EVENT_TRADE_INVITE_ACCEPTED)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_TRADE_SUCCEEDED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	LPEventHandler:RegisterForEvent(LorePlay.name, EVENT_TRADE_CANCELED, IdleEmotes.OnTradeEvent_For_TRADE_CESSATION)
	LPEventHandler:RegisterForLocalEvent(EVENT_ACTIVE_EMOTE, OnActiveEmote)
	EVENT_MANAGER:RegisterForUpdate("IdleEmotes", idleTime, IdleEmotes.CheckToPerformIdleEmote)
end


function IdleEmotes.InitializeIdle()
	if not LorePlay.savedSettingsTable.isIdleEmotesOn then return end
	IdleEmotes.CreateDefaultIdleEmotesTable()
	IdleEmotes.CreateEventIdleEmotesTable()
	currentPlayerX, currentPlayerY = GetMapPlayerPosition(LorePlay.player)
	IdleEmotes.RegisterIdleEvents()
end

LorePlay = IdleEmotes