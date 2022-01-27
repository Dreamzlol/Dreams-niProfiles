--------------------------------
-- DreamsRotation - Warrior Protection PvE
-- Version - 1.0.0
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Warrior Protection PvE.json",
    {
        type = "title",
        text = "|cffff00ffDreamsRotations |cffffffff- Warrior Protection PvE",
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
        text = "\124T" .. select(3, GetSpellInfo(2764)) .. ":26:26\124t Use Auto Target",
        tooltip = "Use the Auto Target feature if you in combat it will Auto Target the closest enemy around you",
        enabled = true,
        key = "autotarget",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(674)) .. ":26:26\124t Use Auto Attack",
        tooltip = "Use the Auto Attack feature it will automatically start auto attack",
        enabled = true,
        key = "autoattack",
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
        text = "\124T" .. select(3, GetSpellInfo(57823)) .. ":26:26\124t Use Revenge",
        tooltip = "Use Revenge on procc",
        enabled = true,
        key = "revenge",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(47488)) .. ":26:26\124t Use Shield Slam",
        tooltip = "Use Shield Slam",
        enabled = true,
        key = "shieldslam",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(46968)) .. ":26:26\124t Use Shockwave",
        tooltip = "Use Shockwave",
        enabled = true,
        key = "shockwave",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(47498)) .. ":26:26\124t Use Devastate",
        tooltip = "Use Devastate",
        enabled = true,
        key = "devastate",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(72)) .. ":26:26\124t Use Shield Bash",
        tooltip = "Use Shield Bash if target casting a spell",
        enabled = true,
        key = "shieldbash",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(57755)) .. ":26:26\124t Use Heroic Throw",
        tooltip = "Use Heroic Throw",
        enabled = true,
        key = "heroicthrow",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(47465)) .. ":26:26\124t Use Rend",
        tooltip = "Use Rend and keeps it active on target",
        enabled = true,
        key = "rend",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(12809)) .. ":26:26\124t Use Concussion Blow",
        tooltip = "Use Concussion Blow",
        enabled = true,
        key = "concussionblow",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(47520)) .. ":26:26\124t Use Cleave if enemies in range",
        tooltip = "Use Cleave if the defined enemies are around your target",
        enabled = true,
        value = 1,
        key = "cleave",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(47502)) .. ":26:26\124t Use Thunder Clap if enemies in range",
        tooltip = "Use Thunder Clap if the defined enemies are around your target",
        enabled = true,
        value = 1,
        key = "thunderclap",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(47450)) .. ":26:26\124t Use Heroic Strike if more than rage",
        tooltip = "Use Heroic Strike if you have more than the defined rage",
        enabled = true,
        value = 60,
        key = "heroicstrike",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(2565)) .. ":26:26\124t Use Shield Block if below Health %",
        tooltip = "Use Shield Block if below health percentage",
        enabled = true,
        value = 90,
        key = "shieldblock",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(871)) .. ":26:26\124t Use Shield Wall if below Health %",
        tooltip = "Use Shield Wall if below health percentage",
        enabled = true,
        value = 20,
        key = "shieldwall",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(12975)) .. ":26:26\124t Use Last Stand if below Health %",
        tooltip = "Use Last Stand if below health percentage",
        enabled = true,
        value = 40,
        key = "laststand",
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
    ni.GUI.AddFrame("DreamsRotations - Warrior Protection PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Warrior Protection PvE");
end

-- Spells
local AutoAttack = GetSpellInfo(6603)
local Revenge = GetSpellInfo(57823)
local ShieldSlam = GetSpellInfo(47488)
local ShieldBlock = GetSpellInfo(2565)
local ShieldBash = GetSpellInfo(72)
local Rend = GetSpellInfo(47465)
local Cleave = GetSpellInfo(47520)
local Devastate = GetSpellInfo(47498)
local HeroicStrike = GetSpellInfo(47450)
local HeroicThrow = GetSpellInfo(57755)
local ThunderClap = GetSpellInfo(47502)
local ShieldWall = GetSpellInfo(871)
local LastStand = GetSpellInfo(12975)
local Shockwave = GetSpellInfo(46968)
local ConcussionBlow = GetSpellInfo(12809)

-- Items
local Food = GetSpellInfo(45548)
local Drink = GetSpellInfo(57073)

local queue = {
    "Pause Rotation",
    "Auto Target",
    "Auto Attack",
    "Shield Wall",
    "Last Stand",
    "Shield Block",
    "Shield Bash",
    "Shockwave",
    "Thunder Clap",
    "Cleave",
    "Heroic Throw",
    "Shield Slam",
    "Rend",
    "Revenge",
    "Concussion Blow",
    "Heroic Strike",
    "Devastate",
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
        or ni.unit.buff("player", Food)
        or ni.unit.buff("player", Drink) then
            return true;
        end
    end,

    ["Auto Target"] = function()
        local _, enabled = GetSetting("autotarget")
        if enabled then
            if UnitAffectingCombat("player")
            and ((ni.unit.exists("target")
            and UnitIsDeadOrGhost("target")
            and not UnitCanAttack("player", "target"))
            or not ni.unit.exists("target")) then
                ni.player.runtext("/targetenemy")
                return true;
            end
        end
	end,

    ["Auto Attack"] = function()
        local _, enabled = GetSetting("autoattack")
        if enabled then
            if ni.unit.exists("target")
            and UnitCanAttack("player", "target")
            and not UnitIsDeadOrGhost("target")
            and UnitAffectingCombat("player")
            and not IsCurrentSpell(AutoAttack) then
                ni.spell.cast(AutoAttack)
                return true;
            end
        end
    end,

    ["Revenge"] = function()
        local _, enabled = GetSetting("revenge")
        if enabled then
            if ni.spell.available(Revenge)
            and IsUsableSpell("Revenge") then
                ni.spell.cast(Revenge, "target")
                return true;
            end
        end
    end,

    ["Shield Slam"] = function()
        local _, enabled = GetSetting("shieldslam")
        if enabled then
            if ni.spell.available(ShieldSlam)
            and ni.spell.valid("target", ShieldSlam, true, true) then
                ni.spell.cast(ShieldSlam, "target")
                return true;
            end
        end
    end,

    ["Shield Block"] = function()
        local value, enabled = GetSetting("shieldblock")
        if enabled then
            if ni.spell.available(ShieldBlock)
            and ni.unit.hp("player") < value then
                ni.spell.cast(ShieldBlock)
                return true;
            end
        end
    end,

    ["Shield Wall"] = function()
        local value, enabled = GetSetting("shieldwall")
        if enabled then
            if ni.spell.available(ShieldWall)
            and ni.unit.hp("player") < value then
                ni.spell.cast(ShieldWall)
                return true;
            end
        end
    end,

    ["Last Stand"] = function()
        local value, enabled = GetSetting("laststand")
        if enabled then
            if ni.spell.available(LastStand)
            and ni.unit.hp("player") < value then
                ni.spell.cast(LastStand)
                return true;
            end
        end
    end,

    ["Shield Bash"] = function()
        local _, enabled = GetSetting("shieldbash")
        if enabled then
            if ni.spell.available(ShieldBash)
            and ni.spell.valid("target", ShieldBash, true, true)
            and ni.unit.iscasting("target") then
                ni.spell.cast(ShieldBash, "target")
                return true;
            end
        end
    end,

    ["Rend"] = function()
        local _, enabled = GetSetting("rend")
        if enabled then
            if ni.spell.available(Rend)
            and ni.spell.valid("target", Rend, true, true)
            and ni.unit.debuffremaining("target", Rend, "player") <= 2 then
                ni.spell.cast(Rend, "target")
                return true;
            end
        end
    end,

    ["Cleave"] = function()
        local value, enabled = GetSetting("cleave")
        if enabled then
            if ni.spell.available(Cleave)
            and #ni.unit.enemiesinrange("target", 10) > value then
                ni.spell.cast(Cleave)
                return true;
            end
        end
    end,

    ["Devastate"] = function()
        local _, enabled = GetSetting("devastate")
        if enabled then
            if ni.spell.available(Devastate)
            and ni.spell.valid("target", Devastate, true, true)
            and ni.player.power() > 30 then
                ni.spell.cast(Devastate, "target")
                return true;
            end
        end
    end,

    ["Concussion Blow"] = function()
        local _, enabled = GetSetting("concussionblow")
        if enabled then
            if ni.spell.available(ConcussionBlow)
            and ni.spell.valid("target", ConcussionBlow, true, true) then
                ni.spell.cast(ConcussionBlow, "target")
                return true;
            end
        end
    end,

    ["Heroic Strike"] = function()
        local value, enabled = GetSetting("heroicstrike")
        if enabled then
            if ni.spell.available(HeroicStrike)
            and ni.player.power() > value
            and #ni.unit.enemiesinrange("target", 10) < 2 then
                ni.spell.cast(HeroicStrike)
                return true;
            end
        end
    end,

    ["Heroic Throw"] = function()
        local _, enabled = GetSetting("heroicthrow")
        if enabled then
            if ni.spell.available(HeroicThrow)
            and ni.spell.valid("target", HeroicThrow, true, true) then
                ni.spell.cast(HeroicThrow, "target")
                return true;
            end
        end
    end,

    ["Thunder Clap"] = function()
        local value, enabled = GetSetting("thunderclap")
        if enabled then
            if ni.spell.available(ThunderClap)
            and #ni.unit.enemiesinrange("target", 10) > value then
                ni.spell.cast(ThunderClap)
                return true;
            end
        end
    end,

    ["Shockwave"] = function()
        local _, enabled = GetSetting("shockwave")
        if enabled then
            if ni.spell.available(Shockwave) then
                ni.spell.cast(Shockwave)
                return true;
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Warrior Protection PvE", queue, abilities, onload, onunload)