local ADDON_NAME, NS = ...

-- localize stuff
local _G                                        = _G
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetLFGRoleUpdate                          = _G.GetLFGRoleUpdate
local GetLFGRoleUpdateBattlegroundInfo          = _G.GetLFGRoleUpdateBattlegroundInfo
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNumBattlefieldScores                   = _G.GetNumBattlefieldScores
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetRaidRosterInfo                         = _G.GetRaidRosterInfo
local GetRealmName                              = _G.GetRealmName
local IsAddOnLoaded                             = _G.IsAddOnLoaded
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PromoteToAssistant                        = _G.PromoteToAssistant
local PromoteToLeader                           = _G.PromoteToLeader
local UnitInRaid                                = _G.UnitInRaid
local UnitName                                  = _G.UnitName
local UnitRealmRelationship                     = _G.UnitRealmRelationship
local AreaPoiInfoGetAreaPOIInfo                 = _G.C_AreaPoiInfo.GetAreaPOIInfo
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local PvPGetScoreInfo                           = _G.C_PvP.GetScoreInfo
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
local TimerAfter                                = _G.C_Timer.After
local GetDoubleStatusBarWidgetVisualizationInfo = _G.C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo
local GetIconAndTextWidgetVisualizationInfo     = _G.C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo
local ipairs                                    = _G.ipairs
local mfloor                                    = _G.math.floor
local print                                     = _G.print
local strformat                                 = _G.string.format
local strmatch                                  = _G.string.match
local strsplit                                  = _G.string.split
local tinsert                                   = _G.table.insert
local time                                      = _G.time
local tsort                                     = _G.table.sort

-- epic battlegrounds
NS.EpicBattlegrounds = {
	["Random Epic Battleground"] = 1,
	["Alterac Valley"] = 2,
	["Isle of Conquest"] = 3,
	["Battle for Wintergrasp"] = 4,
	["Ashran"] = 5,
	["Korrak's Revenge"] = 6,
}

-- random battlegrounds
NS.RandomBattlegrounds = {
	["Random Battleground"] = 1,
	["Warsong Gulch"] = 2,
	["Arathi Basin"] = 3,
	["Eye of the Storm"] = 4,
	["The Battle for Gilneas"] = 5,
	["Twin Peaks"] = 6,
	["Silvershard Mines"] = 7,
	["Temple of Kotmogu"] = 8,
	["Seething Shore"] = 9,
	["Deepwind Gorge"] = 10,
}

-- brawls
NS.Brawls = {
	["Brawl: Arathi Blizzard"] = 1,
	["Brawl: Classic Ashran"] = 2,
	["Brawl: Comp Stomp"] = 3,
	["Brawl: Cooking Impossible"] = 4,
	["Brawl: Deep Six"] = 5,
	["Brawl: Deepwind Dunk"] = 6,
	["Brawl: Gravity Lapse"] = 7,
	["Brawl: Packed House"] = 8,
	["Brawl: Shado-Pan Showdown"] = 9,
	["Brawl: Southshore vs. Tarren Mill"] = 10,
	["Brawl: Temple of Hotmogu"] = 11,
	["Brawl: Warsong Scramble"] = 12,
}

-- is epic battleground?
function NS.CommunityFlare_IsEpicBG(name)
	-- check from name
	if (NS.EpicBattlegrounds[name] and (NS.EpicBattlegrounds[name] > 0)) then
		-- yup
		return true
	end

	-- nope
	return false
end

-- get epic battleground id
function NS.CommunityFlare_GetEpicBGID(name)
	-- check from name
	if (NS.EpicBattlegrounds[name] and (NS.EpicBattlegrounds[name] > 0)) then
		-- return id
		return NS.EpicBattlegrounds[name]
	end

	-- invalid
	return 0
end

-- is random battleground?
function NS.CommunityFlare_IsRandomBG(name)
	-- check from name
	if (NS.RandomBattlegrounds[name] and (NS.RandomBattlegrounds[name] > 0)) then
		-- yup
		return true
	end

	-- nope
	return false
end

-- get random battleground id
function NS.CommunityFlare_GetRandomBGID(name)
	-- check from name
	if (NS.RandomBattlegrounds[name] and (NS.RandomBattlegrounds[name] > 0)) then
		-- return id
		return NS.RandomBattlegrounds[name]
	end

	-- invalid
	return 0
end

-- is brawl?
function NS.CommunityFlare_IsBrawl(name)
	-- check from name
	if (NS.Brawls[name] and (NS.Brawls[name] > 0)) then
		-- yup
		return true
	end

	-- nope
	return false
end

-- get brawl id
function NS.CommunityFlare_GetBrawlID(name)
	-- check from name
	if (NS.Brawls[name] and (NS.Brawls[name] > 0)) then
		-- return id
		return NS.Brawls[name]
	end

	-- invalid
	return 0
end

-- is tracked pvp?
function NS.CommunityFlare_IsTrackedPVP(name)
	-- check against tracked maps
	local isBrawl = NS.CommunityFlare_IsBrawl(name)
	local isEpicBattleground = NS.CommunityFlare_IsEpicBG(name)
	local isRandomBattleground = NS.CommunityFlare_IsRandomBG(name)

	-- is epic or random battleground?
	if ((isEpicBattleground == true) or (isRandomBattleground == true) or (isBrawl == true)) then
		-- tracked
		return true, isEpicBattleground, isRandomBattleground, isBrawl
	end

	-- nope
	return false, nil, nil, nil
end

-- reset battleground status
function NS.CommunityFlare_Reset_Battleground_Status()
	-- reset stuff
	CommFlare.CF.MapID = 0
	CommFlare.CF.ASH = {}
	CommFlare.CF.AV = {}
	CommFlare.CF.IOC = {}
	CommFlare.CF.WG = {}
	CommFlare.CF.MapInfo = {}
	CommFlare.CF.MatchStartTime = 0
	CommFlare.CF.Reloaded = false
end

-- get player raid rank
function NS.CommunityFlare_GetRaidRank(player)
	-- process all raid members
	for i=1, MAX_RAID_MEMBERS do
		local name, rank = GetRaidRosterInfo(i)
		if (player == name) then
			return rank
		end
	end
	return nil
end

-- promote player to leader
function NS.CommunityFlare_Battleground_PromoteToLeader(player)
	-- is player full name in raid?
	if (UnitInRaid(player) ~= nil) then
		PromoteToLeader(player)
		return true
	end

	-- try using short name
	local name, realm = strsplit("-", player, 2)
	if (realm == GetRealmName()) then
		player = name
	end

	-- unit is in raid?
	if (UnitInRaid(player) ~= nil) then
		PromoteToLeader(player)
		return true
	end
	return false
end

-- look for players with 0 damage and 0 healing
function NS.CommunityFlare_Check_For_Inactive_Players()
	-- any battlefield scores?
	CommFlare.CF.NumScores = GetNumBattlefieldScores()
	if (CommFlare.CF.NumScores == 0) then
		-- finished
		return
	end

	-- has match started yet?
	if (PvPGetActiveMatchDuration() > 0) then
		-- calculate time elapsed
		CommFlare.CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
		CommFlare.CF.Timer.Seconds = mfloor(CommFlare.CF.Timer.MilliSeconds / 1000)
		CommFlare.CF.Timer.Minutes = mfloor(CommFlare.CF.Timer.Seconds / 60)
		CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)

		-- process all scores
		for i=1, CommFlare.CF.NumScores do
			CommFlare.CF.ScoreInfo = PvPGetScoreInfo(i)
			if (CommFlare.CF.ScoreInfo and CommFlare.CF.ScoreInfo.name) then
				-- damage and healing done found?
				if ((CommFlare.CF.ScoreInfo.damageDone ~= nil) and (CommFlare.CF.ScoreInfo.healingDone ~= nil)) then
					-- both equal zero?
					if ((CommFlare.CF.ScoreInfo.damageDone == 0) and (CommFlare.CF.ScoreInfo.healingDone == 0)) then
						-- display
						print(strformat("%s: AFK after %d minutes, %d seconds?", CommFlare.CF.ScoreInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds))
					end
				end
			end
		end
	end
end

-- update battleground status
function NS.CommunityFlare_Update_Battleground_Status()
	-- get MapID
	CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (not CommFlare.CF.MapID) then
		-- failed
		return false
	end

	-- get map info
	CommFlare.CF.MapInfo = MapGetMapInfo(CommFlare.CF.MapID)
	if (not CommFlare.CF.MapInfo) then
		-- failed
		return false
	end

	-- alterac valley or korrak's revenge?
	if ((CommFlare.CF.MapID == 91) or (CommFlare.CF.MapID == 1537)) then
		-- initialize
		CommFlare.CF.AV = {}
		CommFlare.CF.AV.Counts = { Bunkers = 4, Towers = 4 }
		CommFlare.CF.AV.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- alterac valley?
		if (CommFlare.CF.MapID == 91) then
			-- initialize bunkers
			CommFlare.CF.AV.Bunkers = {
				[1] = { id = 1380, name = "IWB", status = "Up" },
				[2] = { id = 1352, name = "North", status = "Up" },
				[3] = { id = 1389, name = "SHB", status = "Up" },
				[4] = { id = 1355, name = "South", status = "Up" }
			}

			-- initialize towers
			CommFlare.CF.AV.Towers = {
				[1] = { id = 1362, name = "East", status = "Up" },
				[2] = { id = 1377, name = "IBT", status = "Up" },
				[3] = { id = 1405, name = "TP", status = "Up" },
				[4] = { id = 1528, name = "West", status = "Up" }
			}
		else
			-- initialize bunkers
			CommFlare.CF.AV.Bunkers = {
				[1] = { id = 6445, name = "IWB", status = "Up" },
				[2] = { id = 6422, name = "North", status = "Up" },
				[3] = { id = 6453, name = "SHB", status = "Up" },
				[4] = { id = 6425, name = "South", status = "Up" }
			}

			-- initialize towers
			CommFlare.CF.AV.Towers = {
				[1] = { id = 6430, name = "East", status = "Up" },
				[2] = { id = 6442, name = "IBT", status = "Up" },
				[3] = { id = 6465, name = "TP", status = "Up" },
				[4] = { id = 6469, name = "West", status = "Up" }
			}
		end

		-- process bunkers
		for i,v in ipairs(CommFlare.CF.AV.Bunkers) do
			CommFlare.CF.AV.Bunkers[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.AV.Bunkers[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.AV.Bunkers[i].status = "Destroyed"
				CommFlare.CF.AV.Counts.Bunkers = CommFlare.CF.AV.Counts.Bunkers - 1
			end
		end

		-- process towers
		for i,v in ipairs(CommFlare.CF.AV.Towers) do
			CommFlare.CF.AV.Towers[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.AV.Towers[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.AV.Towers[i].status = "Destroyed"
				CommFlare.CF.AV.Counts.Towers = CommFlare.CF.AV.Counts.Towers - 1
			end
		end

		-- 1684 = widgetID for Score Remaining
		CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1684)
		if (CommFlare.CF.WidgetInfo) then
			-- set proper scores
			CommFlare.CF.AV.Scores = { Alliance = CommFlare.CF.WidgetInfo.leftBarValue, Horde = CommFlare.CF.WidgetInfo.rightBarValue }
		end

		-- success
		return true
	-- isle of conquest?
	elseif (CommFlare.CF.MapID == 169) then
		-- initialize settings
		CommFlare.CF.IOC = {}
		CommFlare.CF.IOC.Counts = { Alliance = 0, Horde = 0 }
		CommFlare.CF.IOC.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- initialize alliance gates
		CommFlare.CF.IOC.AllianceGates = {
			[1] = { id = 2378, name = "East", status = "Up" },
			[2] = { id = 2379, name = "Front", status = "Up" },
			[3] = { id = 2381, name = "West", status = "Up" }
		}

		-- initialize horde gates
		CommFlare.CF.IOC.HordeGates = {
			[1] = { id = 2374, name = "East", status = "Up" },
			[2] = { id = 2372, name = "Front", status = "Up" },
			[3] = { id = 2376, name = "West", status = "Up" }
		}

		-- process alliance gates
		for i,v in ipairs(CommFlare.CF.IOC.AllianceGates) do
			CommFlare.CF.IOC.AllianceGates[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.IOC.AllianceGates[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.IOC.AllianceGates[i].status = "Destroyed"
				CommFlare.CF.IOC.Counts.Alliance = CommFlare.CF.IOC.Counts.Alliance + 1
			end
		end

		-- process horde gates
		for i,v in ipairs(CommFlare.CF.IOC.HordeGates) do
			CommFlare.CF.IOC.HordeGates[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.IOC.HordeGates[i].id)
			if (CommFlare.CF.POIInfo) then
				CommFlare.CF.IOC.HordeGates[i].status = "Destroyed"
				CommFlare.CF.IOC.Counts.Horde = CommFlare.CF.IOC.Counts.Horde + 1
			end
		end

		-- 1685 = widgetID for Score Remaining
		CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1685)
		if (CommFlare.CF.WidgetInfo) then
			-- set proper scores
			CommFlare.CF.IOC.Scores = { Alliance = CommFlare.CF.WidgetInfo.leftBarValue, Horde = CommFlare.CF.WidgetInfo.rightBarValue }
		end

		-- success
		return true
	-- battle for wintergrasp?
	elseif (CommFlare.CF.MapID == 1334) then
		-- initialize
		CommFlare.CF.WG = {}
		CommFlare.CF.WG.Counts = { Towers = 0 }
		CommFlare.CF.WG.TimeRemaining = "Just entered match. Gates not opened yet!"

		-- get match type
		NS.CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
		CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, 6056) -- Wintergrasp Fortress Gate
		if (CommFlare.CF.POIInfo and (CommFlare.CF.POIInfo.textureIndex == 77)) then
			-- mercenary?
			if (CommFlare.CF.HasAura == true) then
				CommFlare.CF.WG.Type = "Offense"
			else
				CommFlare.CF.WG.Type = "Defense"
			end
		else
			-- mercenary?
			if (CommFlare.CF.HasAura == true) then
				CommFlare.CF.WG.Type = "Defense"
			else
				CommFlare.CF.WG.Type = "Offense"
			end
		end

		-- initialize towers
		CommFlare.CF.WG.Towers = {
			[1] = { id = 6066, name = "East", status = "Up" },
			[2] = { id = 6065, name = "South", status = "Up" },
			[3] = { id = 6067, name = "West", status = "Up" }
		}

		-- process towers
		for i,v in ipairs(CommFlare.CF.WG.Towers) do
			CommFlare.CF.WG.Towers[i].status = "Up"
			CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(CommFlare.CF.MapID, CommFlare.CF.WG.Towers[i].id)
			if (CommFlare.CF.POIInfo and (CommFlare.CF.POIInfo.textureIndex == 51)) then
				CommFlare.CF.WG.Towers[i].status = "Destroyed"
				CommFlare.CF.WG.Counts.Towers = CommFlare.CF.WG.Counts.Towers + 1
			end
		end

		-- match not started yet?
		if (CommFlare.CF.MatchStatus ~= 1) then
			-- 1612 = widgetID for Time Remaining
			CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(1612)
			if (CommFlare.CF.WidgetInfo) then
				-- set proper time
				CommFlare.CF.WG.TimeRemaining = CommFlare.CF.WidgetInfo.text
			end
		end

		-- success
		return true
	-- ashran?
	elseif (CommFlare.CF.MapID == 1478) then
		-- initialize
		if (not CommFlare.CF.ASH) then
			CommFlare.CF.ASH = { Jeron = "Up", Rylal = "Up" }
		end
		CommFlare.CF.ASH.Scores = { Alliance = "N/A", Horde = "N/A" }

		-- reloaded?
		if (CommFlare.CF.Reloaded == true) then
			-- match maybe reloaded, use saved session
			CommFlare.CF.ASH.Jeron = CommFlare.db.profile.ASH.Jeron
			CommFlare.CF.ASH.Rylai = CommFlare.db.profile.ASH.Rylai
		end

		-- 1997 = widgetID for Score Remaining
		CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1997)
		if (CommFlare.CF.WidgetInfo) then
			-- set proper scores
			CommFlare.CF.ASH.Scores = { Alliance = CommFlare.CF.WidgetInfo.leftBarValue, Horde = CommFlare.CF.WidgetInfo.rightBarValue }
		end

		-- success
		return true
	end

	-- not epic battleground
	return false
end

-- count stuff in battlegrounds and promote to assists
function NS.CommunityFlare_Battleground_Setup(isPrint)
	-- initialize stuff
	CommFlare.CF.CommCount = 0
	CommFlare.CF.MercsCount = 0
	CommFlare.CF.Horde.Count = 0
	CommFlare.CF.Alliance.Count = 0
	CommFlare.CF.Horde.Tanks = 0
	CommFlare.CF.Horde.Healers = 0
	CommFlare.CF.Alliance.Tanks = 0
	CommFlare.CF.Alliance.Healers = 0

	-- any battlefield scores?
	CommFlare.CF.NumScores = GetNumBattlefieldScores()
	if (CommFlare.CF.NumScores == 0) then
		-- should print?
		if (isPrint == true) then
			-- not in battleground yet
			print("Community: Not in Battleground yet")
		end
		return
	end

	-- process all scores
	CommFlare.CF.MercList = nil
	CommFlare.CF.PlayerList = nil
	CommFlare.CF.CommNamesList = {}
	CommFlare.CF.MercNamesList = {}
	CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
	for i=1, CommFlare.CF.NumScores do
		CommFlare.CF.ScoreInfo = PvPGetScoreInfo(i)
		if (CommFlare.CF.ScoreInfo and CommFlare.CF.ScoreInfo.faction and CommFlare.CF.ScoreInfo.talentSpec) then
			-- is healer or tank?
			CommFlare.CF.IsTank = NS.CommunityFlare_IsTank(CommFlare.CF.ScoreInfo.talentSpec)
			CommFlare.CF.IsHealer = NS.CommunityFlare_IsHealer(CommFlare.CF.ScoreInfo.talentSpec)

			-- force name-realm format
			local player = CommFlare.CF.ScoreInfo.name
			if (not strmatch(player, "-")) then
				-- add realm name
				player = player .. "-" .. GetRealmName()
			end

			-- horde faction?
			if (CommFlare.CF.ScoreInfo.faction == 0) then
				-- community member?
				if (CommunityFlare_IsCommunityMember(player)) then
					-- add to names
					tinsert(CommFlare.CF.CommNamesList, CommFlare.CF.ScoreInfo.name)

					-- player has raid leader?
					if (CommFlare.CF.PlayerRank == 2) then
						CommFlare.CF.AutoPromote = false
						if (CommFlare.db.profile.communityAutoAssist == 2) then
							if (CommunityFlare_IsCommunityLeader(player) == true) then
								CommFlare.CF.AutoPromote = true
							end
						elseif (CommFlare.db.profile.communityAutoAssist == 3) then
							CommFlare.CF.AutoPromote = true
						end
						if (CommFlare.CF.AutoPromote == true) then
							PromoteToAssistant(CommFlare.CF.ScoreInfo.name)
						end
					end

					-- increase count
					CommFlare.CF.CommCount = CommFlare.CF.CommCount + 1
				end

				-- increase horde counts
				CommFlare.CF.Horde.Count = CommFlare.CF.Horde.Count + 1
				if (CommFlare.CF.IsHealer == true) then
					CommFlare.CF.Horde.Healers = CommFlare.CF.Horde.Healers + 1
				elseif (CommFlare.CF.IsTank == true) then
					CommFlare.CF.Horde.Tanks = CommFlare.CF.Horde.Tanks + 1
				end
			else
				-- community member?
				if (CommunityFlare_IsCommunityMember(player)) then
					-- add to names
					tinsert(CommFlare.CF.MercNamesList, CommFlare.CF.ScoreInfo.name)

					-- player has raid leader?
					if (CommFlare.CF.PlayerRank == 2) then
						CommFlare.CF.AutoPromote = false
						if (CommFlare.db.profile.communityAutoAssist == 2) then
							if (CommunityFlare_IsCommunityLeader(player) == true) then
								CommFlare.CF.AutoPromote = true
							end
						elseif (CommFlare.db.profile.communityAutoAssist == 3) then
							CommFlare.CF.AutoPromote = true
						end
						if (CommFlare.CF.AutoPromote == true) then
							PromoteToAssistant(CommFlare.CF.ScoreInfo.name)
						end
					end

					-- increase count
					CommFlare.CF.MercsCount = CommFlare.CF.MercsCount + 1
				end

				-- increase alliance counts
				CommFlare.CF.Alliance.Count = CommFlare.CF.Alliance.Count + 1
				if (CommFlare.CF.IsHealer == true) then
					CommFlare.CF.Alliance.Healers = CommFlare.CF.Alliance.Healers + 1
				elseif (CommFlare.CF.IsTank == true) then
					CommFlare.CF.Alliance.Tanks = CommFlare.CF.Alliance.Tanks + 1
				end
			end
		end
	end

	-- should print?
	if (isPrint == true) then
		-- display faction results
		print(strformat("Horde: Healers = %d, Tanks = %d", CommFlare.CF.Horde.Healers, CommFlare.CF.Horde.Tanks))
		print(strformat("Alliance: Healers = %d, Tanks = %d", CommFlare.CF.Alliance.Healers, CommFlare.CF.Alliance.Tanks))
	end

	-- has mercenaries?
	if (CommFlare.CF.MercsCount > 0) then
		-- sort mercenary names list
		tsort(CommFlare.CF.MercNamesList)

		-- build player list
		for k,v in pairs(CommFlare.CF.MercNamesList) do
			-- list still empty? start it!
			if (CommFlare.CF.PlayerList == nil) then
				CommFlare.CF.MercList = v
			else
				CommFlare.CF.MercList = CommFlare.CF.MercList .. ", " .. v
			end
		end

		-- display community names?
		if (CommFlare.db.profile.communityDisplayNames == true) then
			-- should print?
			if (isPrint == true) then
				-- found merc list?
				if (CommFlare.CF.MercList ~= nil) then
					-- display community mercenaries
					print("Community Mercenaries: ", CommFlare.CF.MercList)
				end
			end
		end

		-- should print?
		if (isPrint == true) then
			-- display mercs count
			print(strformat("Found: %d Mercenaries", CommFlare.CF.MercsCount))
		end
	end

	-- has community players?
	if (CommFlare.CF.CommCount > 0) then
		-- sort community players
		tsort(CommFlare.CF.CommNamesList)

		-- build player list
		for k,v in pairs(CommFlare.CF.CommNamesList) do
			-- list still empty? start it!
			if (CommFlare.CF.PlayerList == nil) then
				CommFlare.CF.PlayerList = v
			else
				CommFlare.CF.PlayerList = CommFlare.CF.PlayerList .. ", " .. v
			end
		end

		-- display community names?
		if (CommFlare.db.profile.communityDisplayNames == true) then
			-- should print?
			if (isPrint == true) then
				-- found player list?
				if (CommFlare.CF.PlayerList ~= nil) then
					-- display community members
					print("Community: ", CommFlare.CF.PlayerList)
				end
			end
		end
	end

	-- should print?
	if (isPrint == true) then
		-- display community count
		print(strformat("Found: %d", CommFlare.CF.CommCount))
	end
end

-- get current status
function NS.CommunityFlare_Get_Current_Status()
	-- currently in battleground?
	local text = {}
	if (PvPIsBattleground() == true) then
		-- update battleground status
		if (NS.CommunityFlare_Update_Battleground_Status() == true) then
			-- has match started yet?
			if (PvPGetActiveMatchDuration() > 0) then
				-- community count not loaded yet?
				if (CommFlare.CF.CommCount == 0) then
					-- process battleground stuff / counts
					NS.CommunityFlare_Battleground_Setup(false)
				end

				-- calculate time elapsed
				CommFlare.CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
				CommFlare.CF.Timer.Seconds = mfloor(CommFlare.CF.Timer.MilliSeconds / 1000)
				CommFlare.CF.Timer.Minutes = mfloor(CommFlare.CF.Timer.Seconds / 60)
				CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)

				-- alterac valley or korrak's revenge?
				if ((CommFlare.CF.MapID == 91) or (CommFlare.CF.MapID == 1537)) then
					-- set text to alterac valley status
					text[1] = strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Horde = %s; Bunkers Left = %d/4; Towers Left = %d/4; %d Community Members", CommFlare.CF.MapInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.AV.Scores.Alliance, CommFlare.CF.AV.Scores.Horde, CommFlare.CF.AV.Counts.Bunkers, CommFlare.CF.AV.Counts.Towers, CommFlare.CF.CommCount)
				-- isle of conquest?
				elseif (CommFlare.CF.MapID == 169) then
					-- set text to isle of conquest status
					text[1] = strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Gates Destroyed: %d/3; Horde = %s; Gates Destroyed: %d/3; %d Community Members", CommFlare.CF.MapInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.IOC.Scores.Alliance, CommFlare.CF.IOC.Counts.Alliance, CommFlare.CF.IOC.Scores.Horde, CommFlare.CF.IOC.Counts.Horde, CommFlare.CF.CommCount)
				-- battle for wintergrasp?
				elseif (CommFlare.CF.MapID == 1334) then
					-- set text to wintergrasp status
					text[1] = strformat("%s (%s): %s; Time Elapsed = %d minutes, %d seconds; Towers Destroyed: %d/3; %d Community Members", CommFlare.CF.MapInfo.name, CommFlare.CF.WG.Type, CommFlare.CF.WG.TimeRemaining, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.WG.Counts.Towers, CommFlare.CF.CommCount)
				-- ashran?
				elseif (CommFlare.CF.MapID == 1478) then
					-- set text to ashran status
					text[1] = strformat("%s: Time Elapsed = %d minutes, %d seconds; Alliance = %s; Horde = %s; Jeron = %s; Rylai = %s; %d Community Members", CommFlare.CF.MapInfo.name, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, CommFlare.CF.ASH.Scores.Alliance, CommFlare.CF.ASH.Scores.Horde, CommFlare.CF.ASH.Jeron, CommFlare.CF.ASH.Rylai, CommFlare.CF.CommCount)
				end
			else
				-- set text to gates not opened yet
				text[1] = strformat("%s: Just entered match. Gates not opened yet! (%d Community Members.)", CommFlare.CF.MapInfo.name, CommFlare.CF.CommCount)
			end
		else
			-- set text to not an epic battleground
			text[1] = strformat("%s: Not an Epic Battleground to track.", CommFlare.CF.MapInfo.name)
		end
	else
		-- check for queued battleground
		CommFlare.CF.Leader = NS.CommunityFlare_GetPartyLeader()
		for i=1, GetMaxBattlefieldID() do
			-- get battleground types by name
			local status, mapName = GetBattlefieldStatus(i)
			local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)

			-- queued and tracked?
			if ((status == "queued") and (isTracked == true)) then
				-- set text to time in queue
				CommFlare.CF.Timer.MilliSeconds = GetBattlefieldTimeWaited(i)
				CommFlare.CF.Timer.Seconds = mfloor(CommFlare.CF.Timer.MilliSeconds / 1000)
				CommFlare.CF.Timer.Minutes = mfloor(CommFlare.CF.Timer.Seconds / 60)
				CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)
				text[i] = strformat("%s has been queued for %d minutes and %d seconds for %s.", CommFlare.CF.Leader, CommFlare.CF.Timer.Minutes, CommFlare.CF.Timer.Seconds, mapName)
			end
		end
	end

	-- return text
	return text
end

-- process status check
function NS.CommunityFlare_Process_Status_Check(sender)
	-- get status
	local text = NS.CommunityFlare_Get_Current_Status()
	if (text and text[1]) then
		-- has more than one?
		if (text[2]) then
			-- process all
			local timer = 0.0
			for i=1, #text do
				-- reported
				reported = true

				-- send replies staggered
				TimerAfter(timer, function()
					-- report queue time
					NS.CommunityFlare_SendMessage(sender, text[i])
				end)

				-- next
				timer = timer + 0.2
			end

			-- not reported?
			if (reported == false) then
				-- send message
				NS.CommunityFlare_SendMessage(sender, "Not currently in an Epic Battleground or queue!")
			end
		else
			-- send text to sender
			NS.CommunityFlare_SendMessage(sender, text[1])

			-- add to table for later
			CommFlare.CF.StatusCheck[sender] = time()
		end
	end
end

-- report joined with estimated time
function NS.CommunityFlare_Report_Joined_With_Estimated_Time()
	-- clear role chosen table
	CommFlare.CF.RoleChosen = {}

	-- check if currently in queue
	for i=1, GetMaxBattlefieldID() do
		-- is tracked pvp?
		local status, mapName = GetBattlefieldStatus(i)
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if (isTracked == true) then
			-- get estimated time
			CommFlare.CF.Timer.MilliSeconds = GetBattlefieldEstimatedWaitTime(i)
			if (CommFlare.CF.Timer.MilliSeconds > 0) then
				-- calculate minutes / seconds
				CommFlare.CF.Timer.Seconds = mfloor(CommFlare.CF.Timer.MilliSeconds / 1000)
				CommFlare.CF.Timer.Minutes = mfloor(CommFlare.CF.Timer.Seconds / 60)
				CommFlare.CF.Timer.Seconds = CommFlare.CF.Timer.Seconds - (CommFlare.CF.Timer.Minutes * 60)

				-- does the player have the mercenary buff?
				local text = NS.CommunityFlare_GetGroupCount()
				NS.CommunityFlare_CheckForAura("player", "HELPFUL", "Mercenary Contract")
				if (CommFlare.CF.HasAura == true) then
					-- build text for mercenary queue
					CommFlare.CF.Queues[i].mercenary = true
					text = text .. " Joined Mercenary Queue for " .. mapName .. "! Estimated Wait: " .. CommFlare.CF.Timer.Minutes .. " minutes, " .. CommFlare.CF.Timer.Seconds .. " seconds!"
				else
					-- build text for normal epic battleground queue
					CommFlare.CF.Queues[i].mercenary = false
					text = text .. " Joined Queue for " .. mapName .. "! Estimated Wait: " .. CommFlare.CF.Timer.Minutes .. " minutes, " .. CommFlare.CF.Timer.Seconds .. " seconds!"
				end

				-- check if group has room for more
				if (CommFlare.CF.Count < 5) then
					-- community auto invite enabled?
					if (CommFlare.db.profile.communityAutoInvite == true) then
						-- update text
						text = text .. " (For auto invite, whisper me INV)"
					end
				end

				-- is epic battleground?
				local shouldReport = false
				if (isEpicBattleground == true) then
					-- report random epic battlegrounds option enabled?
					if (CommFlare.db.profile.reportQueueRandomEpicBgs == true) then
						shouldReport = true
					end
				-- is random battleground?
				elseif (isRandomBattleground == true) then
					-- report random battlegrounds option enabled?
					if (CommFlare.db.profile.reportQueueRandomBgs == true) then
						shouldReport = true
					end
				-- is brawl?
				elseif (isBrawl == true) then
					-- report brawls option enabled?
					if (CommFlare.db.profile.reportQueueBrawls == true) then
						shouldReport = true
					end
				end

				-- should report?
				if (shouldReport == true) then
					-- send to community?
					NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
				end
			else
				-- try again
				TimerAfter(0.2, NS.CommunityFlare_Report_Joined_With_Estimated_Time)
				return
			end
		end
	end
end

-- iniialize queue session
function NS.CommunityFlare_Initialize_Queue_Session()
	-- clear role chosen table
	CommFlare.CF.RoleChosen = {}

	-- not group leader?
	if (NS.CommunityFlare_IsGroupLeader() ~= true) then
		-- finished
		return
	end

	-- is tracked pvp?
	local mapName = GetLFGRoleUpdateBattlegroundInfo()
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
	if (isTracked == true) then
		-- Blizzard_PVPUI loaded?
		local loaded, finished = IsAddOnLoaded("Blizzard_PVPUI")
		if ((loaded == true) and (finished == true)) then
			-- uninvite players that are afk?
			local uninviteTimer = 0
			if (CommFlare.db.profile.uninvitePlayersAFK > 0) then
				uninviteTimer = CommFlare.db.profile.uninvitePlayersAFK
			end

			-- uninvite enabled?
			if ((uninviteTimer >= 3) and (uninviteTimer <= 6)) then
				-- enable timer
				TimerAfter(uninviteTimer, function()
					local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate()

					-- not in progress?
					if (inProgress ~= true) then
						-- finished
						return
					end

					-- not in a group?
					if (not IsInGroup()) then
						-- finished
						return
					end

					-- in a raid?
					if (IsInRaid()) then
						-- finished
						return
					end

					-- process all
					for i=1, GetNumGroupMembers() do
						local unit = "party" .. i
						local player, realm = UnitName(unit)
						if (player and (player ~= "")) then
							-- check relationship
							local realmRelationship = UnitRealmRelationship(unit)
							if (realmRelationship == LE_REALM_RELATION_SAME) then
								-- player with same realm
								player = player .. "-" .. GetRealmName()
							else
								-- player with different realm
								player = player .. "-" .. realm
							end

							-- role not chosen?
							if (not CommFlare.CF.RoleChosen[player] or (CommFlare.CF.RoleChosen[player] ~= true)) then
								-- are you leader?
								if (NS.CommunityFlare_IsGroupLeader() == true) then
									-- ask to kick?
									NS.CommunityFlare_PopupBox("CommunityFlare_Kick_Dialog", player)
								end
							end
						end
					end
				end)
			end
		end
	end
end
