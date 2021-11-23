fx_version 'cerulean'
games { 'gta5' };

description "eIFylwheels eDen Discord : https://discord.gg/aurezia / Izkk Discord : https://discord.gg/X65Vxv9QuA"

version "1.0"

Author "eDen x Izkk"


client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
}

shared_scripts {
    "shared/config.lua",
}

client_scripts{
    "client/*.lua",
}

server_scripts{
    '@mysql-async/lib/MySQL.lua',
    "server/*.lua",
}