local ADDON_NAME, NS = ...

-- localize stuff
local _G                                        = _G
local GetAddOnMetadata                          = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local ClubGetSubscribedClubs                    = _G.C_Club.GetSubscribedClubs
local ipairs                                    = _G.ipairs
local print                                     = _G.print
local strformat                                 = _G.string.format

-- get current version
NS.CommunityFlare_Title = GetAddOnMetadata("Community_Flare", "Title") or "unspecified"
NS.CommunityFlare_Version = GetAddOnMetadata("Community_Flare", "Version") or "unspecified"

-- setup main community list
function NS.CommunityFlare_Setup_Main_Community_List(info)
	-- default not set?
	local setDefaults = false
	if (CommFlare.db.profile.communityMain == 0) then
		-- set defaults
		setDefaults = true
	end

	-- process all
	local list = {}
	list[1] = "None"
	CommFlare.CF.ClubCount = 0
	CommFlare.CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(CommFlare.CF.Clubs) do
		-- only communities
		if (v.clubType == Enum.ClubType.Character) then
			-- add club
			list[v.clubId] = v.name
			CommFlare.CF.ClubCount = CommFlare.CF.ClubCount + 1
		end

		-- setting defaults?
		if (setDefaults == true) then
			-- check for default main community
			if (v.name == CommFlare.CF.MainCommName) then
				-- set stuff
				CommFlare.db.profile.communityList = {}
				CommFlare.db.profile.communityMain = v.clubId
				CommFlare.db.profile.communityMainName = v.name

				-- remove all members
				NS.CommunityFlare_RemoveAllClubMembersByClubID(v.clubId)

				-- add all members
				NS.CommunityFlare_AddAllClubMembersByClubID(v.clubId)
			end
		end
	end

	-- default set?
	if (setDefaults == true) then
		-- main found?
		if (CommFlare.db.profile.communityMain > 1) then
			-- process all
			for _,v in ipairs(CommFlare.CF.Clubs) do
				-- check for alts community
				if (v.name == CommFlare.CF.AltsCommName) then
					-- set stuff
					CommFlare.db.profile.communityList = {
						[v.clubId] = true,
					}

					-- remove all members
					NS.CommunityFlare_RemoveAllClubMembersByClubID(v.clubId)

					-- add all members
					NS.CommunityFlare_AddAllClubMembersByClubID(v.clubId)
				end
			end

			-- set default report ID
			CommFlare.db.profile.communityReportID = CommFlare.db.profile.communityMain

			-- readd community chat window
			NS.CommunityFlare_ReaddCommunityChatWindow(CommFlare.db.profile.communityReportID, 1)
		else
			-- process all
			for _,v in ipairs(CommFlare.CF.Clubs) do
				-- check for alts community
				if (v.name == CommFlare.CF.AltsCommName) then
					-- set stuff
					CommFlare.db.profile.communityList = {}
					CommFlare.db.profile.communityMain = v.clubId
					CommFlare.db.profile.communityMainName = v.name
					CommFlare.db.profile.communityReportID = v.clubId

					-- remove all members
					NS.CommunityFlare_RemoveAllClubMembersByClubID(v.clubId)

					-- add all members
					NS.CommunityFlare_AddAllClubMembersByClubID(v.clubId)

					-- readd community chat window
					NS.CommunityFlare_ReaddCommunityChatWindow(CommFlare.db.profile.communityReportID, 1)
				end
			end

			-- still not set?
			if (CommFlare.db.profile.communityMain == 0) then
				-- set stuff
				CommFlare.db.profile.communityList = {}
				CommFlare.db.profile.communityMain = 1
				CommFlare.db.profile.communityMainName = ""
				CommFlare.db.profile.communityReportID = 1
			end
		end
	end

	-- return list
	return list
end

-- set main community
function NS.CommunityFlare_Set_Main_Community(info, value)
	-- save value
	CommFlare.db.profile.communityMain = value

	-- has club id to add for?
	if (value and (value > 1)) then
		-- add all club members
		NS.CommunityFlare_AddAllClubMembersByClubID(value)

		-- set default report ID
		CommFlare.db.profile.communityReportID = CommFlare.db.profile.communityMain

		-- readd community chat window
		NS.CommunityFlare_ReaddCommunityChatWindow(CommFlare.db.profile.communityReportID, 1)
	else
		-- clear community leaders
		CommFlare.db.global.members = {}
		CommFlare.CF.CommunityLeaders = {}
		CommFlare.db.profile.communityReportID = 1
	end

	-- always clear community list
	CommFlare.db.profile.communityList = {}
end

-- setup other community list
function NS.CommunityFlare_Setup_Other_Community_List(info)
	-- process all
	local list = {}
	CommFlare.CF.ClubCount = 0
	CommFlare.CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(CommFlare.CF.Clubs) do
		-- only communities
		if (v.clubType == Enum.ClubType.Character) then
			-- has main community?
			local add = true
			if (CommFlare.db.profile.communityMain and (CommFlare.db.profile.communityMain > 1)) then
				-- skip if matching
				if (v.clubId == CommFlare.db.profile.communityMain) then
					-- do not add
					add = false
				end
			end

			-- add to list?
			if (add == true) then
				-- add club
				list[v.clubId] = v.name
				CommFlare.CF.ClubCount = CommFlare.CF.ClubCount + 1
			end
		end
	end

	-- no list found?
	if (next(list) == nil) then
		-- none
		list[1] = "None"
	end

	-- return list
	return list
end

-- other community disabled?
function NS.CommunityFlare_Other_Community_List_Disabled()
	-- main community set?
	if (CommFlare.db.profile.communityMain > 1) then
		-- process all
		CommFlare.CF.ClubCount = 0
		CommFlare.CF.Clubs = ClubGetSubscribedClubs()
		for _,v in ipairs(CommFlare.CF.Clubs) do
			-- only communities
			if (v.clubType == Enum.ClubType.Character) then
				-- not main?
				if (v.clubId ~= CommFlare.db.profile.communityMain) then
					-- increase
					CommFlare.CF.ClubCount = CommFlare.CF.ClubCount + 1
				end
			end
		end

		-- none found?
		if (CommFlare.CF.ClubCount == 0) then
			-- disabled
			return true
		end

		-- enabled
		return false
	else
		-- disabled
		CommFlare.db.profile.communityReportID = 1
		return true
	end
end

-- other community get item
function NS.CommunityFlare_Other_Community_Get_Item(info, key)
	-- community list?
	if (info[#info] == "communityList") then
		-- not initialized?
		if (not CommFlare.db.profile.communityList) then
			CommFlare.db.profile.communityList = {}
		end

		-- valid?
		if (CommFlare.db.profile.communityList[key]) then
			-- return value
			return CommFlare.db.profile.communityList[key]
		end
	end

	-- false
	return false
end

-- other community set item
function NS.CommunityFlare_Other_Community_Set_Item(info, key, value)
	-- community list?
	if (info[#info] == "communityList") then
		-- not initialized?
		if (not CommFlare.db.profile.communityList) then
			CommFlare.db.profile.communityList = {}
		end

		-- true value?
		if (value == true) then
			-- set the value
			CommFlare.db.profile.communityList[key] = value

			-- update members
			NS.CommunityFlare_UpdateMembers(key, true)

			-- readd community chat window
			NS.CommunityFlare_ReaddCommunityChatWindow(key, 1)
		else
			-- clear the value
			CommFlare.db.profile.communityList[key] = nil

			-- update members
			NS.CommunityFlare_UpdateMembers(key, false)
		end
	end
end

-- is disabled?
function NS.CommunityFlare_Check_ReportID_Disabled()
	-- main community set?
	if (CommFlare.db.profile.communityMain > 1) then
		-- enabled
		return false
	else
		-- disabled
		CommFlare.db.profile.communityReportID = 1
		return true
	end
end

-- set report id / setup channel
function NS.CommunityFlare_Set_ReportID(info, value)
	-- save new value
	CommFlare.db.profile.communityReportID = value

	-- has report ID?
	if (CommFlare.db.profile.communityReportID > 1) then
		-- readd community chat window
		NS.CommunityFlare_ReaddCommunityChatWindow(CommFlare.db.profile.communityReportID, 1)
	end
end

-- setup total database members
function NS.CommunityFlare_Total_Database_Members(info)
	-- sanity checks?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end
	if (not CommFlare.db.global.members) then
		-- initialize
		CommFlare.db.global.members = {}
	end

	-- process all members
	local count = 0
	for k,v in pairs(CommFlare.db.global.members) do
		-- increase
		count = count + 1
	end

	-- return count
	return "Database Members Found: " .. count
end

-- rebuild database members
function NS.CommunityFlare_Rebuild_Database_Members()
	-- sanity checks?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end

	-- clear lists
	CommFlare.db.global.members = {}
	CommFlare.CF.CommunityLeaders = {}

	-- process club members again
	print("Rebuilding Community Database Memberlist.")
	NS.CommunityFlare_Process_Club_Members()

	-- display members found
	print(NS.CommunityFlare_Total_Database_Members(nil))

	-- display leaders count
	local count = 0
	for _,v in ipairs(CommFlare.CF.CommunityLeaders) do
		-- next
		count = count + 1
	end
	print(strformat("%d Community Leaders found.", count))
end

-- setup report community to list
function NS.CommunityFlare_Setup_Report_Community_List(info)
	-- process all
	local list = {}
	list[1] = "None"
	CommFlare.CF.ClubCount = 0
	CommFlare.CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(CommFlare.CF.Clubs) do
		-- only communities
		if (v.clubType == Enum.ClubType.Character) then
			-- add club
			list[v.clubId] = v.name
		end
	end

	-- return list
	return list
end

-- defaults
NS.defaults = {
	profile = {
		-- variables
		MatchStatus = 0,
		SavedTime = 0,

		-- profile only options
		alwaysAutoQueue = false,
		alwaysReaddChannels = false,
		blockGameMenuHotKeys = false,
		blockSharedQuests = 2,
		bnetAutoInvite = true,
		bnetAutoQueue = true,
		communityAutoAssist = 2,
		communityAutoInvite = true,
		communityAutoQueue = true,
		communityDisplayNames = true,
		communityPartyLeader = false,
		communityReporter = true,
		partyLeaderNotify = 2,
		popupQueueWindow = false,
		printDebugInfo = false,
		uninvitePlayersAFK = 0,
		warningLeavingBG = 2,

		-- community stuff
		communityMain = 0,
		communityMainName = "",
		communityList = {},
		communityReportID = 0,
		membersCount = "",

		-- tables
		ASH = {},
		AV = {},
		IOC = {},
		WG = {},
	},
}

-- options
NS.options = {
	name = NS.CommunityFlare_Title .. " " .. NS.CommunityFlare_Version,
	handler = CommFlare,
	type = "group",
	args = {
		community = {
			type = "group",
			order = 1,
			name = "Community Options",
			inline = true,
			args = {
				communityMain = {
					type = "select",
					order = 1,
					name = "Main Community",
					desc = "Choose the main community from your subscribed list",
					values = NS.CommunityFlare_Setup_Main_Community_List,
					get = function(info) return CommFlare.db.profile.communityMain end,
					set = NS.CommunityFlare_Set_Main_Community,
				},
				communityList = {
					type = "multiselect",
					order = 2,
					name = "Other Communities",
					desc = "Choose the other communities from your subscribed list.",
					values = NS.CommunityFlare_Setup_Other_Community_List,
					disabled = NS.CommunityFlare_Other_Community_List_Disabled,
					get = NS.CommunityFlare_Other_Community_Get_Item,
					set = NS.CommunityFlare_Other_Community_Set_Item,
				},
				membersCount = {
					type = "description",
					order = 3,
					name = NS.CommunityFlare_Total_Database_Members,
				},
				rebuildMembers = {
					type = "execute",
					order = 4,
					name = "Rebuild Members",
					desc = "Use this to totally rebuild the Members Database from currently selected Communities.",
					func = NS.CommunityFlare_Rebuild_Database_Members,
				},
				alwaysReaddChannels = {
					type = "toggle",
					order = 5,
					name = "Always remove, then re-add Community Channels to General? *EXPERIMENTAL*",
					desc = "This will automatically delete communities channels from general and re-add them upon login.",
					width = "full",
					get = function(info) return CommFlare.db.profile.alwaysReaddChannels end,
					set = function(info, value) CommFlare.db.profile.alwaysReaddChannels = value end,
				},
			},
		},
		invite = {
			type = "group",
			order = 2,
			name = "Invite Options",
			inline = true,
			args = {
				bnetAutoInvite = {
					type = "toggle",
					order = 1,
					name = "Automatically accept invites from Battle.NET friends?",
					desc = "This will automatically accept group/party invites from Battle.NET friends.",
					width = "full",
					get = function(info) return CommFlare.db.profile.bnetAutoInvite end,
					set = function(info, value) CommFlare.db.profile.bnetAutoInvite = value end,
				},
				communityAutoInvite = {
					type = "toggle",
					order = 2,
					name = "Automatically accept invites from Community members?",
					desc = "This will automatically accept group/party invites from Community members.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityAutoInvite end,
					set = function(info, value) CommFlare.db.profile.communityAutoInvite = value end,
				},
			}
		},
		queue = {
			type = "group",
			order = 3,
			name = "Queue Options",
			inline = true,
			args = {
				alwaysAutoQueue = {
					type = "toggle",
					order = 1,
					name = "Always automatically queue?",
					desc = "This will always automatically accept all queues for you.",
					width = "full",
					get = function(info) return CommFlare.db.profile.alwaysAutoQueue end,
					set = function(info, value) CommFlare.db.profile.alwaysAutoQueue = value end,
				},
				bnetAutoQueue = {
					type = "toggle",
					order = 2,
					name = "Automatically queue if your group leader is your Battle.Net friend?",
					desc = "This will automatically queue if your group leader is your Battle.Net friend.",
					width = "full",
					get = function(info) return CommFlare.db.profile.bnetAutoQueue end,
					set = function(info, value) CommFlare.db.profile.bnetAutoQueue = value end,
				},
				communityAutoQueue = {
					type = "toggle",
					order = 3,
					name = "Automatically queue if your group leader is in Community?",
					desc = "This will automatically queue if your group leader is in Community.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityAutoQueue end,
					set = function(info, value) CommFlare.db.profile.communityAutoQueue = value end,
				},
				popupQueueWindow = {
					type = "toggle",
					order = 4,
					name = "Popup PVP Queue Window upon Leaders queing up? (Only for Group Leaders.)",
					desc = "This will open up the PVP Queue window if a Leader is queing up for PVP so you can queue up too.",
					width = "full",
					get = function(info) return CommFlare.db.profile.popupQueueWindow end,
					set = function(info, value) CommFlare.db.profile.popupQueueWindow = value end,
				},
				communityReporter = {
					type = "toggle",
					order = 5,
					name = "Report queues to Main Community? (Requires Community channel to have /# assigned.)",
					desc = "This will provide a quick popup message for you to send your queue status to the Community chat.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityReporter end,
					set = function(info, value) CommFlare.db.profile.communityReporter = value end,
				},
				communityReportID = {
					type = "select",
					order = 6,
					name = "Community To Report To",
					desc = "Choose the main community from your subscribed list",
					values = NS.CommunityFlare_Setup_Report_Community_List,
					disabled = NS.CommunityFlare_Check_ReportID_Disabled,
					get = function(info) return CommFlare.db.profile.communityReportID end,
					set = NS.CommunityFlare_Set_ReportID,
				},
				uninvitePlayersAFK = {
					type = "select",
					order = 7,
					name = "Uninvite any players that are AFK?",
					desc = "Pops up a box to uninvite any users that are AFK at the time of queuing.",
					values = {
						[0] = "Disabled",
						[3] = "3 Seconds",
						[4] = "4 Seconds",
						[5] = "5 Seconds",
						[6] = "6 Seconds",
					},
					get = function(info) return CommFlare.db.profile.uninvitePlayersAFK end,
					set = function(info, value) CommFlare.db.profile.uninvitePlayersAFK = value end,
				},
			},
		},
		party = {
			type = "group",
			order = 4,
			name = "Party Options",
			inline = true,
			args = {
				partyLeaderNotify = {
					type = "select",
					order = 1,
					name = "Notify you upon given Party Leadership?",
					desc = "This will show a Raid Warning to you when you are given leadership of your party.",
					values = {
						[1] = "None",
						[2] = "Raid Warning",
					},
					get = function(info) return CommFlare.db.profile.partyLeaderNotify end,
					set = function(info, value) CommFlare.db.profile.partyLeaderNotify = value end,
				},
			}
		},
		battleground = {
			type = "group",
			order = 5,
			name = "Battleground Options",
			inline = true,
			args = {
				communityAutoAssist = {
					type = "select",
					order = 1,
					name = "Auto assist community members?",
					desc = "Automatically promotes community members to Raid Assist in matches.",
					values = {
						[1] = "None",
						[2] = "Leaders Only",
						[3] = "All Community Members",
					},
					get = function(info) return CommFlare.db.profile.communityAutoAssist end,
					set = function(info, value) CommFlare.db.profile.communityAutoAssist = value end,
				},
				blockSharedQuests = {
					type = "select",
					order = 2,
					name = "Block shared quests?",
					desc = "Automatically blocks shared quests during a Battleground.",
					values = {
						[1] = "None",
						[2] = "Irrelevant",
						[3] = "All",
					},
					get = function(info) return CommFlare.db.profile.blockSharedQuests end,
					set = function(info, value) CommFlare.db.profile.blockSharedQuests = value end,
				},
				communityDisplayNames = {
					type = "toggle",
					order = 3,
					name = "Displays community member names when running /comf command.",
					desc = "This will automatically display all community members found in the Battleground when the /comf command is run.",
					width = "full",
					get = function(info) return CommFlare.db.profile.communityDisplayNames end,
					set = function(info, value) CommFlare.db.profile.communityDisplayNames = value end,
				},
				warningLeavingBG = {
					type = "select",
					order = 4,
					name = "Warn before Hearthstoning or Teleporting inside a Battleground?",
					desc = "Performs an action if you are about to Hearthstone or Teleport out of an active Battleground.",
					values = {
						[1] = "None",
						[2] = "Raid Warning",
					},
					get = function(info) return CommFlare.db.profile.warningLeavingBG end,
					set = function(info, value) CommFlare.db.profile.warningLeavingBG = value end,
				},
				blockGameMenuHotKeys = {
					type = "toggle",
					order = 5,
					name = "Block Game Menu hotkeys inside PvP Content?",
					desc = "This will block the Game Menus from coming up inside an Arena or Battleground from pressing their hot keys. (To block during recording videos for example.)",
					width = "full",
					get = function(info) return CommFlare.db.profile.blockGameMenuHotKeys end,
					set = function(info, value) CommFlare.db.profile.blockGameMenuHotKeys = value end,
				},
			},
		},
		debug = {
			type = "group",
			order = 6,
			name = "Debug Options",
			inline = true,
			args = {
				printDebugInfo = {
					type = "toggle",
					order = 1,
					name = "Enable some debug printing to General window to help debug issues.",
					desc = "This will print some extra data to your General window that will help MESO debug anything to help fix bugs.",
					width = "full",
					get = function(info) return CommFlare.db.profile.printDebugInfo end,
					set = function(info, value) CommFlare.db.profile.printDebugInfo = value end,
				},
			}
		},
	},
}
