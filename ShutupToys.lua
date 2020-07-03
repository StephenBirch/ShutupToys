local chat_events = {
    "CHAT_MSG_AFK",
    "CHAT_MSG_BG_SYSTEM_ALLIANCE",
    "CHAT_MSG_BG_SYSTEM_HORDE",
    "CHAT_MSG_BG_SYSTEM_NEUTRAL",
    "CHAT_MSG_BN",
    "CHAT_MSG_BN_INLINE_TOAST_ALERT",
    "CHAT_MSG_BN_INLINE_TOAST_BROADCAST",
    "CHAT_MSG_BN_INLINE_TOAST_BROADCAST_INFORM",
    "CHAT_MSG_BN_INLINE_TOAST_CONVERSATION",
    "CHAT_MSG_BN_WHISPER",
    "CHAT_MSG_BN_WHISPER_INFORM",
    "CHAT_MSG_BN_WHISPER_PLAYER_OFFLINE",
    "CHAT_MSG_CHANNEL",
    "CHAT_MSG_CHANNEL_JOIN",
    "CHAT_MSG_CHANNEL_LEAVE",
    "CHAT_MSG_CHANNEL_LIST",
    "CHAT_MSG_CHANNEL_NOTICE",
    "CHAT_MSG_CHANNEL_NOTICE_USER",
    "CHAT_MSG_COMBAT_FACTION_CHANGE",
    "CHAT_MSG_COMBAT_HONOR_GAIN",
    "CHAT_MSG_COMBAT_MISC_INFO",
    "CHAT_MSG_COMBAT_XP_GAIN",
    "CHAT_MSG_COMMUNITIES_CHANNEL",
    "CHAT_MSG_CURRENCY",
    "CHAT_MSG_DND",
    "CHAT_MSG_EMOTE",
    "CHAT_MSG_FILTERED",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_GUILD_ACHIEVEMENT",
    "CHAT_MSG_GUILD_ITEM_LOOTED",
    "CHAT_MSG_IGNORED",
    "CHAT_MSG_INSTANCE_CHAT",
    "CHAT_MSG_INSTANCE_CHAT_LEADER",
    "CHAT_MSG_LOOT",
    "CHAT_MSG_MONEY",
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_MONSTER_PARTY",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_MONSTER_WHISPER",
    "CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_OFFICER",
    "CHAT_MSG_OPENING",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_PET_BATTLE_COMBAT_LOG",
    "CHAT_MSG_PET_BATTLE_INFO",
    "CHAT_MSG_PET_INFO",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_RAID_BOSS_WHISPER",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_RESTRICTED",
    "CHAT_MSG_SAY",
    "CHAT_MSG_SKILL",
    "CHAT_MSG_SYSTEM",
    "CHAT_MSG_TARGETICONS",
    "CHAT_MSG_TEXT_EMOTE",
    "CHAT_MSG_TRADESKILLS",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_YELL"
}

local chatBubbles = GetCVar("chatBubbles")
  
local function generic(self, event, ...)
    SetCVar("chatBubbles", chatBubbles) -- Reset to the original setting
end

local function filterToys(self, event, text, playerName, _, _, _, _, _, _, _, _ , _, guid, ...)
    SetCVar("chatBubbles", chatBubbles) -- Reset to the original setting
    if guid == nil or guid == "" then
        return
    end
    _, _, _, _, _, name, _ = GetPlayerInfoByGUID(guid)
    if UnitExists(name) then
        if UnitIsFriend("player", name) then
           SetCVar("chatBubbles", 0) -- Disable chat bubbles to ignore yelling toys >:(
        end
    end
end

for _, v in pairs(chat_events) do
    if v == "CHAT_MSG_MONSTER_YELL" then
        ChatFrame_AddMessageEventFilter(v, filterToys)
    else
        ChatFrame_AddMessageEventFilter(v, generic)
    end
end

function init(self, event, name)
	if (name ~= "ShutupToys") then return end 
	
    SLASH_ShutupToys1 = "/st"
    SlashCmdList["ShutupToys"] = function(msg)
        if msg == "toggle" then
            if chatBubbles == "1" then
                print("Chatbubbles now disabled")
                chatBubbles = "0"
            else
                print("Chatbubbles now enabled")
                chatBubbles = "1"
            end
        end
    end 
end

local events = CreateFrame("FRAME");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", init);

-- If the player logs out, we want to reset chatBubbles back to the original
local frame = CreateFrame("FRAME");
frame:RegisterEvent("PLAYER_LOGOUT");
local function eventHandler(self, event, ...)
    SetCVar("chatBubbles", chatBubbles) -- Reset to the original setting
end
frame:SetScript("OnEvent", eventHandler);