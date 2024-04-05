require = GLOBAL.require
require "components/stackable"
require "components/inventoryitem"

TUNING.STACK_SIZE_LARGEITEM = GetModConfigData("cfgChangeLargeStacksSize");
TUNING.STACK_SIZE_MEDITEM = GetModConfigData("cfgChangeMediumStacksSize");
TUNING.STACK_SIZE_SMALLITEM = GetModConfigData("cfgChangeSmallStacksSize");
TUNING.STACK_SIZE_TINYITEM = GetModConfigData("cfgChangeTinyStacksSize");
TUNING.WORTOX_MAX_SOULS = GetModConfigData("cfgChangeMaxWortoxSouls");

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

-- Update finiteuses component to make all items with finite uses stackable
local finiteuses = GLOBAL.require("components/finiteuses")
local finiteuses_ctor = finiteuses._ctor
finiteuses._ctor = function(self, inst)
    finiteuses_ctor(self, inst)
    self.inst:AddComponent("stackable")
    self.inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
end

-- Update finiteuses component to allow stacking
finiteuses.OnSave = function(self)
    if self.current and self.total then
        return { current = self.current, total = self.total }
    end
end
finiteuses.OnLoad = function(self, data)
    if data.current ~= nil and data.total ~= nil then
        self:SetMaxUses(data.total)
        self:SetUses(data.current)
    end
end
finiteuses.Dilute = function(self, current, total)
    if self.inst.components.stackable then
        self.inst.components.finiteuses.total = self.inst.components.finiteuses.total + total
        self.inst.components.finiteuses.current = self.inst.components.finiteuses.current + current
        self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})
    end
end
finiteuses.SplitUses = function(self, uses_removed)
    if self.inst.components.stackable then
        self.inst.components.finiteuses.total = self.inst.components.finiteuses.total - uses_removed
        self.inst.components.finiteuses.current = self.inst.components.finiteuses.current - uses_removed
        self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})
    end
end

-- Update fueled component to make all fueled items stackable
local fueled = GLOBAL.require("components/fueled")
local fueled_ctor = fueled._ctor
fueled._ctor = function(self, inst)
    fueled_ctor(self, inst)
    self.inst:AddComponent("stackable")
    self.inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
end

-- Update fueled component to allow stacking
fueled.Dilute = function(self, currentfuel, maxfuel)
    if self.inst.components.stackable then
        self.inst.components.fueled.maxfuel = self.inst.components.fueled.maxfuel + maxfuel
        self.inst.components.fueled.currentfuel = self.inst.components.fueled.currentfuel + currentfuel
        self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})
    end
end
fueled.SplitFuel = function(self, fuel_removed)
    if self.inst.components.stackable then
        self.inst.components.fueled.maxfuel = self.inst.components.fueled.maxfuel - fuel_removed
        self.inst.components.fueled.currentfuel = self.inst.components.fueled.currentfuel - fuel_removed
        self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})
    end
end
fueled.OnSave = function(self)
    if self.currentfuel and self.maxfuel then
        return { currentfuel = self.currentfuel, maxfuel = self.maxfuel }
    end
end
fueled.OnLoad = function(self, data)
    if data.currentfuel ~= nil and data.maxfuel ~= nil then
        self.maxfuel = data.maxfuel
        self:InitializeFuelLevel(math.max(0, data.currentfuel))
    end
end

-- Update armor component to make all armor stackable
local armor = GLOBAL.require("components/armor")
local armor_ctor = armor._ctor
armor._ctor = function(self, inst)
    armor_ctor(self, inst)
    self.inst:AddComponent("stackable")
    self.inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
end

-- Update armor component to allow stacking
armor.Dilute = function(self, condition, maxcondition)
    if self.inst.components.stackable then
        self.inst.components.armor.maxcondition = self.inst.components.armor.maxcondition + maxcondition
        self.inst.components.armor.condition = self.inst.components.armor.condition + condition
        self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})
    end
end
armor.SplitFuel = function(self, fuel_removed)
    if self.inst.components.stackable then
        self.inst.components.armor.maxcondition = self.inst.components.armor.maxcondition - fuel_removed
        self.inst.components.armor.condition = self.inst.components.armor.condition - fuel_removed
        self.inst:PushEvent("percentusedchange", {percent = self:GetPercent()})
    end
end
armor.OnSave = function(self)
    if self.condition and self.maxcondition then
        return { condition = self.condition, maxcondition = self.maxcondition }
    end
end
armor.OnLoad = function(self, data)
    if data.condition ~= nil and data.maxcondition ~= nil then
        self.maxcondition = data.maxcondition
        self:SetCondition(data.condition)
    end
end

-- Update stackable component to allow stacking of armor, items with finite uses and fueled items
local _src_pos = nil
local stackable = GLOBAL.require("components/stackable")
stackable.Put = function(self, item, source_pos)
    GLOBAL.assert(item ~= self, "cant stack on self" )
    local ret
    if item.prefab == self.inst.prefab and item.skinname == self.inst.skinname then
        local num_to_add = item.components.stackable.stacksize
        local newtotal = self.stacksize + num_to_add
        local oldsize = self.stacksize
        local newsize = math.min(self.maxsize, newtotal)
        local numberadded = newsize - oldsize
        if self.inst.components.armor ~= nil then
            self.inst.components.armor:Dilute(item.components.armor.condition, item.components.armor.maxcondition)
        end
        if self.inst.components.fueled ~= nil then
            self.inst.components.fueled:Dilute(item.components.fueled.currentfuel, item.components.fueled.maxfuel)
        end
        if self.inst.components.finiteuses ~= nil then
            self.inst.components.finiteuses:Dilute(item.components.finiteuses.current, item.components.finiteuses.total)
        end
        if self.inst.components.perishable ~= nil then
            self.inst.components.perishable:Dilute(numberadded, item.components.perishable.perishremainingtime)
        end
        if self.inst.components.inventoryitem ~= nil then
            self.inst.components.inventoryitem:DiluteMoisture(item, numberadded)
        end
        if self.inst.components.edible ~= nil then
            self.inst.components.edible:DiluteChill(item, numberadded)
        end
        if self.inst.components.curseditem ~= nil then
            self.inst.skipspeech = true
        end
        if self.maxsize >= newtotal then
            item:Remove()
        else
            _src_pos = source_pos
            item.components.stackable.stacksize = newtotal - self.maxsize
            _src_pos = nil
            item:PushEvent("stacksizechange", {stacksize = item.components.stackable.stacksize, oldstacksize=num_to_add, src_pos = source_pos })
            ret = item
        end
        _src_pos = source_pos
        self.stacksize = math.min(newsize, 65536)
        _src_pos = nil
        self.inst:PushEvent("stacksizechange", {stacksize = self.stacksize, oldstacksize=oldsize, src_pos = source_pos})
    end
    return ret
end
stackable.Get = function(self, num)
    local num_to_get = num or 1
    if self.stacksize > num_to_get then
        local instance = GLOBAL.SpawnPrefab( self.inst.prefab, self.inst.skinname, self.inst.skin_id, nil )
        self:SetStackSize(self.stacksize - num_to_get)
        instance.components.stackable:SetStackSize(num_to_get)
        if self.ondestack ~= nil then
            self.ondestack(instance)
        end
        if self.inst.components.armor ~= nil then
            instance.components.armor.maxcondition = instance.components.armor.maxcondition * num_to_get
            instance.components.armor.condition = instance.components.armor.condition * num_to_get
            self.inst.components.armor:SplitFuel(instance.components.armor.maxcondition)
        end
        if self.inst.components.fueled ~= nil then
            instance.components.fueled.maxfuel = instance.components.fueled.maxfuel * num_to_get
            instance.components.fueled.currentfuel = instance.components.fueled.currentfuel * num_to_get
            self.inst.components.fueled:SplitFuel(instance.components.fueled.maxfuel)
        end
        if self.inst.components.finiteuses ~= nil then
            instance.components.finiteuses.total = instance.components.finiteuses.total * num_to_get
            instance.components.finiteuses.current = instance.components.finiteuses.current * num_to_get
            self.inst.components.finiteuses:SplitUses(instance.components.finiteuses.total)
        end
        if instance.components.perishable ~= nil then
            instance.components.perishable.perishremainingtime = self.inst.components.perishable.perishremainingtime
        end
        if instance.components.curseditem ~= nil and self.inst.components.curseditem ~= nil then
            self.inst.components.curseditem:CopyCursedFields(instance.components.curseditem)
            if self.inst:HasTag("applied_curse") then
                instance.skipspeech = true
                instance:AddTag("applied_curse")
            end
        end
        if instance.components.rechargeable ~= nil and self.inst.components.rechargeable ~= nil then
            if not self.inst.components.rechargeable:IsCharged() then
                instance.components.rechargeable:SetChargeTime(self.inst.components.rechargeable:GetChargeTime())
                instance.components.rechargeable:SetCharge(self.inst.components.rechargeable:GetCharge())
            end
        end
        if instance.components.inventoryitem ~= nil and self.inst.components.inventoryitem ~= nil then
            if self.inst.components.inventoryitem.owner then
                instance.components.inventoryitem:OnPutInInventory(self.inst.components.inventoryitem.owner)
            end
            instance.components.inventoryitem:InheritMoisture(self.inst.components.inventoryitem:GetMoisture(), self.inst.components.inventoryitem:IsWet())
        end
        return instance
    end
    return self.inst
end

-- Update stackable_replica component to allow stacking up to 65536
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

-- Update itemtile widget to show full stack previews instead of 999+
local Text = require "widgets/text"
local itemtile = GLOBAL.require("widgets/itemtile")
itemtile.SetQuantity = function(self, quantity)
    if self.onquantitychangedfn ~= nil and self:onquantitychangedfn(quantity) then
        if self.quantity ~= nil then
            self.quantity = self.quantity:Kill()
        end
        return
    elseif not self.quantity then
        self.quantity = self:AddChild(Text("stint-ucr", 42))
    end
    if quantity > 999 then
        self.quantity:SetSize(36)
        self.quantity:SetPosition(3.5, 16, 0)
        self.quantity:SetString(tostring(quantity))
    else
        self.quantity:SetSize(42)
        self.quantity:SetPosition(2, 16, 0)
        self.quantity:SetString(tostring(quantity))
    end
end
