-- Localization

local translation = {
    en = {
        name = "Infinite Stacks",
        description = "Increase the stack size of all stackable items.",
		serverFilterTags = {"infinite", "stacks"},
        toggle = {{description = "Enabled", data = true}, {description = "Disabled", data = false}},
        infinite = "Infinite",
        dividers = {
            stacks = "Stacks",
            makeStackable = "Make Stackable",
            removeMurder = "Remove Murder Action",
            removeFeed = "Remove Feeding",
            removePerish = "Remove Perishing",
        },
        tinyItems = {label = "Tiny Items Stack", hover = "Change the stack size of tiny items which normally stack to 60."},
        smallItems = {label = "Small Items Stack", hover = "Change the stack size of small items which normally stack to 40."},
        mediumItems = {label = "Medium Items Stack", hover = "Change the stack size of medium items which normally stack to 20."},
        largeItems = {label = "Large Items Stack", hover = "Change the stack size of large items which normally stack to 10."},
        maxWortox = {label = "Max Wortox Souls", hover = "Change the maximum number of Souls that Wortox is allowed to pick up."},
        jerkyDoesntPerish = "Jerky Doesn't Perish",
        seedsDontPerish = "Seeds Don't Perish",
        vegSeedsDontPerish = "Veg. Seeds Don't Perish",
    dontDieSuffix = " Never Die",
    removeMurderPrefix = "Can't Murder ",
    canStackPrefix = "Stackable ",
        dontDieHover = "Toggle whether they can die or not.",
        removeMurderHover = "Toggle whether you can murder them or not while they are in your bags.",
        canStackHover = "Toggle whether they can stack or not.",
        dontDieList = {"Bees", "Butterflies", "Rabbits", "Birds", "Moles", "Mosquitos"},
        removeMurderList = {"Bees", "Butterflies", "Rabbits", "Birds", "Moles", "Mosquitos"},
        canStackList = {"Armor", "Fueled", "FiniteUses", "Rabbits", "Birds", "Moles", "Fishes", "Spiders"},
    },
    zh = { -- provided by Miooowo: https://github.com/Miooowo
        name = "无限堆叠",
        description = "增加所有可堆叠物品的堆叠大小。",
		serverFilterTags = {"无限", "堆叠"},
        toggle = {{description = "启用", data = true}, {description = "禁用", data = false}},
        infinite = "无限",
        dividers = {
            stacks = "堆叠",
            makeStackable = "可堆叠",
            removeMurder = "删除杀害动作",
            removeFeed = "移除喂食",
            removePerish = "去除腐坏",
        },
        tinyItems = {label = "小型物品堆叠", hover = "更改默认堆叠数量为60的小物品的最大堆叠量。"},
        smallItems = {label = "中型物品堆叠", hover = "更改默认堆叠数量为40的中物品的最大堆叠量。"},
        mediumItems = {label = "大型物品堆叠", hover = "更改默认堆叠数量为20的大型物品的最大堆叠量。"},
        largeItems = {label = "特大物品堆叠", hover = "更改默认堆叠数量为10的特大型物品的最大堆叠量。"},
        maxWortox = {label = "沃托克斯最大灵魂", hover = "更改允许沃托克斯拾取的灵魂数量上限。"},
        jerkyDoesntPerish = "肉干不腐",
        seedsDontPerish = "种子不腐",
        vegSeedsDontPerish = "蔬菜种子不腐",
    dontDieSuffix = "不死",
    removeMurderPrefix = "不可杀害",
    canStackPrefix = "可堆叠",
        dontDieHover = "切换自然死亡或不死",
        removeMurderHover = "切换包内是否可杀害",
        canStackHover = "切换是否可堆叠。",
        dontDieList = {"蜜蜂", "蝴蝶", "兔子", "鸟", "鼹鼠", "蚊子"},
        removeMurderList = {"蜜蜂", "蝴蝶", "兔子", "鸟", "鼹鼠", "蚊子"},
        canStackList = {"护甲", "燃料", "有限次数道具", "兔子", "鸟", "鼹鼠", "鱼", "蜘蛛"},
    },
}

local L = locale
local lang_key = "en"
if L then
    if L == "zh" or L == "zht" or L == "zhr" then
        lang_key = "zh"
    elseif translation[L] then
        lang_key = L
    end
end
local S = translation[lang_key] or translation.en

-- Mod info

name = S.name
description = S.description
author = "Tony"
version = "260112"
forumthread = ""
api_version = 10
all_clients_require_mod = true
dst_compatible = true
client_only_mod = false
icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = S.serverFilterTags

local toggle = S.toggle

local function setCount(k)
    return {description = ""..k.."", data = k}
end

local function dontDie(name)
    return {name = "cfg"..name.."DontDieToggle", label = (name .. (S.dontDieSuffix or "")), 
			options = toggle, default = true, hover = S.dontDieHover}
end

local function removeMurder(name)
    return {name = "cfg"..name.."RemoveMurderToggle", label = ((S.removeMurderPrefix or "") .. name),
			options = toggle, default = true, hover = S.removeMurderHover}
end

local function canStack(name)
    return {name = "cfg"..name.."CanStackToggle", label = ((S.canStackPrefix or "") .. name),
			options = toggle, default = true, hover = S.canStackHover}
end

local function addOption(cfg, desc, opt, def)
    return {name = cfg, label = desc, options = opt, default = def}
end

local function addDivider(name, title)
    return {name = "cfg"..name.."Title", label = title, options = {{description = "", data = false},}, default = false}
end

local stacks = {} for k=1,20,1 do stacks[k] = setCount(k*5) end
    for k=1,18,1 do local m = k+20 stacks[m] = setCount(k*50+100) end
    stacks[#stacks] = {description = S.infinite, data = 65536}

local dontDieList = S.dontDieList
local removeMurderlist = S.removeMurderList
local canStackList = S.canStackList

local options = {
    addDivider("Stacks", S.dividers.stacks),
    {name = "cfgChangeTinyStacksSize", label = S.tinyItems.label, options = stacks, default = 950, hover = S.tinyItems.hover},
    {name = "cfgChangeSmallStacksSize", label = S.smallItems.label, options = stacks, default = 950, hover = S.smallItems.hover},
    {name = "cfgChangeMediumStacksSize", label = S.mediumItems.label, options = stacks, default = 950, hover = S.mediumItems.hover},
    {name = "cfgChangeLargeStacksSize", label = S.largeItems.label, options = stacks, default = 950, hover = S.largeItems.hover},
    {name = "cfgChangeMaxWortoxSouls", label = S.maxWortox.label, options = stacks, default = 20, hover = S.maxWortox.hover}
}

options[#options+1] = addDivider("MakeStackable", S.dividers.makeStackable)
for k=1, #canStackList, 1 do options[#options+1] = canStack(canStackList[k]) end
options[#options+1] = addDivider("RemoveMurder", S.dividers.removeMurder)
for k=1, #removeMurderlist, 1 do options[#options+1] = removeMurder(removeMurderlist[k]) end
options[#options+1] = addDivider("RemoveFeed", S.dividers.removeFeed)
for k=1, #dontDieList, 1 do options[#options+1] = dontDie(dontDieList[k]) end

options[#options+1] = addDivider("RemovePerish", S.dividers.removePerish)
options[#options+1] = addOption("cfgJerkyDoesntPerish", S.jerkyDoesntPerish, toggle, false)
options[#options+1] = addOption("cfgSeedsDontPerish", S.seedsDontPerish, toggle, false)
options[#options+1] = addOption("cfgVegSeedsDontPerish", S.vegSeedsDontPerish, toggle, true)

configuration_options = options