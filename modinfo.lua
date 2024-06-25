local L = locale
name = "Infinite Stacks"
description = "Increase the stack size of all stackable items."
author = "Tony"
version = "240405"
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

local function addDivider(name, title)
    return {name = "cfg"..name.."Title", label = title, options = {{description = "", data = false},}, default = false}
end

local stacks = {} for k=1,20,1 do stacks[k] = setCount(k*5) end
    for k=1,18,1 do local m = k+20 stacks[m] = setCount(k*50+100) end
    stacks[#stacks] = {description = "Infinite", data = 65536}

local dontDieList = {"Bees", "Butterflies", "Rabbits", "Birds", "Moles", "Mosquitos"}
local removeMurderlist = dontDieList
local canStackList = {"Armor", "Fueled", "FiniteUses", "Rabbits", "Birds", "Moles", "Fishes", "Spiders"}

local options = {
    addDivider("Stacks", "Stacks"),
    {name = "cfgChangeTinyStacksSize", label = "Tiny Items Stack", options = stacks, default = 950, hover = "Change the stack size of tiny items which normally stack to 60."},
    {name = "cfgChangeSmallStacksSize", label = "Small Items Stack", options = stacks, default = 950, hover = "Change the stack size of small items which normally stack to 40."},
    {name = "cfgChangeMediumStacksSize", label = "Medium Items Stack", options = stacks, default = 950, hover = "Change the stack size of medium items which normally stack to 20."},
    {name = "cfgChangeLargeStacksSize", label = "Large Items Stack", options = stacks, default = 950, hover = "Change the stack size of large items which normally stack to 10."},
    {name = "cfgChangeMaxWortoxSouls", label = "Max Wortox Souls", options = stacks, default = 20, hover = "Change the maximum number of Souls that Wortox is allowed to pick up."}
}

options[#options+1] = addDivider("MakeStackable", "Make Stackable")
for k=1, #canStackList, 1 do options[#options+1] = canStack(canStackList[k]) end
options[#options+1] = addDivider("RemoveMurder", "Remove Murder Action")
for k=1, #removeMurderlist, 1 do options[#options+1] = removeMurder(removeMurderlist[k]) end
options[#options+1] = addDivider("RemoveFeed", "Remove Feeding")
for k=1, #dontDieList, 1 do options[#options+1] = dontDie(dontDieList[k]) end

options[#options+1] = addDivider("RemovePerish", "Remove Perishing")
options[#options+1] = addOption("cfgJerkyDoesntPerish", "Jerky Doesn't Perish", toggle, false)
options[#options+1] = addOption("cfgSeedsDontPerish", "Seeds Don't Perish", toggle, false)
options[#options+1] = addOption("cfgVegSeedsDontPerish", "Veg. Seeds Don't Perish", toggle, true)


--中文Chinese 汉化来自󰀍Mio󰀍 github_name = Miooowo
if L  == "zh" or L == "zht" or L == "zhr" then
	name = "无限堆叠"
	description = "增加所有可堆叠物品的堆叠大小。"
	author = "代码：Tony 汉化：󰀍Mio󰀍"
	toggle = {{description = "启用", data = true}, {description = "禁用", data = false}}
	
	local function setCount(k)
	    return {description = ""..k.."", data = k}
	end
	
	local function dontDie(name)
	    return {name = "cfg"..name.."DontDieToggle", label = ""..name.."不死", options = toggle, default = true, hover = "切换自然死亡或不死"}
	end
	
	local function removeMurder(name)
	    return {name = "cfg"..name.."RemoveMurderToggle", label = "不可杀害"..name, options = toggle, default = true, hover = "切换包内是否可杀害"}
	end
	
	local function canStack(name)
	    return {name = "cfg"..name.."CanStackToggle", label = "可堆叠"..name, options = toggle, default = true, hover = "切换是否可堆叠。"}
	end
	
	local function addOption(cfg, desc, opt, def)
	    return {name = cfg, label = desc, options = opt, default = def}
	end
	
	local function addDivider(name, title)
	    return {name = "cfg"..name.."Title", label = title, options = {{description = "", data = false},}, default = false}
	end
	
	stacks = {} for k=1,20,1 do stacks[k] = setCount(k*5) end
	    for k=1,18,1 do local m = k+20 stacks[m] = setCount(k*50+100) end
	    stacks[#stacks] = {description = "无限", data = 65536}
	
	dontDieList = {"蜜蜂", "蝴蝶", "兔子", "鸟", "鼹鼠", "蚊子"}
	removeMurderlist = dontDieList
	canStackList = {"护甲", "燃料", "有限次数道具", "兔子", "鸟", "鼹鼠", "鱼", "蜘蛛"}
	
	options = {
	    addDivider("Stacks", "堆叠"),
	    {name = "cfgChangeTinyStacksSize", label = "小型物品堆叠", options = stacks, default = 950, hover = "更改默认堆叠数量为60的小物品的最大堆叠量。"},
	    {name = "cfgChangeSmallStacksSize", label = "中型物品堆叠", options = stacks, default = 950, hover = "更改默认堆叠数量为40的中物品的最大堆叠量。"},
	    {name = "cfgChangeMediumStacksSize", label = "大型物品堆叠", options = stacks, default = 950, hover = "更改默认堆叠数量为20的大型物品的最大堆叠量。"},
	    {name = "cfgChangeLargeStacksSize", label = "特大物品堆叠", options = stacks, default = 950, hover = "更改默认堆叠数量为10的特大型物品的最大堆叠量。"},
	    {name = "cfgChangeMaxWortoxSouls", label = "沃托克斯最大灵魂", options = stacks, default = 20, hover = "更改允许沃托克斯拾取的灵魂数量上限。"}
	}
	
	options[#options+1] = addDivider("MakeStackable", "可堆叠")
	for k=1, #canStackList, 1 do options[#options+1] = canStack(canStackList[k]) end
	options[#options+1] = addDivider("RemoveMurder", "删除杀害动作")
	for k=1, #removeMurderlist, 1 do options[#options+1] = removeMurder(removeMurderlist[k]) end
	options[#options+1] = addDivider("RemoveFeed", "移除喂食")
	for k=1, #dontDieList, 1 do options[#options+1] = dontDie(dontDieList[k]) end
	
	options[#options+1] = addDivider("RemovePerish", "去除腐坏")
	options[#options+1] = addOption("cfgJerkyDoesntPerish", "肉干不腐", toggle, false)
	options[#options+1] = addOption("cfgSeedsDontPerish", "种子不腐", toggle, false)
	options[#options+1] = addOption("cfgVegSeedsDontPerish", "蔬菜种子不腐", toggle, true)
end

configuration_options = options