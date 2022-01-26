--------------------------------
-- DreamsRotation Priest - Discipline PvE
-- Version - 1.0.4
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Power Infusion
-- 1.0.2 Added dispelling diseases and magic debuffs
-- 1.0.3 Added GUI
-- 1.0.4 Improved overall rotation
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
        text = "|cff71C671Main Settings",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48168)) .. ":26:26\124t Use Inner Fire",
        tooltip = "Use Inner Fire if not active",
        enabled = true,
        key = "innerfire",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(33206)) .. ":26:26\124t Use Pain Suppression if below Health %",
        tooltip = "Use Pain Suppression if raid member is below health percentage",
        enabled = true,
        value = 20,
        key = "painsuppression",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(10060)) .. ":26:26\124t Use Power Infusion if below Mana %",
        tooltip = "Use Power Infusion on yourself if you below mana percentage",
        enabled = true,
        value = 90,
        key = "powerinfusion",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(34433)) .. ":26:26\124t Use Shadowfiend if below Mana %",
        tooltip = "Use Shadowfiend on target if you below mana percentage",
        enabled = true,
        value = 40,
        key = "shadowfiend",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(528)) .. ":26:26\124t Use Cure Disease",
        tooltip = "Use Cure Disease if raid member has a disease",
        enabled = true,
        key = "curedisease",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(988)) .. ":26:26\124t Use Dispell Magic",
        tooltip = "Use Dispell Magic if raid member has a magic debuff",
        enabled = true,
        key = "dispellmagic",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff71C671Healing Spells Settings",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48068)) .. ":26:26\124t Use Renew",
        tooltip = "Use Renew and keeps it active on tanks",
        enabled = true,
        key = "renew",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48113)) .. ":26:26\124t Use Prayer of Mending",
        tooltip = "Use Prayer of Mending on tanks",
        enabled = true,
        key = "prayerofmending",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48072)) .. ":26:26\124t Use Prayer of Healing if below Health %",
        tooltip = "Use Prayer of Healing if more than 4 raid member are below health percentage",
        enabled = true,
        value = 60,
        key = "prayerofhealing",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(53007)) .. ":26:26\124t Use Penance if below Health %",
        tooltip = "Use Penance if raid member is below health percentage",
        enabled = true,
        value = 80,
        key = "penance",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48071)) .. ":26:26\124t Use Flash Heal if below Health %",
        tooltip = "Use Flash Heal if a raid member is below health percentage",
        enabled = true,
        value = 80,
        key = "flashheal",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48066)) .. ":26:26\124t Use Power Word: Shield",
        tooltip = "Use Power Word: Shield on all raid members if they have more than the defined health percentage",
        enabled = true,
        value = 60,
        key = "powerwordshield",
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

-- Spells
local InnerFire = GetSpellInfo(48168)
local PainSuppression = GetSpellInfo(33206)
local PowerInfusion = GetSpellInfo(10060)
local Shadowfiend = GetSpellInfo(34433)
local CureDisease = GetSpellInfo(528)
local DispelMagic = GetSpellInfo(988)
local Renew = GetSpellInfo(48068)
local PrayerOfMending = GetSpellInfo(48113)
local PrayerOfHealing = GetSpellInfo(48072)
local Penance = GetSpellInfo(53007)
local FlashHeal = GetSpellInfo(48071)
local PowerWordShield = GetSpellInfo(48066)
local WeakenedSoul = GetSpellInfo(6788)

-- Items
local Food = GetSpellInfo(45548)
local Drink = GetSpellInfo(57073)

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
        local _, enabled = GetSetting("innerfire")
        if enabled then
            if ni.spell.available(InnerFire)
            and not ni.unit.buff("player", InnerFire) then
                ni.spell.cast(InnerFire)
            end
        end
    end,

    ["Pause Rotation"] = function()
        if IsMounted()
        or UnitIsDeadOrGhost("player")
        or UnitIsDeadOrGhost("target")
        or UnitUsingVehicle("player")
        or UnitInVehicle("player")
        or not UnitAffectingCombat("player")
        or ni.unit.ischanneling("player")
        or ni.unit.iscasting("player")
        or ni.unit.buff("player", Food)
        or ni.unit.buff("player", Drink) then
            return true;
        end
    end,

    ["Pain Suppression"] = function()
        local value, enabled = GetSetting("painsuppression")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(PainSuppression)
                and ni.spell.valid(ni.members[i].unit, PainSuppression, false, true, true) then
                    ni.spell.cast(PainSuppression, ni.members[i].unit)
                end
            end
        end
    end,

    ["Power Infusion"] = function()
        local value, enabled = GetSetting("powerinfusion")
        if enabled then
            if ni.spell.available(PowerInfusion)
            and not ni.unit.buff("player", PowerInfusion)
            and ni.player.power() < value then
                ni.spell.cast(PowerInfusion, "player")
            end
        end
    end,

    ["Shadowfiend"] = function()
        local value, enabled = GetSetting("shadowfiend")
        if enabled then
            if ni.spell.available(Shadowfiend)
            and ni.spell.valid("target", Shadowfiend, true, true)
            and ni.unit.exists("target")
            and ni.player.power() < value then
                ni.spell.cast(Shadowfiend, "target")
            end
        end
    end,

    ["Disease"] = function()
        local _, enabled = GetSetting("curedisease")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i]:debufftype("Disease")
                and ni.members[i].hp > 40
                and ni.spell.available(CureDisease)
                and ni.spell.valid(ni.members[i].unit, CureDisease, false, true, true) then
                    ni.spell.cast(CureDisease, ni.members[i].unit)
                end
            end
        end
    end,

    ["Dispel Magic"] = function()
        local _, enabled = GetSetting("dispellmagic")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i]:debufftype("Magic")
                and ni.members[i].hp > 40
                and ni.spell.available(DispelMagic)
                and ni.spell.valid(ni.members[i].unit, DispelMagic, false, true, true) then
                    ni.spell.cast(DispelMagic, ni.members[i].unit)
                end
            end
        end
    end,

    ["Renew"] = function()
        local _, enabled = GetSetting("renew")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and not ni.members[i]:buff(Renew, "player")
                and ni.spell.available(Renew)
                and ni.spell.valid(ni.members[i].unit, Renew, false, true, true) then
                    ni.spell.cast(Renew, ni.members[i].unit)
                end
            end
        end
    end,

    ["Prayer of Mending"] = function()
        local _, enabled = GetSetting("prayerofmending")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and not ni.unit.buff(ni.members[i].unit, PrayerOfMending, "player")
                and ni.spell.available(PrayerOfMending)
                and ni.spell.valid(ni.members[i].unit, PrayerOfMending, false, true, true) then
                    ni.spell.cast(PrayerOfMending, ni.members[i].unit)
                end
            end
        end
    end,

    ["Prayer of Healing"] = function()
        local value, enabled = GetSetting("prayerofhealing")
        if enabled then
            local count = ni.members.below(value);
            for i = 1, #ni.members do
                if count > 4
                and ni.spell.available(PrayerOfHealing)
                and ni.spell.valid(ni.members[i].unit, PrayerOfHealing, false, true, true) then
                    ni.spell.cast(PrayerOfHealing, ni.members[i].unit)
                end
            end
        end
    end,

    ["Penance"] = function()
        local value, enabled = GetSetting("penance")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(Penance)
                and ni.spell.valid(ni.members[i].unit, Penance, false, true, true) then
                    ni.spell.cast(Penance, ni.members[i].unit)
                end
            end
        end
    end,

    ["Flash Heal"] = function()
        local value, enabled = GetSetting("flashheal")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(FlashHeal)
                and ni.spell.valid(ni.members[i].unit, FlashHeal, false, true, true) then
                    ni.spell.cast(FlashHeal, ni.members[i].unit)
                end
            end
        end
    end,

    ["Power Word: Shield"] = function()
        local value, enabled = GetSetting("powerwordshield")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp > value
                and not ni.unit.debuff(ni.members[i].unit, WeakenedSoul, "player")
                and not ni.unit.buff(ni.members[i].unit, PowerWordShield, "player")
                and ni.spell.available(PowerWordShield)
                and ni.spell.valid(ni.members[i].unit, PowerWordShield, false, true, true) then
                    ni.spell.cast(PowerWordShield, ni.members[i].unit)
                end
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Priest Discipline PvE", queue, abilities, onload, onunload)