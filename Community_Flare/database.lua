local ADDON_NAME, NS = ...

-- localize stuff
local _G                                        = _G
local GetPlayerInfoByGUID                       = _G.GetPlayerInfoByGUID
local GetRealmName                              = _G.GetRealmName
local ClubGetClubInfo                           = _G.C_Club.GetClubInfo
local ClubGetClubMembers                        = _G.C_Club.GetClubMembers
local ClubGetMemberInfo                         = _G.C_Club.GetMemberInfo
local ClubGetSubscribedClubs                    = _G.C_Club.GetSubscribedClubs
local TimerAfter                                = _G.C_Timer.After
local date                                      = _G.date
local ipairs                                    = _G.ipairs
local pairs                                     = _G.pairs
local print                                     = _G.print
local select                                    = _G.select
local strformat                                 = _G.string.format
local strmatch                                  = _G.string.match
local strsplit                                  = _G.string.split
local tinsert                                   = _G.table.insert
local tonumber                                  = _G.tonumber
local tsort                                     = _G.table.sort
local type                                      = _G.type
local wipe                                      = _G.wipe

-- rebuild community leaders
function NS.CommunityFlare_RebuildCommunityLeaders()
	-- process all
	local count = 1
	local orderedList = {}
	local orderedLeaders = {}
	local unorderedLeaders = {}
	CommFlare.CF.CommunityLeaders = {}
	for k,v in pairs(CommFlare.db.global.members) do
		-- owner?
		if (v.role == Enum.ClubRoleIdentifier.Owner) then
			-- add first
			CommFlare.CF.CommunityLeaders[count] = v.name

			-- next
			count = count + 1
		-- leader?
		elseif (v.role == Enum.ClubRoleIdentifier.Leader) then
			-- has priority?
			if (v.priority and (v.priority > 0)) then
				-- not created?
				if (not orderedLeaders[v.priority]) then
					-- create table
					orderedLeaders[v.priority] = {}
				end

				-- add to ordered leaders
				tinsert(orderedLeaders[v.priority], v.name)
			else
				-- add to unordered leaders
				tinsert(unorderedLeaders, v.name)
			end
		end
	end

	-- build proper order list
	for k,v in pairs(orderedLeaders) do
		tinsert(orderedList, k)
		tsort(orderedLeaders[k])
	end

	-- add ordered leaders in proper list order
	tsort(orderedList)
	for k,v in ipairs(orderedList) do
		-- add all found ordered leaders
		for k2,v2 in pairs(orderedLeaders[v]) do
			-- add leader
			CommFlare.CF.CommunityLeaders[count] = v2

			-- next
			count = count + 1
		end
	end
	wipe(orderedList)
	wipe(orderedLeaders)

	-- process unordered leaders
	tsort(unorderedLeaders)
	for k,v in pairs(unorderedLeaders) do
		-- add leader
		CommFlare.CF.CommunityLeaders[count] = v

		-- next
		count = count + 1
	end
	wipe(unorderedLeaders)
end

-- get priority from member note
function NS.CommunityFlare_GetMemberPriority(info)
	-- leader rank?
	if (info.role == Enum.ClubRoleIdentifier.Leader) then
		-- has member note?
		if (info.memberNote and (info.memberNote ~= "")) then
			-- find priority [ start
			local left, right = strsplit('[', info.memberNote)
			if (right and right:find("]")) then
				local priority = strsplit(']', right)
				if (priority and (type(priority) == "string")) then
					-- return number
					priority = tonumber(priority)
					return priority
				end
			end
		end
	-- owner rank?
	elseif (info.role == Enum.ClubRoleIdentifier.Owner) then
		-- always 1st priority
		return 1
	end

	-- none
	return nil
end

-- add community
function NS.CommunityFlare_AddCommunity(id, info)
	-- sanity check?
	if (not CommFlare.db.profile.communities) then
		-- initialize
		CommFlare.db.profile.communities = {}
	end

	-- add to communities
	CommFlare.db.profile.communities[id] = {
		["avatarId"] = info.avatarId,
		["clubType"] = info.clubType,
		["clubId"] = info.clubId,
		["name"] = info.name,
		["shortName"] = info.shortName,
		["crossFaction"] = info.crossFaction,
	}
end

-- add member
function NS.CommunityFlare_AddMember(id, info, rebuild)
	-- build proper name
	local player = info.name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	end

	-- sanity checks?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end
	if (not CommFlare.db.global.members) then
		-- initialize
		CommFlare.db.global.members = {}
	end

	-- exists?
	if (CommFlare.db.global.members[player] and CommFlare.db.global.members[player].clubId) then
		-- updating from proper community id?
		if (CommFlare.db.global.members[player].clubId == id) then
			-- role updated?
			if (CommFlare.db.global.members[player].role ~= info.role) then
				-- update role + rebuild leaders
				CommFlare.db.global.members[player].role = info.role
			end

			-- member note updated?
			if (CommFlare.db.global.members[player].memberNote ~= info.memberNote) then
				-- update role + rebuild leaders
				CommFlare.db.global.members[player].memberNote = info.memberNote
				CommFlare.db.global.members[player].priority = NS.CommunityFlare_GetMemberPriority(info)
			end

			-- add updated date
			CommFlare.db.global.members[player].updated = date()
		end
	else
		-- add to members
		CommFlare.db.global.members[player] = {
			["clubId"] = id,
			["name"] = player,
			["guid"] = info.guid,
			["role"] = info.role,
			["added"] = date(),
			["memberNote"] = info.memberNote,
			["priority"] = NS.CommunityFlare_GetMemberPriority(info),
		}
	end

	-- rebuild leaders?
	if (rebuild == true) then
		-- rebuild community leaders
		NS.CommunityFlare_RebuildCommunityLeaders()
	end
end

-- remove member
function NS.CommunityFlare_RemoveMember(id, info)
	-- build proper name
	local player = info.name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	end

	-- sanity checks?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end
	if (not CommFlare.db.global.members) then
		-- initialize
		CommFlare.db.global.members = {}
	end

	-- exists?
	if (CommFlare.db.global.members[player] and CommFlare.db.global.members[player].clubId) then
		-- matches?
		if (CommFlare.db.global.members[player].clubId == id) then
			-- delete
			CommFlare.db.global.members[player] = nil
		end
	end
end

-- add all club members from club id
function NS.CommunityFlare_AddAllClubMembersByClubID(clubId)
	-- sanity checks?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end
	if (not CommFlare.db.global.members) then
		-- initialize
		CommFlare.db.global.members = {}
	end

	-- get club info
	local info = ClubGetClubInfo(clubId)
	if (info and info.name and (info.name ~= "")) then
		-- process all members
		local count = 0
		local members = ClubGetClubMembers(clubId)
		for _,v in ipairs(members) do
			local mi = ClubGetMemberInfo(clubId, v)
			if ((mi ~= nil) and (mi.name ~= nil)) then
				-- add member
				NS.CommunityFlare_AddMember(clubId, mi, false)

				-- increase
				count = count + 1
			end
		end

		-- rebuild community leaders
		NS.CommunityFlare_RebuildCommunityLeaders()

		-- any removed?
		if (count > 0) then
			-- display amount added
			print(strformat("%s: Added %d %s members to the database.", NS.CommunityFlare_Title, count, info.name))
		end
	end
end

-- remove all club members from club id
function NS.CommunityFlare_RemoveAllClubMembersByClubID(clubId)
	-- sanity checks?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end
	if (not CommFlare.db.global.members) then
		-- initialize
		CommFlare.db.global.members = {}
	end

	-- get club info
	local info = ClubGetClubInfo(clubId)
	if (info and info.name and (info.name ~= "")) then
		-- process all members
		local count = 0
		for k,v in pairs(CommFlare.db.global.members) do
			-- matches?
			if (v.clubId == clubId) then
				-- remove
				CommFlare.db.global.members[k] = nil

				-- increase
				count = count + 1
			end
		end

		-- rebuild community leaders
		NS.CommunityFlare_RebuildCommunityLeaders()

		-- any removed?
		if (count > 0) then
			-- display amount removed
			print(strformat("%s: Removed %d %s members from the database.", NS.CommunityFlare_Title, count, info.name))
		end
	end
end

-- update member database
function NS.CommunityFlare_UpdateMembers(clubId, type)
	-- sanity checks?
	if (not CommFlare.db.global) then
		-- initialize
		CommFlare.db.global = {}
	end
	if (not CommFlare.db.global.members) then
		-- initialize
		CommFlare.db.global.members = {}
	end

	-- adding?
	if (type == true) then
		-- add all club members
		NS.CommunityFlare_AddAllClubMembersByClubID(clubId)
	else
		-- remove all club members
		NS.CommunityFlare_RemoveAllClubMembersByClubID(clubId)
	end
end

-- get club id
function NS.CommunityFlare_FindClubID(name)
	-- main community id already set?
	if (CommFlare.db.profile.communityMain > 1) then
		-- return community main
		return CommFlare.db.profile.communityMain
	end

	-- proper name given?
	if ((name ~= nil) and (type(name) == "string")) then
		-- process all subscribed communities
		CommFlare.CF.Clubs = ClubGetSubscribedClubs()
		for _,v in ipairs(CommFlare.CF.Clubs) do
			if (v.name == name) then
				return v.clubId
			end
		end
	end

	-- failed
	return 0
end

-- process club members
function NS.CommunityFlare_Process_Club_Members()
	-- has community main name?
	local name = CommFlare.CF.MainCommName
	if (CommFlare.db.profile.communityMainName and (CommFlare.db.profile.communityMainName ~= "")) then
		-- update name
		name = CommFlare.db.profile.communityMainName
	end

	-- find main community members
	local clubs = {}
	local clubId = NS.CommunityFlare_FindClubID(name)
	if (clubId > 0) then
		-- main community not set?
		if (CommFlare.db.profile.communityMain and (CommFlare.db.profile.communityMain == 0)) then
			-- update community main
			CommFlare.db.profile.communityMain = clubId
		end

		-- add club id
		tinsert(clubs, clubId)
	end

	-- has community list?
	if (CommFlare.db.profile.communityList and (next(CommFlare.db.profile.communityList) ~= nil)) then
		-- process all lists
		for k,_ in pairs(CommFlare.db.profile.communityList) do
			-- add club id
			tinsert(clubs, k)
		end
	end

	-- process clubs
	for _,clubId in ipairs(clubs) do
		-- club type is a community?
		local info = ClubGetClubInfo(clubId)
		if (info and (info.clubType == Enum.ClubType.Character)) then
			-- add community
			NS.CommunityFlare_AddCommunity(clubId, info)

			-- process all members
			local members = ClubGetClubMembers(clubId)
			for _,v in ipairs(members) do
				local mi = ClubGetMemberInfo(clubId, v)
				if ((mi ~= nil) and (mi.name ~= nil)) then
					-- add member
					NS.CommunityFlare_AddMember(clubId, mi, false)
				end
			end
		end
	end

	-- rebuild community leaders
	NS.CommunityFlare_RebuildCommunityLeaders()

	-- has report ID?
	if (CommFlare.db.profile.communityReportID > 1) then
		-- verify channel is added for proper reporting
		local channel, chatFrameID = Chat_GetCommunitiesChannel(CommFlare.db.profile.communityReportID, 1)
		if (not channel or not chatFrameID) then
			-- readd community chat window
			NS.CommunityFlare_ReaddCommunityChatWindow(CommFlare.db.profile.communityReportID, 1)
		end
	end
end

-- club member added
function NS.CommunityFlare_ClubMemberAdded(clubId, memberId)
	-- get member info
	CommFlare.CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)
	if (CommFlare.CF.MemberInfo ~= nil) then
		-- name not found?
		local info = ClubGetClubInfo(clubId)
		if (not CommFlare.CF.MemberInfo.name) then
			-- try again, 2 seconds later
			TimerAfter(2, function()
				-- get member info
				CommFlare.CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)

				-- name not found?
				if ((CommFlare.CF.MemberInfo ~= nil) and (CommFlare.CF.MemberInfo.name ~= nil)) then
					-- display
					print(strformat("%s: %s (%d, %d) added to Community %s.", NS.CommunityFlare_Title, CommFlare.CF.MemberInfo.name, clubId, memberId, info.name))

					-- add member
					NS.CommunityFlare_AddMember(clubId, CommFlare.CF.MemberInfo, true)
				end
			end)
		else
			-- display
			print(strformat("%s: %s (%d, %d) added to Community %s.", NS.CommunityFlare_Title, CommFlare.CF.MemberInfo.name, clubId, memberId, info.name))

			-- add member
			NS.CommunityFlare_AddMember(clubId, CommFlare.CF.MemberInfo, true)
		end
	end
end

-- club member removed
function NS.CommunityFlare_ClubMemberRemoved(clubId, memberId)
	-- get member info
	CommFlare.CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)
	if (CommFlare.CF.MemberInfo ~= nil) then
		-- found member name?
		local info = ClubGetClubInfo(clubId)
		if (CommFlare.CF.MemberInfo.name ~= nil) then
			-- display
			print(strformat("%s: %s (%d, %d) removed from Community %s.", NS.CommunityFlare_Title, CommFlare.CF.MemberInfo.name, clubId, memberId, info.name))
		end
	end
end

-- club member updated
function NS.CommunityFlare_ClubMemberUpdated(clubId, memberId)
	-- get member info
	CommFlare.CF.MemberInfo = ClubGetMemberInfo(clubId, memberId)
	if (CommFlare.CF.MemberInfo and CommFlare.CF.MemberInfo.name and (CommFlare.CF.MemberInfo.name ~= "")) then
		-- build proper name
		local player = CommFlare.CF.MemberInfo.name
		if (not strmatch(player, "-")) then
			-- add realm name
			player = player .. "-" .. GetRealmName()
		end

		-- exists?
		if (CommFlare.db.global.members[player] and CommFlare.db.global.members[player].clubId) then
			-- role updated?
			local rebuild = false
			if (CommFlare.db.global.members[player].role ~= CommFlare.CF.MemberInfo.role) then
				-- new leader added?
				if (CommFlare.CF.MemberInfo.role == Enum.ClubRoleIdentifier.Leader) then
					-- rebuild
					rebuild = true
				-- old leader removed?
				elseif (CommFlare.db.global.members[player].role == Enum.ClubRoleIdentifier.Leader) then
					-- remove priority
					CommFlare.db.global.members[player].priority = nil

					-- rebuild
					rebuild = true
				end

				-- update role
				CommFlare.db.global.members[player].role = CommFlare.CF.MemberInfo.role
			end

			-- member note updated?
			if (CommFlare.db.global.members[player].memberNote ~= CommFlare.CF.MemberInfo.memberNote) then
				-- update role
				CommFlare.db.global.members[player].memberNote = CommFlare.CF.MemberInfo.memberNote
				CommFlare.db.global.members[player].priority = NS.CommunityFlare_GetMemberPriority(CommFlare.CF.MemberInfo)

				-- rebuild
				rebuild = true
			end

			-- currently leader?
			if (CommFlare.db.global.members[player].role == Enum.ClubRoleIdentifier.Leader) then
				-- get priority from member note
				local priority = NS.CommunityFlare_GetMemberPriority(CommFlare.CF.MemberInfo)
				if (CommFlare.db.global.members[player].priority ~= priority) then
					-- update priority
					CommFlare.db.global.members[player].priority = priority

					-- rebuild
					rebuild = true
				end
			end

			-- rebuild leaders?
			if (rebuild == true) then
				-- rebuild community leaders
				NS.CommunityFlare_RebuildCommunityLeaders()
			end
		end
	end
end

-- find community members who left?
function NS.CommunityFlare_FindExCommunityMembers(clubId)
	local count = 0
	local current = {}
	local members = ClubGetClubMembers(clubId)
	for _,v in ipairs(members) do
		local info = ClubGetMemberInfo(clubId, v)
		if ((info ~= nil) and (info.name ~= nil)) then
			-- build proper name
			local player = info.name
			if (not strmatch(player, "-")) then
				-- add realm name
				player = player .. "-" .. GetRealmName()
			end

			-- add to current
			current[player] = info
		end
	end

	-- process all
	local removed = {}
	for k,v in pairs(CommFlare.db.global.members) do
		-- matches?
		if (v.clubId == clubId) then
			-- not found in current?
			if (not current[k]) then
				-- add removed
				removed[k] = k
				count = count + 1
			end
		end
	end

	-- save removed
	CommFlare.db.global.removed = removed

	-- wipe old
	wipe(current)

	-- display count
	print("Count: ", count)
end

-- is community leader? (yes, intended to be global)
function CommunityFlare_IsCommunityLeader(name)
	-- process all leaders
	for _,v in ipairs(CommFlare.CF.CommunityLeaders) do
		if (name == v) then
			return true
		end
	end
	return false
end

-- is community member? (yes, intended to be global)
function CommunityFlare_IsCommunityMember(name)
	-- invalid name?
	if (not name or (name == "")) then
		-- failed
		return false
	end

	-- need full player-server name
	local isMember = false
	local player, realm = strsplit("-", name, 2)
	if (not realm or (realm == "")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	else
		-- copy name
		player = name
	end

	-- check inside database first
	if (player and (player ~= "") and CommFlare.db.global and CommFlare.db.global.members and CommFlare.db.global.members[player]) then
		-- member found in database
		isMember = true
	end

	-- return status
	return isMember
end

-- get community member (yes, intended to be global)
function CommunityFlare_GetCommunityMember(name)
	-- invalid name?
	if (not name or (name == "")) then
		-- failed
		return nil
	end

	-- need full player-server name
	local isMember = false
	local player, realm = strsplit("-", name, 2)
	if (not realm or (realm == "")) then
		-- add realm name
		player = player .. "-" .. GetRealmName()
	else
		-- copy name
		player = name
	end

	-- check inside database first
	if (player and (player ~= "") and CommFlare.db.global and CommFlare.db.global.members and CommFlare.db.global.members[player]) then
		-- success
		return CommFlare.db.global.members[player]
	end

	-- failed
	return nil
end

-- find player by GUID (yes, intended to be global)
function CommunityFlare_FindCommunityMemberByGUID(guid)
	-- invalid guid?
	if (not guid or (guid == "")) then
		-- failed
		return nil
	end

	-- find name / realm
	local name, realm = select(6, GetPlayerInfoByGUID(guid))

	-- name not found?
	if (not name or (name == "")) then
		-- failed
		return nil
	end

	-- realm not found?
	if (not realm or (realm == "")) then
		-- update realm
		realm = GetRealmName()
	end

	-- check inside database
	local player = name .. "-" .. realm
	if (player and (player ~= "") and CommFlare.db.global and CommFlare.db.global.members and CommFlare.db.global.members[player]) then
		-- return player
		return player
	end

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
	for k,v in pairs(CommFlare.db.global.members) do
		-- matches?
		if (v.guid == guid) then
			-- found
			return k
		end
	end

	-- failed
	return nil
end
