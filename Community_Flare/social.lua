local ADDON_NAME, NS = ...

-- localize stuff
local _G                                        = _G
local GetPlayerInfoByGUID                       = _G.GetPlayerInfoByGUID
local GetRealmName                              = _G.GetRealmName
local InCombatLockdown                          = _G.InCombatLockdown
local PVEFrame_ShowFrame                        = _G.PVEFrame_ShowFrame
local SocialQueueGetGroupMembers                = _G.C_SocialQueue.GetGroupMembers
local SocialQueueGetGroupQueues                 = _G.C_SocialQueue.GetGroupQueues
local UIParentLoadAddOn                         = _G.UIParentLoadAddOn
local print                                     = _G.print
local select                                    = _G.select
local time                                      = _G.time

-- initialize group
function NS.CommunityFlare_Initialize_Group(groupGUID)
	-- initialize
	CommFlare.CF.SocialQueues[groupGUID] = {
		guid = "",
		created = 0,
		popped = 0,
		numQueues = 0,
		leader = nil,
		members = {},
		queues = {},
	}
end

-- add group leader
function NS.CommunityFlare_Add_Group_Leader(groupGUID, playerGUID, playerName, playerRealm)
	-- invalid realm?
	if (not playerRealm or (playerRealm == "")) then
		playerRealm = GetRealmName()
	end

	-- set leader
	CommFlare.CF.SocialQueues[groupGUID].leader = {}
	CommFlare.CF.SocialQueues[groupGUID].leader.guid = playerGUID
	CommFlare.CF.SocialQueues[groupGUID].leader.name = playerName
	CommFlare.CF.SocialQueues[groupGUID].leader.realm = playerRealm
end

-- add group member
function NS.CommunityFlare_Add_Group_Member(groupGUID, index, playerGUID, playerName, playerRealm)
	-- invalid realm?
	if (not playerRealm or (playerRealm == "")) then
		playerRealm = GetRealmName()
	end

	-- set member
	CommFlare.CF.SocialQueues[groupGUID].members[index] = {}
	CommFlare.CF.SocialQueues[groupGUID].members[index].guid = playerGUID
	CommFlare.CF.SocialQueues[groupGUID].members[index].name = playerName
	CommFlare.CF.SocialQueues[groupGUID].members[index].realm = playerRealm
end

-- update group
function NS.CommunityFlare_Update_Group(groupGUID, canJoin, numQueues, leaderGUID)
	-- get leader 
	local leaderName, leaderRealm = select(6, GetPlayerInfoByGUID(leaderGUID))

	-- no name detected?
	if (not leaderName) then
		-- finished
		return
	end

	-- no realm detected?
	if (not leaderRealm or (leaderRealm == "")) then
		leaderRealm = GetRealmName()
	end

	-- rebuild full leader
	local leader = leaderName .. "-" .. leaderRealm

	-- get queues
	local mapName = "N/A"
	local numTrackedQueues = 0
	local queues = SocialQueueGetGroupQueues(groupGUID)
	if (queues and (#queues > 0)) then
		-- process all queues
		for i=1, #queues do
			mapName = queues[i].queueData.mapName
			if (NS.CommunityFlare_IsTrackedPVP(mapName) == true) then
				-- increase
				numTrackedQueues = numTrackedQueues + 1
			end
		end

		-- has tracked queue?
		if (numTrackedQueues > 0) then
			-- previously in queue?
			if (not CommFlare.CF.SocialQueues[groupGUID]) then
				-- create
				NS.CommunityFlare_Initialize_Group(groupGUID)
				CommFlare.CF.SocialQueues[groupGUID].guid = groupGUID
				CommFlare.CF.SocialQueues[groupGUID].created = time()
				CommFlare.CF.SocialQueues[groupGUID].numQueues = numQueues
				CommFlare.CF.SocialQueues[groupGUID].numTrackedQueues = numTrackedQueues

				-- are they community leader?
				if (NS.CommunityFlare_IsCommunityLeader(leader) == true) then
					-- only process for group leaders
					if (NS.CommunityFlare_IsGroupLeader() == true) then
						-- popup queue window enabled?
						if (CommFlare.db.profile.popupQueueWindow == true) then
							-- not in combat?
							if (InCombatLockdown() ~= true) then
								-- Blizzard_PVPUI loaded?
								local loaded, finished = IsAddOnLoaded("Blizzard_PVPUI")
								if (loaded ~= true)then
									-- load Blizzard_PVPUI
									UIParentLoadAddOn("Blizzard_PVPUI")
								end

								-- open pvp honor frame
								PVEFrame_ShowFrame("PVPUIFrame", HonorFrame)
							end
						end

						-- display info
						print("Community Leader " .. leader .. " has queued for " .. mapName .. ". You should problaby queue up now too!")
					end
				end
			else
				-- created?
				if (CommFlare.CF.SocialQueues[groupGUID].created > 0) then
					-- popped?
					if ((numQueues == 0) or (numTrackedQueues < CommFlare.CF.SocialQueues[groupGUID].numTrackedQueues)) then
						-- popped
						NS.CommunityFlare_Add_Group_Leader(groupGUID, leaderGUID, leaderName, leaderRealm)
						CommFlare.CF.SocialQueues[groupGUID].popped = time()
						CommFlare.CF.SocialQueues[groupGUID].numQueues = numQueues
						CommFlare.CF.SocialQueues[groupGUID].numTrackedQueues = numTrackedQueues
					end
				end
			end

			-- leader changed?
			if (CommFlare.CF.SocialQueues[groupGUID].leader and (CommFlare.CF.SocialQueues[groupGUID].leader.guid ~= leaderGUID)) then
				-- update leader
				NS.CommunityFlare_Add_Group_Leader(groupGUID, leaderGUID, name, realm)
			end

			-- save queues
			CommFlare.CF.SocialQueues[groupGUID].queues = queues

			-- get members
			local members = SocialQueueGetGroupMembers(groupGUID)
			if (members and (#members > 0)) then
				-- process all members
				for i=1, #members do
					-- add member
					local playerGUID = members[i].guid
					local playerName, playerRealm = select(6, GetPlayerInfoByGUID(playerGUID))
					if (not playerRealm or (playerRealm == "")) then
						playerRealm = GetRealmName()
					end

					-- add member
					NS.CommunityFlare_Add_Group_Member(groupGUID, i, playerGUID, playerName, playerRealm)
				end
			end
		else
			-- clear queue
			CommFlare.CF.SocialQueues[groupGUID] = nil
		end
	else
		-- clear queue
		CommFlare.CF.SocialQueues[groupGUID] = nil
	end
end
