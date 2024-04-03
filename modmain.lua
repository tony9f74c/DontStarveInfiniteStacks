require = GLOBAL.require
require "components/stackable"
require "components/inventoryitem"

TUNING.STACK_SIZE_LARGEITEM = GetModConfigData("cfgChangeLargeStacksSize");
TUNING.STACK_SIZE_MEDITEM = GetModConfigData("cfgChangeMediumStacksSize");
TUNING.STACK_SIZE_SMALLITEM = GetModConfigData("cfgChangeSmallStacksSize");
TUNING.STACK_SIZE_TINYITEM = GetModConfigData("cfgChangeTinyStacksSize");
TUNING.WORTOX_MAX_SOULS = GetModConfigData("cfgChangeMaxWortoxSouls");

-- Update stackable_replica
local function OnStackSizeDirty(inst)
    local self = inst.replica.stackable
    if not self then return end -- Stackable removed
    self:ClearPreviewStackSize()
    inst:PushEvent("inventoryitem_stacksizedirty")
end
local stackable_replica = GLOBAL.require("components/stackable_replica")
stackable_replica._ctor = function(self, inst)
    self.inst = inst
    self._stacksize = GLOBAL.net_byte(inst.GUID, "stackable._stacksize", "stacksizedirty")
    self._stacksizeupper = GLOBAL.net_byte(inst.GUID, "stackable._stacksizeupper", "stacksizedirty")
    self._ignoremaxsize = GLOBAL.net_bool(inst.GUID, "stackable._ignoremaxsize")
    self._maxsize = GLOBAL.net_ushortint(inst.GUID, "stackable._maxsize")

    if not GLOBAL.TheWorld.ismastersim then
        inst:ListenForEvent("stacksizedirty", OnStackSizeDirty)
    end
end
stackable_replica.SetStackSize = function(self, stacksize)
    stacksize = stacksize - 1
    if stacksize <= 255 then
        self._stacksizeupper:set(0)
        self._stacksize:set(stacksize)
    elseif stacksize >= 65535 then
        if self._stacksizeupper:value() ~= 255 then
            self._stacksizeupper:set(255)
        else
            self._stacksize:set_local(255) -- Force sync to trigger UI events even when capped
        end
        self._stacksize:set(255)
    else
        local upper = math.floor(stacksize / 256)
        self._stacksizeupper:set(upper)
        self._stacksize:set(stacksize - upper * 256)
    end
end
stackable_replica.StackSize = function(self)
    return self:GetPreviewStackSize() or (self._stacksizeupper:value() * 256 + self._stacksize:value() + 1)
end

-- Make stackable
local function makeStackable(inst)
    if not inst.components.stackable and GLOBAL.TheWorld.ismastersim then
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    end
end

AddPrefabPostInit("minotaurhorn", makeStackable)
AddPrefabPostInit("tallbirdegg", makeStackable)
if GetModConfigData("cfgRabbitsCanStackToggle") then
    AddPrefabPostInit("rabbit", makeStackable)
end
if GetModConfigData("cfgBirdsCanStackToggle")then
    AddPrefabPostInit("crow", makeStackable)
    AddPrefabPostInit("robin", makeStackable)
    AddPrefabPostInit("robin_winter", makeStackable)
    AddPrefabPostInit("canary", makeStackable)
end
if GetModConfigData("cfgMolesCanStackToggle") then
    AddPrefabPostInit("mole", makeStackable)
end

-- Remove feedable
local function unmakeFeedable(inst)
    if inst.components.perishable and GLOBAL.TheWorld.ismastersim then
        inst:RemoveComponent("perishable")
    end
    if inst.components.inventoryitem and GLOBAL.TheWorld.ismastersim then
        inst.components.inventoryitem:SetOnPutInInventoryFn(function(inst)
            if oninventory then
                oninventory(inst)
            end
        end)
        inst.components.inventoryitem:SetOnDroppedFn(function(inst)
            if ondropped then
                ondropped(inst)
            end
        end)
    end
end
 
if GetModConfigData("cfgMolesDontDieToggle") then
    AddPrefabPostInit("mole", unmakeFeedable)
end
if GetModConfigData("cfgRabbitsDontDieToggle") then
    AddPrefabPostInit("rabbit", unmakeFeedable)
end
if GetModConfigData("cfgBirdsDontDieToggle") then
    AddPrefabPostInit("crow", unmakeFeedable)
    AddPrefabPostInit("robin", unmakeFeedable)
    AddPrefabPostInit("robin_winter", unmakeFeedable)
    AddPrefabPostInit("canary", unmakeFeedable)
end
if GetModConfigData("cfgBeesDontDieToggle") then
    AddPrefabPostInit("bee", unmakeFeedable)
    AddPrefabPostInit("killerbee", unmakeFeedable)
end
if GetModConfigData("cfgButterfliesDontDieToggle") then
    AddPrefabPostInit("butterfly", unmakeFeedable)
end
if GetModConfigData("cfgMosquitosDontDieToggle") then
    AddPrefabPostInit("mosquito", unmakeFeedable)
end

-- Remove murder
local function removeMurder(inst)
    if inst.components.health and GLOBAL.TheWorld.ismastersim then
        inst.components.health.canmurder = false
    end
end
 
if GetModConfigData("cfgMolesRemoveMurderToggle") then
    AddPrefabPostInit("mole", removeMurder)
end
if GetModConfigData("cfgBeesRemoveMurderToggle") then
    AddPrefabPostInit("bee", removeMurder)
    AddPrefabPostInit("killerbee", removeMurder)
end
if GetModConfigData("cfgButterfliesRemoveMurderToggle") then
    AddPrefabPostInit("butterfly", removeMurder)
end
if GetModConfigData("cfgRabbitsRemoveMurderToggle") then
    AddPrefabPostInit("rabbit", removeMurder)
end
if GetModConfigData("cfgBirdsRemoveMurderToggle") then
    AddPrefabPostInit("crow", removeMurder)
    AddPrefabPostInit("robin", removeMurder)
    AddPrefabPostInit("robin_winter", removeMurder)
    AddPrefabPostInit("canary", removeMurder)
end
if GetModConfigData("cfgMosquitosRemoveMurderToggle") then
    AddPrefabPostInit("mosquito", removeMurder)
end

-- Remove perish
local function removePerish(inst)
    if inst.components.perishable and GLOBAL.TheWorld.ismastersim then
        inst:RemoveComponent("perishable")
    end
end

if GetModConfigData("cfgJerkyDoesntPerish") then
    AddPrefabPostInit("meat_dried", removePerish)
    AddPrefabPostInit("smallmeat_dried", removePerish)
    AddPrefabPostInit("monstermeat_dried", removePerish)
end

if GetModConfigData("cfgSeedsDontPerish") then
    AddPrefabPostInit("seeds", removePerish)
end

if GetModConfigData("cfgVegSeedsDontPerish") then
    AddPrefabPostInit("carrot_seeds", removePerish)
    AddPrefabPostInit("corn_seeds", removePerish)
    AddPrefabPostInit("dragonfruit_seeds", removePerish)
    AddPrefabPostInit("durian_seeds", removePerish)
    AddPrefabPostInit("eggplant_seeds", removePerish)
    AddPrefabPostInit("pomegranate_seeds", removePerish)
    AddPrefabPostInit("pumpkin_seeds", removePerish)
    AddPrefabPostInit("watermelon_seeds", removePerish)
    AddPrefabPostInit("garlic_seeds", removePerish)
    AddPrefabPostInit("onion_seeds", removePerish)
    AddPrefabPostInit("pepper_seeds", removePerish)
    AddPrefabPostInit("potato_seeds", removePerish)
    AddPrefabPostInit("tomato_seeds", removePerish)
    AddPrefabPostInit("asparagus_seeds", removePerish)
end
