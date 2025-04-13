fx_version "cerulean"
game "gta5"

ui_page "elements/pausemenu.html"

shared_scripts {
    "shared/client.lua",
}

client_scripts {
    "client/cl_pausemenu.lua"
}

server_scripts {
    "server/sv_pausemenu.lua",
    "shared/customframework.lua",
}

files {
    "shared/config.js",
    "elements/**"
}

escrow_ignore {
    "shared/**"
}