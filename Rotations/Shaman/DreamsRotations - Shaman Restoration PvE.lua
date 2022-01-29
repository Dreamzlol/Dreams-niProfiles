--------------------------------
-- DreamsRotations - Shaman Restoration PvE
-- Version - 1.0.0
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Shaman Restoration PvE.json",
    {
        type = "title",
        text = "|cff00ccffDreamsRotations |cffffffff- Shaman Restoration PvE - |cff888888v1.0.0",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff00ccffMain Settings",
    },
    {
        type = "separator",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(57960)) .. ":26:26\124t Water Shield",
        tooltip = "Cast Water Shield",
        enabled = true,
        key = "watershield",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(51994)) .. ":26:26\124t Earthliving Weapon",
        tooltip = "Cast Earthliving Weapon",
        enabled = true,
        key = "earthlivingweapon",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(16190)) .. ":26:26\124t Mana Tide Totem if you are MP% or less",
        tooltip = "Cast Mana Tide Totem if you at or below mana percentage",
        enabled = true,
        value = 20,
        key = "manatidetotem",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(51886)) .. ":26:26\124t Cleanse Spirit if you or ally has a Debuff and are HP% or more",
        tooltip = "Cast Cleanse Spirit if you or ally has Poison, Disease or Curse Debuff and are at or more than health percentage",
        enabled = true,
        value = 60,
        key = "cleansespirit",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff00ccffRotation Settings",
    },
    {
        type = "separator",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(49284)) .. ":26:26\124t Earth Shield on focus",
        tooltip = "Cast Earth Shield on focus, remember too have the main tank as focus target",
        enabled = true,
        key = "earthshield",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(49276)) .. ":26:26\124t Lesser Healing Wave if you or ally are HP% or less",
        tooltip = "Cast Lesser Healing Wave if you or ally is at or below health percentage",
        enabled = true,
        value = 90,
        key = "lesserhealingwave",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(49273)) .. ":26:26\124t Healing Wave if you or ally are HP% or less",
        tooltip = "Cast Healing Wave if you or ally is at or below health percentage",
        enabled = true,
        value = 70,
        key = "healingwave",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(61301)) .. ":26:26\124t Riptide if you or ally are HP% or less",
        tooltip = "Cast Riptide if you or ally is at or below health percentage",
        enabled = true,
        value = 90,
        key = "riptide",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(55459)) .. ":26:26\124t Chain Heal if 3 or more allys are HP% or less",
        tooltip = "Cast Chain Heal if 3 or more allys are at or below health percentage",
        enabled = true,
        value = 80,
        key = "chainheal",
    },
}

local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
        and v.key ~= nil
        and v.key == name then
            return v.value, v.enabled
        end
    end
end

local function onload()
    ni.GUI.AddFrame("DreamsRotations - Shaman Restoration PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Shaman Restoration PvE");
end

local spell = {
    healingwave = GetSpellInfo(49273),
    lesserhealingwave = GetSpellInfo(49276),
    chainheal = GetSpellInfo(55459),
    earthshield = GetSpellInfo(49284),
    manatidetotem = GetSpellInfo(16190),
    riptide = GetSpellInfo(61301),
    watershield = GetSpellInfo(57960),
    naturesswiftness = GetSpellInfo(16188),
    tidalforce = GetSpellInfo(55198),
    cleansespirit = GetSpellInfo(51886),
    earthlivingweapon = GetSpellInfo(51994),
}

local item = {
    food = GetSpellInfo(45548),
    drink = GetSpellInfo(57073),
}

local queue = {
    "Earth Shield",
    "Water Shield",
    "Earthliving Weapon",
    "Cleanse Spirit",
    "Pause Rotation",
    "Mana Tide Totem",
    "Riptide",
    "Chain Heal",
    "Healing Wave",
    "Lesser Healing Wave",
}

local abilities = {
    ["Pause Rotation"] = function()
        if IsMounted()
        or UnitIsDeadOrGhost("player")
        or UnitIsDeadOrGhost("target")
        or UnitUsingVehicle("player")
        or UnitInVehicle("player")
        or not UnitAffectingCombat("player")
        or ni.unit.ischanneling("player")
        or ni.unit.iscasting("player")
        or ni.unit.buff("player", item.food)
        or ni.unit.buff("player", item.drink) then
            return true;
        end
    end,

    ["Water Shield"] = function()
        local _, enabled = GetSetting("watershield")
        if enabled then
            if ni.spell.available(spell.watershield)
            and not ni.unit.buff("player", spell.watershield) then
                ni.spell.cast(spell.watershield)
                return true;
            end
        end
    end,

    ["Earthliving Weapon"] = function()
        local _, enabled = GetSetting("earthlivingweapon")
        if enabled then
            local mainhand,_,_,_,_,_ = GetWeaponEnchantInfo()

            if not mainhand
            and ni.spell.available(spell.earthlivingweapon) then
                ni.spell.cast(spell.earthlivingweapon)
                return true;
            end
        end
    end,

    ["Cleanse Spirit"] = function()
        local value, enabled = GetSetting("cleansespirit")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].dispel
                and ni.members[i].hp > value
                and ni.spell.available(spell.cleansespirit)
                and ni.spell.valid(ni.members[i].unit, spell.cleansespirit, false, true, true) then
                    ni.spell.cast(spell.cleansespirit, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Lesser Healing Wave"] = function()
        local value, enabled = GetSetting("lesserhealingwave")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(spell.lesserhealingwave)
                and ni.spell.valid(ni.members[i].unit, spell.lesserhealingwave, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.lesserhealingwave, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Healing Wave"] = function()
        local value, enabled = GetSetting("healingwave")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(spell.healingwave)
                and ni.spell.valid(ni.members[i].unit, spell.healingwave, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.healingwave, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Chain Heal"] = function()
        local value, enabled = GetSetting("chainheal")
        if enabled then
            local count = ni.members.below(value);
            for i = 1, #ni.members do
                if count >= 3
                and ni.spell.available(spell.chainheal)
                and ni.spell.valid(ni.members[i].unit, spell.chainheal, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.chainheal, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Earth Shield"] = function()
        local _, enabled = GetSetting("earthshield")
        if enabled then
            if ni.spell.available(spell.earthshield)
            and ni.spell.valid("focus", spell.earthshield, false, true, true)
            and ni.unit.exists("focus")
            and not ni.unit.buff("focus", spell.earthshield, "player") then
                ni.spell.cast(spell.earthshield, "focus")
                return true;
            end
        end
    end,

    ["Mana Tide Totem"] = function()
        local value, enabled = GetSetting("manatidetotem")
        if enabled then
            if ni.spell.available(spell.manatidetotem)
            and ni.player.power() < value then
                ni.spell.cast(spell.manatidetotem)
                return true;
            end
        end
    end,

    ["Riptide"] = function()
        local value, enabled = GetSetting("riptide")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(spell.riptide)
                and ni.spell.valid(ni.members[i].unit, spell.riptide, false, true, true) then
                    ni.spell.cast(spell.riptide, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Shaman Restoration PvE", queue, abilities, onload, onunload)
