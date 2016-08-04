LorePlay = LorePlay or {}
LorePlay.majorVersion = 1
LorePlay.minorVersion = 4
LorePlay.bugVersion = 0
LorePlay.version = LorePlay.majorVersion.."."..LorePlay.minorVersion.."."..LorePlay.bugVersion
LorePlay.name = "LorePlay"
LorePlay.player = "player"

function LorePlay.OnAddOnLoaded(event, addonName)
	if addonName ~= LorePlay.name then return end
	LPEventHandler = LibStub:GetLibrary("LibEventHandler-1.0")
	LPEmotesTable.CreateAllEmotesTable()
	LPEmoteHandler.InitializeEmoteHandler()
	LorePlay.InitializeSettings()
    LorePlay.InitializeEmotes()
    LorePlay.InitializeIdle()
    LorePlay.InitializeLoreWear()
    EVENT_MANAGER:UnregisterForEvent(LorePlay.name, event)
    LPEventHandler:RegisterForEvent(EVENT_PLAYER_ACTIVATED, LorePlay.OnPlayerActivated)
end


function LorePlay.OnPlayerActivated(event)
	zo_callLater(function() CHAT_SYSTEM:AddMessage("Welcome to LorePlay, Soulless One!") end, 50)
	LPEventHandler:UnregisterForEvent(event, LorePlay.OnPlayerActivated)
end


EVENT_MANAGER:RegisterForEvent(LorePlay.name, EVENT_ADD_ON_LOADED, LorePlay.OnAddOnLoaded)