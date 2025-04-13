local QBCore, Standalone
local config = ClientConfig
local serverName = config.ServerName
local serverLeaveMessage = config.LeftServerMessage
local framework = config.Framework
local StandaloneFrameworkName = config.StandaloneFrameworkName

local function RunningQB()
  return framework == "QB" or framework == "qb-core"
end

local function RunningStandalone()
  return framework == "Standalone" or framework == "standalone"
end

CreateThread(function()
  if RunningQB() then
    QBCore = exports["qb-core"]
  elseif RunningStandalone() then
    Standalone = exports[StandaloneFrameworkName]
  end
end)

local function getQBInfo(player)
  assert(QBCore.Functions, "Can not find qb-core")
  local jobTitle = QBCore.Functions.GetPlayer(player).PlayerData.job
  local playersName = GetPlayerName(player)
  local permID = player
  return permID, jobTitle, playersName
end

RegisterNetEvent("JayScripts:leaveServer", function() -- ☑️
  local player = source
  assert(player, "Source not found")
  DropPlayer(player, "[" ..serverName.. "] "..serverLeaveMessage)
end)

RegisterNetEvent("JayScripts:getPauseMenuInfo", function()
  local player = source
  assert(player, "Source Not Found")
  local permID, jobTitle, playersName, playtime
  local numberOfPlayersOnline = GetNumPlayerIndices()
  if RunningQB() then
    permID, jobTitle, playersName = getQBInfo(player)
  elseif RunningStandalone() then
    permID, jobTitle, playersName, playtime = getStandaloneInfo(Standalone, player)
  end
  assert(playersName, "Can not find players name")
  assert(permID, "Can not find players ID")
  TriggerClientEvent("JayScripts:returnPauseMenuInfo", player, jobTitle, playersName, permID, playtime, numberOfPlayersOnline)
end)