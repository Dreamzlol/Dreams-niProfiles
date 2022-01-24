--------------------------------
-- DreamsRotation Priest - Discipline PvE
-- Version - 1.0.3
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Power Infusion
-- 1.0.2 Added dispelling diseases and magic debuffs
-- 1.0.3 Added GUI
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Priest Discipline PvE.json",
    {
        type = "title",
        text = "|cffff00ffDreamsRotations |cffffffff- Priest Discipline PvE",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff71C671Rotation Settings",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48168)) .. ":26:26\124t Use Inner Fire",
        tooltip = "Use Inner Fire",
        enabled = true,
        key = "getSetting_InnerFire",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(33206)) .. ":26:26\124t Use Pain Suppression if below Health %",
        tooltip = "Use Pain Suppression if raid member is below health percentage",
        enabled = true,
        value = 20,
        key = "getSetting_PainSuppression",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(10060)) .. ":26:26\124t Use Power Infusion if below Mana %",
        tooltip = "Use Power Infusion on yourself if you below mana percentage",
        enabled = true,
        value = 90,
        key = "getSetting_PowerInfusion",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(34433)) .. ":26:26\124t Use Shadowfiend if below Mana %",
        tooltip = "Use Shadowfiend on target if you below Mana Percentage",
        enabled = true,
        value = 40,
        key = "getSetting_Shadowfiend",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(528)) .. ":26:26\124t Use Cure Disease on disease debuffs",
        tooltip = "Use Cure Disease if raid member has a disease",
        enabled = true,
        key = "getSetting_CureDisease",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(988)) .. ":26:26\124t Use Dispell Magic on magic debuffs",
        tooltip = "Use Dispell Magic if raid member has a magic debuff",
        enabled = true,
        key = "getSetting_DispellMagic",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48068)) .. ":26:26\124t Use Renew",
        tooltip = "Uses Renew and keeps it active on tanks",
        enabled = true,
        key = "getSetting_Renew",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48113)) .. ":26:26\124t Use Prayer of Mending",
        tooltip = "Uses Prayer of Mending on tanks",
        enabled = true,
        key = "getSetting_PrayerOfMending",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48072)) .. ":26:26\124t Use Prayer of Healing if below Health %",
        tooltip = "Uses Prayer of Healing if more than 4 raid member are below health percentage",
        enabled = true,
        value = 60,
        key = "getSetting_PrayerOfHealing",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(53007)) .. ":26:26\124t Use Penance if below Health %",
        tooltip = "Use Penance if raid member is below health percentage",
        enabled = true,
        value = 80,
        key = "getSetting_Penance",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48071)) .. ":26:26\124t Use Flash Heal if below Health %",
        tooltip = "Use Flash Heal if raid member is below health percentage",
        enabled = true,
        value = 80,
        key = "getSetting_FlashHeal",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48066)) .. ":26:26\124t Use Power Word: Shield",
        tooltip = "Use Power Word: Shield on all raid members if they have more than health percentage",
        enabled = true,
        value = 60,
        key = "getSetting_PowerWordShield",
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
    ni.GUI.AddFrame("DreamsRotations - Priest Discipline PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Priest Discipline PvE");
end

local queue = {
    "Inner Fire",
    "Pause Rotation",
    "Pain Suppression",
    "Power Infusion",
    "Shadowfiend",
    "Disease",
    "Dispel Magic",
    "Renew",
    "Prayer of Mending",
    "Prayer of Healing",
    "Penance",
    "Flash Heal",
    "Power Word: Shield",
}

local abilities = {
    ["Inner Fire"] = function()
        local _, enabled = GetSetting("getSetting_InnerFire")
        if enabled then
            if ni.spell.available("Inner Fire")
            and not ni.unit.buff("player", "Inner Fire") then
                ni.spell.cast("Inner Fire")
            end
        end
    end,

    ["Pause Rotation"] = function()
        if IsMounted()
        or not UnitAffectingCombat("player")
        or UnitIsDeadOrGhost("player") then
            return true;
        end
    end,

    ["Pain Suppression"] = function()
        local value, enabled = GetSetting("getSetting_PainSuppression")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.members[i].range 
                and ni.spell.available("Pain Suppression") then
                    ni.spell.cast("Pain Suppression", ni.members[i].unit)
                end
            end
        end
    end,

    ["Power Infusion"] = function()
        local value, enabled = GetSetting("getSetting_PowerInfusion")
        if enabled then
            if ni.spell.available("Power Infusion")
            and not ni.unit.buff("player", "Power Infusion")
            and ni.player.power() < value then
                ni.spell.cast("Power Infusion", "player")
            end
        end
    end,

    ["Shadowfiend"] = function()
        local value, enabled = GetSetting("getSetting_Shadowfiend")
        if enabled then
            if ni.spell.available("Shadowfiend")
            and ni.unit.exists("target")
            and ni.player.power() < value then
                ni.spell.cast("Shadowfiend", "target")
            end
        end
    end,

    ["Disease"] = function()
        local _, enabled = GetSetting("getSetting_CureDisease")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i]:debufftype("Disease")
                and ni.members[i].range
                and ni.members[i].hp > 40
                and ni.spell.available("Cure Disease") then
                    ni.spell.cast("Cure Disease", ni.members[i].unit)
                end
            end
        end
    end,

    ["Dispel Magic"] = function()
        local _, enabled = GetSetting("getSetting_DispellMagic")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i]:debufftype("Magic")
                and ni.members[i].range
                and ni.members[i].hp > 40
                and ni.spell.available("Dispel Magic") then
                    ni.spell.cast("Dispel Magic", ni.members[i].unit)
                end
            end
        end
    end,

    ["Renew"] = function()
        local _, enabled = GetSetting("getSetting_Renew")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and ni.members[i].range
                and not ni.members[i]:buff("Renew", "player")
                and ni.spell.available("Renew") then
                    ni.spell.cast("Renew", ni.members[i].unit)
                end
            end
        end
    end,

    ["Prayer of Mending"] = function()
        local _, enabled = GetSetting("getSetting_PrayerOfMending")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and ni.members[i].range
                and not ni.unit.buff(ni.members[i].unit, "Prayer of Mending", "player")
                and ni.spell.available("Prayer of Mending") then
                    ni.spell.cast("Prayer of Mending", ni.members[i].unit)
                end
            end
        end
    end,

    ["Prayer of Healing"] = function()
        local value, enabled = GetSetting("getSetting_PrayerOfHealing")
        if enabled then
            local count = ni.members.below(value);
            for i = 1, #ni.members do
                if ni.members[i].range and count > 4
                and ni.spell.available("Prayer of Healing") then
                    ni.spell.cast("Prayer of Healing", ni.members[i].unit)
                end
            end
        end
    end,

    ["Penance"] = function()
        local value, enabled = GetSetting("getSetting_Penance")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.members[i].range
                and ni.spell.available("Penance") then
                    ni.spell.cast("Penance", ni.members[i].unit)
                end
            end
        end
    end,

    ["Flash Heal"] = function()
        local value, enabled = GetSetting("getSetting_FlashHeal")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.members[i].range
                and ni.spell.available("Flash Heal") then
                    ni.spell.cast("Flash Heal", ni.members[i].unit)
                end
            end
        end
    end,

    ["Power Word: Shield"] = function()
        local value, enabled = GetSetting("getSetting_PowerWordShield")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp > value and ni.members[i].range
                and not ni.unit.debuff(ni.members[i].unit, "Weakened Soul", "player")
                and not ni.unit.buff(ni.members[i].unit, "Power Word: Shield", "player")
                and ni.spell.available("Power Word: Shield") then
                    ni.spell.cast("Power Word: Shield", ni.members[i].unit)
                end
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Priest Discipline PvE", queue, abilities, onload, onunload)
