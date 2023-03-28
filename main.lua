function comf_get_rank(playerName)
  for i = 1, MAX_RAID_MEMBERS do
    local name, rank = GetRaidRosterInfo(i)
    if name == playerName then
      return rank
    end
  end
  return nil
end

function comf_is_healer(spec)
  if (spec == "Discipline") then
    return 1
  elseif (spec == "Holy") then
    return 1
  elseif (spec == "Mistweaver") then
    return 1
  elseif (spec == "Restoration") then
    return 1
  else
    return 0
  end
end

function comf_is_tank(spec)
  if (spec == "Blood") then
    return 1
  elseif (spec == "Brewmaster") then
    return 1
  elseif (spec == "Guardian") then
    return 1
  elseif (spec == "Protection") then
    return 1
  else
    return 0
  end
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
  -- count some stuff
  local numScores = GetNumBattlefieldScores()
  local numHorde = 0
  local numHordeHealers = 0
  local numHordeTanks = 0
  local numAlliance = 0
  local numAllianceHealers = 0
  local numAllianceTanks = 0
  for i = 1, numScores do
    local name,_,_,_,_,faction,race,_,class,_,_,_,_,_,_,spec = GetBattlefieldScore(i)
    -- if (name == "Mesostealthy") then
    --   print("Index: ", i)
    -- end
    if (faction) then
      local isHealer = comf_is_healer(spec)
      local isTank = comf_is_tank(spec)
      if (faction == 0) then
        numHorde = numHorde + 1
        if (isHealer == 1) then
          numHordeHealers = numHordeHealers + 1
        end
        if (isTank == 1) then
          numHordeTanks = numHordeTanks + 1
        end
      else
        numAlliance = numAlliance + 1
        if (isHealer == 1) then
          numAllianceHealers = numAllianceHealers + 1
        end
        if (isTank == 1) then
          numAllianceTanks = numAllianceTanks + 1
        end
      end
    end
  end
  print(format("Horde: Healers = %d, Tanks = %d", numHordeHealers, numHordeTanks))
  print(string.format("Alliance: Healers = %d, Tanks = %d", numAllianceHealers, numAllianceTanks))

  -- find SAS members
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
