local config = ClientConfig
local pauseMenuIsOpen = false
local focus = false
local currentJob, name, permID, playtime

-- FUNCTIONS --
function openURL(j) 
  SendNUIMessage({ act = "openurl", url = j })
end

function copyToClipbard(j) 
  SendNUIMessage({ act = "copyToClipboard", copytoboard = j })
end

local function openPauseMenu(hideUI)
  TransitionToBlurred(1000)
  if GetPauseMenuState() == 0 and not IsNuiFocused() then
    if focus == false then
      focus = true
      Wait(100)
      TriggerServerEvent("JayScripts:getPauseMenuInfo")
      SendNUIMessage("openFRAGPauseMenu")
      SetNuiFocus(true, true)
      SetNuiFocusKeepInput(true)
      pauseMenuIsOpen = true
      ExecuteCommand(hideUI and "hideui")
    end
  end
  while pauseMenuIsOpen do
    Wait(1)
    DisableAllControlActions(1)
    DisableFrontendThisFrame()
  end
end

local function closePauseMenu(showUI)
  TransitionFromBlurred(1000)
  SendNUIMessage("closeFRAGPauseMenu")
  SetNuiFocus(false, false)
  SetNuiFocusKeepInput(false)
  if showUI then
    ExecuteCommand("showui")
  else
    ExecuteCommand("hideui")
  end
  pauseMenuIsOpen = false
  focus = false
end


-- EVENTS --
RegisterNetEvent("JayScripts:returnPauseMenuInfo", function(a, b, c, d, playersOnline)
  currentJob = a
  name = b
  permID = c
  playtime = d
  SendNUIMessage({ event = "updatePlayerPauseMenu", currentJob = a or "Unemployed", name = b or "", permID = c or "N/A", playtime = d or 0, playersOnline = playersOnline })
  print(playersOnline)
end)

-- NUI CALLBACKS --
RegisterNUICallback("playPauseMenuHoverSound", function(_, cb)
  SetTimeout(100, function()
    PlaySoundFrontend(-1, "Counter_Tick", "DLC_Biker_Burn_Assets_Sounds", 1)
  end)
  cb({"ok"})
end)

RegisterNUICallback("close", function(a, cb)
  TransitionFromBlurred(1000)
  SetNuiFocus(false, false)
  SetNuiFocusKeepInput(false)
  ExecuteCommand("showui")
  pauseMenuIsOpen = false
  focus = false
  cb({"ok"})
end)

-- FRAG MAP --
RegisterNUICallback("map", function(a, cb)
  closePauseMenu(false) -- Let's not show the UI until they close the actual map. Maybe do a check for the ESC key press via JS
  Wait(300)
  PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
  ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
  while not IsFrontendReadyForControl() do Wait(0) end
  Wait(200)
  SetNuiFocus(false, false)
  Wait(400)
  focus = false
  cb({"ok"})
end)

-- FRAG SETTINGS --
RegisterNUICallback("settings", function(a, cb)
  closePauseMenu(false)   -- Let's not show the UI until they close the actual settings page. Maybe do a check for the ESC key press via JS
  Wait(300)
  ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'), 0, -1)
  DisplayRadar(true)
  SetNuiFocus(false, false)
  Wait(400)
  focus = false
  cb({"ok"})
end)

-- FRAG DISCONNECT --
RegisterNUICallback("disconnect", function(a, cb)
  closePauseMenu(true) -- Close the menu and greet them with a timer before kicking them
  TriggerServerEvent("JayScripts:leaveServer")
  cb({"ok"})
end)

-- FRAG WIKI --
RegisterNUICallback("wiki", function(a, cb) -- Close UI and open a webpage that directs to the WIKI
  closePauseMenu(true)                     -- Close UI and open a webpage that directs to the discord
  openURL(config.Wiki)
  cb({"ok"})
end)

-- FRAG RULES --
RegisterNUICallback("rules", function(_, cb)
  closePauseMenu(false) -- Keep the UI open until we leave the rules page. Maybe a JS key check
  Wait(500)
  openRules()
  cb({"ok"})
end)

RegisterNUICallback("communityrules", function(_, cb)
  closePauseMenu(false) -- Keep the UI open until we leave the rules page. Maybe a JS key check
  Wait(500)
  openCommunityRules()
  cb({"ok"})
end)

RegisterNUICallback("gangrules", function(_, cb)
  closePauseMenu(false) -- Keep the UI open until we leave the rules page. Maybe a JS key check
  Wait(500)
  openGangRules()
  cb({"ok"})
end)

-- FRAG INFORMATION --
RegisterNUICallback("copy_perm_id", function(_, cb)
  closePauseMenu(true) -- Close UI and open a webpage that directs to the discord
  notify("~g~You have copied your ID to the clipboard")
  copyToClipbard(permID)
  cb({"ok"})
end)

RegisterNUICallback("copy_name", function(_, cb) -- !! TODO || Make this copy your name to the clipboard and notify
  closePauseMenu(true)                     -- Close UI and open a webpage that directs to the discord
  notify("~g~You have copied your name to the clipboard")
  copyToClipbard(name)
  cb({"ok"})
end)

RegisterNUICallback("copy_job", function(_, cb) -- !! TODO || Make this copy your job title to the clipboard and notify
  closePauseMenu(true)                         -- Close UI and open a webpage that directs to the discord
  notify("~g~You have copied your job title to the clipboard")
  copyToClipbard(currentJob)
  cb({"ok"})
end)

-- BOTTOM BUTTONS --
RegisterNUICallback("website", function(_, cb)
  closePauseMenu(true) -- Close UI and open a webpage that directs to the discord
  openURL(config.BottomButtons.WebsiteLink)
  cb({"ok"})
end)

RegisterNUICallback("x", function(_, cb)
  closePauseMenu(true) -- Close UI and open a webpage that directs to the discord
  openURL(config.BottomButtons.XLink)
  cb({"ok"})
end)

RegisterNUICallback("store", function(e, cb)
  closePauseMenu(true) -- Close UI and open a webpage that directs to the discord
  openURL(config.BottomButtons.StoreLink)
  cb({"ok"})
end)

RegisterNUICallback("dispute", function(e, cb)
  closePauseMenu(true) -- Close UI and open a webpage that directs to the discord
  customButtonFunction()
  cb({"ok"})
end)

RegisterNUICallback("makeaticket", function(e, cb)
  closePauseMenu(true) -- Close UI and open a webpage that directs to the discord
  openURL(config.DiscordTicket)
  cb({"ok"})
end)

RegisterNUICallback("joindiscord", function(e, cb)
  closePauseMenu(true) -- Close UI and open a webpage that directs to the discord
  openURL(config.Discord)
  cb({"ok"})
end)




RegisterCommand("pausemenu", function()
  pauseMenuIsOpen = not pauseMenuIsOpen
  if pauseMenuIsOpen then
    openPauseMenu(true)
  else
    closePauseMenu(true)
  end
end)

RegisterCommand("openpausemenu", function() 
  openPauseMenu(true) 
end)

RegisterCommand("closepausemenu", function() 
  closePauseMenu(true) 
end)

RegisterKeyMapping('pausemenu', "Opens the pause menu", 'keyboard', "ESCAPE")



CreateThread(function()
  while true do 
    Wait(0)
    SetPauseMenuActive(false)
  end
end)