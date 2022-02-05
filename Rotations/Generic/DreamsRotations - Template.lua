--------------------------------
-- DreamsRotations - Class Spec PvE
-- Version - 1.0.0
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Class Spec PvE.json",
    {
        type = "title",
        text = "|cff00ccffDreamsRotations |cffffffff- Class Spec PvE - |cff888888v1.0.0",
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
        text = "\124T" .. select(3, GetSpellInfo(49276)) .. ":26:26\124t Lesser Healing Wave if you or ally are HP% or less",
        tooltip = "Cast Lesser Healing Wave if you or ally is at or below health percentage",
        enabled = true,
        value = 90,
        key = "lesserhealingwave",
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
    ni.GUI.AddFrame("DreamsRotations - Class Spec PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Class Spec PvE");
end

local spell = {
    healingwave = GetSpellInfo(49273),
}

local item = {
    food = GetSpellInfo(45548),
    drink = GetSpellInfo(57073),
}

local queue = {
    "Water Shield",
    "Pause Rotation",
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
}
ni.bootstrap.profile("DreamsRotations - Class Spec PvE", queue, abilities, onload, onunload)
