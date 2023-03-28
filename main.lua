function comf_get_rank(playerName)
  for i = 1, MAX_RAID_MEMBERS do
    local name, rank = GetRaidRosterInfo(i)
    if name == playerName then
      return rank
    end
  end
  return nil
end

function comf_find_clubid(communityName)
  local clubs = C_Club.GetSubscribedClubs()
  for i,v in ipairs(clubs) do
    if (v.name == communityName) then
      return v
    end
  end
  return nil
end

SLASH_COMF1 = "/comf"
SlashCmdList["COMF"] = function(msg, editBox)
  local count = 0
  local playerName = UnitName("player")
  local rank = comf_get_rank(playerName)
  local club = comf_find_clubid("Savage Alliance Slayers")
  if not club then
    print("SAS: Community not found!")
  else
    print("SAS: ", club.clubId)
    local c = C_Club.GetClubMembers(club.clubId)
    for i,v in ipairs(c) do
      local memberInfo = C_Club.GetMemberInfo(club.clubId, v);
      if memberInfo ~= nil then
        local n = UnitInRaid(memberInfo.name)
        if n ~= nil then
          count = count + 1
          print("SAS: ", memberInfo.name)
          if rank == 2 then
            PromoteToAssistant(memberInfo.name)
          end
        end
      end
    end
    print("Found: ", count)
  end
end