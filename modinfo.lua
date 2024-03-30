name = "Infinite Stacks"
description = "Increase stack size of all stackable items."
author = "Tony"
version = "240330"
forumthread = ""
api_version = 10
all_clients_require_mod = true
dst_compatible = true
client_only_mod = false
icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {"high", "stacks"}

local toggle = {{description = "Enabled", data = true}, {description = "Disabled", data = false}}

local function setCount(k)
    return {description = ""..k.."", data = k}
end

local function dontDie(name)
    return {name = "cfg"..name.."DontDieToggle", label = ""..name.." Never Die", options = toggle, default = true, hover = "Toggle whether they can die or not."}
end

local function removeMurder(name)
    return {name = "cfg"..name.."RemoveMurderToggle", label = "Can't Murder "..name, options = toggle, default = true, hover = "Toggle whether you can murder them or not while they are in your bags."}
end

local function canStack(name)
    return {name = "cfg"..name.."CanStackToggle", label = "Stackable "..name, options = toggle, default = true, hover = "Toggle whether they can stack or not."}
end

local function addOption(cfg, desc, opt, def)
    return {name = cfg, label = desc, options = opt, default = def}
end

local stacks = {} for k=1,20,1 do stacks[k] = setCount(k*5) end
    for k=1,18,1 do local m = k+20 stacks[m] = setCount(k*50+100) end
    stacks[#stacks] = {description = "Infinite", data = 99999}

local dontDieList = {"Bees", "Butterflies", "Rabbits", "Birds", "Moles", "Mosquitos"}
local removeMurderlist = dontDieList
local canStackList = {"Rabbits", "Birds", "Moles"}

local options = {
    {name = "cfgChangeTinyStacksSize", label = "Tiny Items Stack", options = stacks, default = 100, hover = "Change the stack size of tiny items which normally stack to 60."},
    {name = "cfgChangeSmallStacksSize", label = "Small Items Stack", options = stacks, default = 100, hover = "Change the stack size of small items which normally stack to 40."},
    {name = "cfgChangeMediumStacksSize", label = "Medium Items Stack", options = stacks, default = 100, hover = "Change the stack size of medium items which normally stack to 20."},
    {name = "cfgChangeLargeStacksSize", label = "Large Items Stack", options = stacks, default = 100, hover = "Change the stack size of large items which normally stack to 10."},
    {name = "cfgChangeMaxWortoxSouls", label = "Max Wortox Souls", options = stacks, default = 20, hover = "Change the maximum number of Souls that Wortox is allowed to pick up."}
}

for k=1, #canStackList, 1 do options[#options+1] = canStack(canStackList[k]) end
for k=1, #removeMurderlist, 1 do options[#options+1] = removeMurder(removeMurderlist[k]) end
for k=1, #dontDieList, 1 do options[#options+1] = dontDie(dontDieList[k]) end

options[#options+1] = addOption("cfgJerkyDoesntPerish", "Jerky Doesn't Perish", toggle, false)
options[#options+1] = addOption("cfgSeedsDontPerish", "Seeds Don't Perish", toggle, false)
options[#options+1] = addOption("cfgVegSeedsDontPerish", "Veg. Seeds Don't Perish", toggle, true)

configuration_options = options
