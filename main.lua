function comf_get_rank(playerName)
  for i = 1, MAX_RAID_MEMBERS do
    local name, rank = GetRaidRosterInfo(i)
    if name == playerName then
      return rank
    end
  end
  return nil
end

function comf_find_clubid(name)
  local clubs = C_Club.GetSubscribedClubs()
  for i,v in ipairs(clubs) do
    if (v.name == "Savage Alliance Slayers") then
      return v
    end
  end
  return nil
end

SLASH_COMF1 = "/comf"
SlashCmdList["COMF"] = function(msg, editBox)
  local playerName = UnitName("player")
  --[[ print("player: ", playerName) --]]
  local rank = comf_get_rank(playerName)
  --[[ print("rank: ", rank) --]]
  local club = comf_find_clubid("Savage Alliance Slayers")
  if not club then
    print("SAS: Community not found!")
  else
    print("SAS: ", club.clubId)
    local c = C_Club.GetClubMembers(club.clubId)
    for i,v in ipairs(c) do
      local memberInfo = C_Club.GetMemberInfo(club.clubId, v);
      if memberInfo.presence == 1 then
        local n = UnitInRaid(memberInfo.name)
        if not n then
          --[[ print("Not in Raid: ", memberInfo.name) --]]
        else
          print("SAS: ", memberInfo.name)
          if rank == 2 then
            PromoteToAssistant(memberInfo.name)
          end
        end
      end
    end
  end
  print("Finished!")
end