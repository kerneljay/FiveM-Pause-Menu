ClientConfig = {
    ServerName = "FRAG", -- This is the server name, this is used on the kick message
    LeftServerMessage = "You have left the server, feel free to come back", -- This is the message displayed when you are kicked from the server
    Framework = "Standalone", -- QB, Standalone
    StandaloneFrameworkName = "frag", -- Set this to the name of the resource of your framework
    Discord = "https://discord.gg/6ASTYZF7rS", -- This is the link it will send you to when clicking "Discord"
    DiscordTicket = "https://discord.gg/j2HN4hzjpN",  -- This is the link it will send you to when clicking "Create A Ticket"
    Wiki = "https://wiki.roleplay.co.uk/GTA:Main_Page", -- This is the link it will send you to when clicking "Guides"
    BottomButtons = {
        StoreLink = "https://fragstudios.tebex.io/", -- This is the link it will send you to when clicking "Store"
        XLink = "https://twitter.com/FRAG__Studios", -- This is the link it will send you to when clicking "X"
        WebsiteLink = "https://google.com", -- This is the link it will send you to when clicking "Website"
    }
}

function notify(message)
    exports.frag:notify(message)
end

function customButtonFunction()
    print("Doing custom button")
    -- You can use openURL or copyToClipbard here
end

function openGangRules()
  ExecuteCommand("openguide")
end

function openCommunityRules()
    ExecuteCommand("openguide")
end

function openRules()
    ExecuteCommand("openguide")
end