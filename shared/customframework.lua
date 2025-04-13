
-- IGNORE THIS IF YOU ARERN'T USING STANDALONE

-- This is used for custom frameworks 
---@param Standalone string
---@param player number
-- EDIT THIS FOR YOUR CUSTOM FRAMEWORK

function getStandaloneInfo(Standalone, player)
    assert(Standalone, "Can not find your framework") -- This just makes sure that the framework is valid
    local user_id = Standalone:getUserId(player) -- This could be a Citizen ID or a Permanent ID (Whichever your server uses)
    local jobTitle = Standalone:returnJobTitle(player) -- This is just simply getting their job name from the server
    local playersName = Standalone:getPlayerName(player) -- This is getting their name from the server (EXAMPLE: My server uses a different name system so that is implemented here) You could use GetPlayerName(PlayerId())
    local playtime = Standalone:getPlayTime(user_id) -- This can be enabled by uncommenting it via the HTML (Default, it is disabled as a lot of servers dont have playtime implemented in game)
    return user_id, jobTitle, playersName, playtime -- Return all the details required
end


-- After doing this, make sure to set the framework to "Standalone" and setting the framework resource name within shared/client.lua