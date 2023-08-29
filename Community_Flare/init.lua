local ADDON_NAME, NS = ...

-- localize stuff
local _G                                        = _G
local BNGetFriendIndex                          = _G.BNGetFriendIndex
local BNSendWhisper                             = _G.BNSendWhisper
local Chat_GetCommunitiesChannel                = _G.Chat_GetCommunitiesChannel
local Chat_GetCommunitiesChannelName            = _G.Chat_GetCommunitiesChannelName
local ChatFrame_AddChannel                      = _G.ChatFrame_AddChannel
local ChatFrame_AddNewCommunitiesChannel        = _G.ChatFrame_AddNewCommunitiesChannel
local ChatFrame_RemoveChannel                   = _G.ChatFrame_RemoveChannel
local ChatFrame_RemoveCommunitiesChannel        = _G.ChatFrame_RemoveCommunitiesChannel
local GetChannelName                            = _G.GetChannelName
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
local GetRealmName                              = _G.GetRealmName
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PromoteToLeader                           = _G.PromoteToLeader
local SendChatMessage                           = _G.SendChatMessage
local StaticPopupDialogs                        = _G.StaticPopupDialogs
local StaticPopup_Show                          = _G.StaticPopup_Show
local UninviteUnit                              = _G.UninviteUnit
local UnitFullName                              = _G.UnitFullName
local UnitGUID                                  = _G.UnitGUID
local UnitInParty                               = _G.UnitInParty
local UnitIsGroupLeader                         = _G.UnitIsGroupLeader
local UnitName                                  = _G.UnitName
local AuraUtilForEachAura                       = _G.AuraUtil.ForEachAura
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
local TimerAfter                                = _G.C_Timer.After
local pairs                                     = _G.pairs
local type                                      = _G.type
local strformat                                 = _G.string.format
local strgmatch                                 = _G.string.gmatch
local strmatch                                  = _G.string.match
local tinsert                                   = _G.table.insert

-- global function (check if dragon riding available)
function IsDragonFlyable()
	local m = MapGetBestMapForUnit("player")
	if ((m >= 2022) and (m <= 2025) or (m == 2085) or (m == 2112)) then
		-- dragon flyable
		return true
	else
		-- not available
		return false
	end
end

-- global function (send variables to other addons)
function CommunityFlare_GetVar(name)
	-- report ID
	if (name == "ReportID") then
		return CommFlare.db.profile.communityReportID
	end
end

-- convert table to string
function NS.CommunityFlare_TableToString(table)
	-- load libraries
	local libS = LibStub:GetLibrary("AceSerializer-3.0")
	local libD = LibStub:GetLibrary("LibDeflate")

	-- all loaded?
	if (libS and libD) then
		-- serialize and compress
		local one = libS:Serialize(table)
		local two = libD:CompressDeflate(one, {level = 9})
		local final = libD:EncodeForPrint(two)

		-- return final
		return final
	end

	-- failed
	return nil
end

-- convert string to table
function NS.CommunityFlare_StringToTable(string)
	-- load libraries
	local libS = LibStub:GetLibrary("AceSerializer-3.0")
	local libD = LibStub:GetLibrary("LibDeflate")

	-- all loaded?
	if (libS and libD) then
		-- decode, decompress, deserialize
		local one = libD:DecodeForPrint(string)
		local two = libD:DecompressDeflate(one)
		local status, final = libS:Deserialize(two)

		-- success?
		if (status == true) then
			-- return final
			return final
		end
	end

	-- failed
	return nil
end

-- parse command
function NS.CommunityFlare_ParseCommand(text)
	local table = {}
	local params = strgmatch(text, "([^@]+)");
	for param in params do
		tinsert(table, param)
	end
	return table
end

-- promote player to party leader
function NS.CommunityFlare_PromoteToPartyLeader(player)
	-- is player full name in party?
	if (UnitInParty(player) == true) then
		PromoteToLeader(player)
		return true
	end

	-- try using short name
	local name, realm = strsplit("-", player)
	if (realm == GetRealmName()) then
		player = name
	end

	-- unit is in party?
	if (UnitInParty(player) == true) then
		PromoteToLeader(player)
		return true
	end
	return false
end

-- load session variables
function NS.CommunityFlare_LoadSession()
	-- misc stuff
	CommFlare.CF.MatchStatus = CommFlare.db.profile.MatchStatus
	CommFlare.CF.Queues = CommFlare.db.profile.Queues or {}

	-- battleground specific data
	CommFlare.CF.ASH = CommFlare.db.profile.ASH or {}
	CommFlare.CF.AV = CommFlare.db.profile.AV or {}
	CommFlare.CF.IOC = CommFlare.db.profile.IOC or {}
	CommFlare.CF.WG = CommFlare.db.profile.WG or {}
end

-- save session variables
function NS.CommunityFlare_SaveSession()
	-- global created?
	if (not CommFlare.db.global) then
		CommFlare.db.global = {}
	end

	-- misc stuff
	CommFlare.db.global.members = CommFlare.db.global.members or {}
	CommFlare.db.profile.MatchStatus = CommFlare.CF.MatchStatus
	CommFlare.db.profile.Queues = CommFlare.CF.Queues or {}
	CommFlare.db.profile.SavedTime = time()

	-- currently in battleground?
	if (PvPIsBattleground() == true) then
		-- save any settings
		CommFlare.db.profile.ASH = CommFlare.CF.ASH or {}
		CommFlare.db.profile.AV = CommFlare.CF.AV or {}
		CommFlare.db.profile.IOC = CommFlare.CF.IOC or {}
		CommFlare.db.profile.WG = CommFlare.CF.WG or {}
	else
		-- reset settings
		CommFlare.db.profile.ASH = {}
		CommFlare.db.profile.AV = {}
		CommFlare.db.profile.IOC = {}
		CommFlare.db.profile.WG = {}
	end
end

-- send to party, whisper, or bnet message
function NS.CommunityFlare_SendMessage(sender, msg)
	-- party?
	if (not sender) then
		SendChatMessage(msg, "PARTY")
	-- string?
	elseif (type(sender) == "string") then
		SendChatMessage(msg, "WHISPER", nil, sender)
	elseif (type(sender) == "number") then
		BNSendWhisper(sender, msg)
	end
end

-- get battle net character
function NS.CommunityFlare_GetBNetFriendName(bnSenderID)
	-- not number?
	if (type(bnSenderID) ~= "number") then
		-- failed
		return nil
	end

	-- get bnet friend index
	local index = BNGetFriendIndex(bnSenderID)
	if (index ~= nil) then
		-- process all bnet accounts logged in
		local numGameAccounts = BattleNetGetFriendNumGameAccounts(index)
		for i=1, numGameAccounts do
			-- check if account has player guid online
			local accountInfo = BattleNetGetFriendGameAccountInfo(index, i)
			if (accountInfo.playerGuid) then
				-- build full player-realm
				return strformat("%s-%s", accountInfo.characterName, accountInfo.realmName)
			end
		end
	end

	-- failed
	return nil
end

-- readd community chat window
function NS.CommunityFlare_ReaddCommunityChatWindow(clubId, streamId)
	-- remove channel
	local channel, chatFrameID = Chat_GetCommunitiesChannel(clubId, streamId)
	if (not channel) then
		-- add channel
		ChatFrame_AddNewCommunitiesChannel(1, clubId, streamId, nil)
	elseif (not chatFrameID or (chatFrameID == 0)) then
		-- remove channel
		ChatFrame_RemoveCommunitiesChannel(ChatFrame1, clubId, streamId, false)

		-- add channel
		ChatFrame_AddNewCommunitiesChannel(1, clubId, streamId, nil)
	else
		-- remove channel
		local channelName = Chat_GetCommunitiesChannelName(clubId, streamId)
		ChatFrame_RemoveChannel(ChatFrame1, channelName)

		-- add channel
		ChatFrame_AddChannel(ChatFrame1, channelName)
	end
end

-- re-add community channels on initial load
function NS.CommunityFlare_ReaddChannelsInitialLoad()
	-- has main community?
	if (CommFlare.db.profile.communityMain > 1) then
		-- readd community chat window
		NS.CommunityFlare_ReaddCommunityChatWindow(CommFlare.db.profile.communityMain, 1)
	end

	-- has other communities?
	if (next(CommFlare.db.profile.communityList)) then
		-- process all
		local timer = 0.2
		for k,v in pairs(CommFlare.db.profile.communityList) do
			-- only process true
			if (v == true) then
				-- stagger readding
				TimerAfter(timer, function ()
					-- readd community chat window
					NS.CommunityFlare_ReaddCommunityChatWindow(k, 1)
				end)

				-- next
				timer = timer + 0.2
			end
		end
	end
end

-- is specialization healer?
function NS.CommunityFlare_IsHealer(spec)
	if (spec == "Discipline") then
		return true
	elseif (spec == "Holy") then
		return true
	elseif (spec == "Mistweaver") then
		return true
	elseif (spec == "Preservation") then
		return true
	elseif (spec == "Restoration") then
		return true
	end
	return false
end

-- is specialization tank?
function NS.CommunityFlare_IsTank(spec)
	if (spec == "Blood") then
		return true
	elseif (spec == "Brewmaster") then
		return true
	elseif (spec == "Guardian") then
		return true
	elseif (spec == "Protection") then
		return true
	elseif (spec == "Vengeance") then
		return true
	end
	return false
end

-- get full player name
function NS.CommunityFlare_GetFullName(player)
	-- force name-realm format
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	end
	return player
end

-- get proper player name by type
function NS.CommunityFlare_GetPlayerName(type)
	local name, realm = UnitFullName("player")
	if (type == "full") then
		-- no realm name?
		if (not realm or (realm == "")) then
			realm = GetRealmName()
		end
		return strformat("%s-%s", name, realm)
	end
	return name
end

-- is currently group leader?
function NS.CommunityFlare_IsGroupLeader()
	-- has sub group members?
	if (GetNumSubgroupMembers() == 0) then
		return true
	-- is group leader?
	elseif (UnitIsGroupLeader("player")) then
		return true
	end
	return false
end

-- get current party leader
function NS.CommunityFlare_GetPartyLeader()
	-- process all sub group members
	for i=1, GetNumSubgroupMembers() do 
		if (UnitIsGroupLeader("party" .. i)) then 
			local name, realm = UnitName("party" .. i)
			if (realm and (realm ~= "")) then
				-- add realm name
				name = name .. "-" .. realm
			end

			-- leader found
			return name
		end
	end

	-- solo atm
	return NS.CommunityFlare_GetPlayerName("full")
end

-- get current party guid
function NS.CommunityFlare_GetPartyLeaderGUID()
	-- process all sub group members
	for i=1, GetNumSubgroupMembers() do 
		if (UnitIsGroupLeader("party" .. i)) then
			-- return guid
			return UnitGUID("party" .. i)
		end
	end

	-- solo atm
	return UnitGUID("player")
end

-- get party unit
function NS.CommunityFlare_GetPartyUnit(player)
	-- force name-realm format
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	end

	-- process all group members
	for i=1, GetNumGroupMembers() do
		local unit = "party" .. i
		local name, realm = UnitName(unit)
		if (name and (name ~= "")) then
			-- no realm name?
			if (not realm or (realm == "")) then
				-- get realm name
				realm = GetRealmName()
			end

			-- full name matches?
			name = name .. "-" .. realm
			if (player == name) then
				return unit
			end
		end
	end

	-- failed
	return nil
end

-- get total group count
function NS.CommunityFlare_GetGroupCount()
	-- get proper count
	CommFlare.CF.Count = 1
	if (IsInGroup()) then
		if (not IsInRaid()) then
			-- update count
			CommFlare.CF.Count = GetNumGroupMembers()
		end
	end

	-- return x/5 count
	return strformat("%d/5", CommFlare.CF.Count)
end

-- get group members
function NS.CommunityFlare_GetGroupMembers()
	-- are you grouped?
	local players = {}
	if (IsInGroup()) then
		-- are you in a raid?
		if (not IsInRaid()) then
			-- process all group members
			for i=1, GetNumGroupMembers() do
				local name, realm = UnitName("party" .. i)

				-- add party member
				players[i] = {}
				players[i].guid = UnitGUID("party" .. i)
				players[i].name = name
				players[i].realm = realm
			end
		end
	else
		-- add yourself
		players[1] = {}
		players[1].guid = UnitGUID("player")
		players[1].player = NS.CommunityFlare_GetPlayerName("full")
	end
	return players
end

-- get member count
function NS.CommunityFlare_GetMemberCount()
	-- sanity check?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end
	if (not CommFlare.db.global.members) then
		-- initialize
		CommFlare.db.global.members = {}
	end

	-- process all
	local count = 0
	for k,v in pairs(CommFlare.db.global.members) do
		-- increase
		count = count + 1
	end

	-- success
	return count
end

-- check if a unit has type aura active
function NS.CommunityFlare_CheckForAura(unit, type, auraName)
	-- save global variable if aura is active
	CommFlare.CF.HasAura = false
	AuraUtilForEachAura(unit, type, nil, function(name, icon, ...)
		if (name == auraName) then
			CommFlare.CF.HasAura = true
			return true
		end
	end)
end

-- popup box
function NS.CommunityFlare_PopupBox(dlg, message)
	-- requires community id?
	local showPopup = true
	if (dlg == "CommunityFlare_Send_Community_Dialog") then
		-- report ID set?
		local clubId = 0
		showPopup = false
		if (CommFlare.db.profile.communityReportID and (CommFlare.db.profile.communityReportID > 1)) then
			-- show
			showPopup = true
		end
	end

	-- show popup?
	if (showPopup == true) then
		-- popup box setup
		local popup = StaticPopupDialogs[dlg]

		-- show the popup box
		CommFlare.CF.PopupMessage = message
		local dialog = StaticPopup_Show(dlg, message)
		if (dialog) then
			dialog.data = CommFlare.CF.PopupMessage
		end

		-- restore popup
		StaticPopupDialogs[dlg] = popup
	end
end

-- send community box setup
StaticPopupDialogs["CommunityFlare_Send_Community_Dialog"] = {
	text = "Send: %s?",
	button1 = "Send",
	button2 = "No",
	OnAccept = function(self, message)
		-- report ID set?
		if (CommFlare.db.profile.communityReportID and (CommFlare.db.profile.communityReportID > 1)) then
			-- club id found?
			local clubId = CommFlare.db.profile.communityReportID
			if (clubId > 0) then
				local streamId = 1
				local channelName = Chat_GetCommunitiesChannelName(clubId, streamId)
				local id, name = GetChannelName(channelName)
				if ((id > 0) and (name ~= nil)) then
					-- send channel messsage (hardware click acquired)
					SendChatMessage(message, "CHANNEL", nil, id)
				end
			end
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- kick box setup
StaticPopupDialogs["CommunityFlare_Kick_Dialog"] = {
	text = "Kick: %s?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, player)
		-- uninvite user
		print("Uninviting ...")
		UninviteUnit(player, "AFK")

		-- community auto invite enabled?
		local text = "You've been removed from the party for being AFK."
		if (CommFlare.db.profile.communityAutoInvite == true) then
			-- update text for info about being reinvited
			text = text .. " Whisper me INV and if a spot is still available, you'll be readded to the party."
		end

		-- send message
		NS.CommunityFlare_SendMessage(player, text)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- hearth stone spells
NS.HearthStoneSpells = {
	[8690] = "Hearthstone",
	[39937] = "There's No Place Like Home",
	[75136] = "Ethereal Portal",
	[94719] = "The Innkeeper's Daughter",
	[136508] = "Dark Portal",
	[171253] = "Garrison Hearthstone",
	[222695] = "Dalaran Hearthstone",
	[278244] = "Greatfather Winter's Hearthstone",
	[278559] = "Headless Horseman's Hearthstone",
	[285362] = "Lunar Elder's Hearthstone",
	[285424] = "Peddlefeet's Lovely Hearthstone",
	[286031] = "Noble Gardener's Hearthstone",
	[286331] = "Fire Eater's Hearthstone",
	[286353] = "Brewfest Reveler's Hearthstone",
	[298068] = "Holographic Digitalization Hearthstone",
	[308742] = "Eternal Traveler's Hearthstone",
	[326064] = "Night Fae Hearthstone",
	[342122] = "Venthyr Sinstone",
	[345393] = "Kyrian Hearthstone",
	[346060] = "Necrolord Hearthstone",
	[363799] = "Dominated Hearthstone",
	[366945] = "Enlightened Hearthstone",
	[367013] = "Broker Translocationi Matrix",
	[375357] = "Timewalker's Hearthstone",
	[391042] = "Ohn'ir Windsage's Hearthstone",
}

-- teleport spells
NS.TeleportSpells = {
	[3561] = "Teleport: Stormwind",
	[3562] = "Teleport: Ironforge",
	[3563] = "Teleport: Undercity",
	[3565] = "Teleport: Darnassus",
	[3566] = "Teleport: Thunder Bluff",
	[3567] = "Teleport: Orgrimmar",
	[23442] = "Dimensional Ripper - Everlook",
	[23453] = "Ultrasafe Transporter: Gadgetzan",
	[32271] = "Teleport: Exodar",
	[32272] = "Teleport: Silvermoon",
	[33690] = "Teleport: Shattrath",
	[35715] = "Teleport: Shattrath",
	[36890] = "Dimensional Ripper - Area 52",
	[36941] = "Ultrasafe Transporter: Toshley's Station",
	[41234] = "Teleport: Black Temple",
	[49358] = "Teleport: Stonard",
	[49359] = "Teleport: Theramore",
	[53140] = "Teleport: Dalaran - Northrend",
	[54406] = "Teleport: Dalaran",
	[66238] = "Teleport: Argent Tournament",
	[71436] = "Teleport: Booty Bay",
	[88342] = "Teleport: Tol Borad",
	[88344] = "Teleport: Tol Borad",
	[89157] = "Teleport: Stormwind",
	[89158] = "Teleport: Orgrimmar",
	[89597] = "Teleport: Tol Borad",
	[89598] = "Teleport: Tol Borad",
	[126755] = "Wormhole Generator: Pandaria",
	[132621] = "Teleport: Vale of Eternal Blossoms",
	[132627] = "Teleport: Vale of Eternal Blossoms",
	[145430] = "Call of the Mists",
	[175604] = "Bladespire Relic",
	[175608] = "Relic of Karabor",
	[176242] = "Teleport: Warspear",
	[176248] = "Teleport: Stormshield",
	[189838] = "Admiral's Compass",
	[193669] = "Beginner's Guide to Dimensional Rifting",
	[193759] = "Teleport: Hall of the Guardian",
	[216138] = "Emblem of Margoss",
	[220746] = "Scroll of Teleport: Ravenholdt",
	[220989] = "Teleport: Dalaran",
	[223805] = "Adept's Guide to Dimensional Rifting",
	[224869] = "Teleport: Dalaran - Broken Isles",
	[231054] = "Violet Seal of the Grand Magus",
	[250796] = "Wormhole Generator: Argus",
	[281403] = "Teleport: Boralus",
	[281404] = "Teleport: Dazar'alor",
	[289283] = "Teleport: Dazar'alor",
	[289284] = "Teleport: Boralus",
	[299083] = "Wormhome Generator: Kul Tiras",
	[299084] = "Wormhome Generator: Zandalar",
	[300047] = "Mountebank's Colorful Cloak",
	[335671] = "Scroll of Teleport: Theater of Pain",
	[344587] = "Teleport: Oribos",
	[395277] = "Teleport: Valdrakken",
	[406714] = "Scroll of Teleport: Zskera Vaults",
}
