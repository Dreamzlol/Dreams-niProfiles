--------------------------------
-- DreamsRotations - Priest Discipline PvE
-- Version - 1.0.8
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
-- 1.0.1 Added Power Infusion
-- 1.0.2 Added dispelling diseases and magic debuffs
-- 1.0.3 Added GUI
-- 1.0.4 Improved overall rotation
-- 1.0.5 Added Racials
-- 1.0.6 Added Power Word: Shield Priority
-- 1.0.7 Added Tank priority
-- 1.0.8 Added Runic Mana Potion
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Priest Discipline PvE.json",
    {
        type = "title",
        text = "|cff00ccffDreamsRotations |cffffffff- Priest Discipline PvE - |cff888888v1.0.8",
        tooltip = "Note: IF YOU PAYED FOR THAT PROFILE YOU GOT SCAMMED, THEY FREE. Contact me at Discord: Dreams#5270 ",
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
        text = "\124T" .. select(3, GetSpellInfo(48168)) .. ":26:26\124t Inner Fire",
        tooltip = "Cast Inner Fire if not active",
        enabled = true,
        key = "innerfire",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(10060)) .. ":26:26\124t Power Infusion if you are MP% or less",
        tooltip = "Cast Power Infusion on yourself if you at or below mana percentage",
        enabled = true,
        value = 90,
        key = "powerinfusion",
    },
    {
        type = "entry",
        text = "\124T" .. GetItemIcon(33448) .. ":26:26\124t Runic Mana Potion if you are MP% or less",
        tooltip = "Use Runic Mana Potion if you at or below mana percentage",
        enabled = true,
        value = 20,
        key = "runicmanapotion",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(34433)) .. ":26:26\124t Shadowfiend if you are %MP or less",
        tooltip = "Cast Shadowfiend on target if you at or below mana percentage",
        enabled = true,
        value = 20,
        key = "shadowfiend",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(528)) .. ":26:26\124t Cure Disease if you or ally has a disease debuff and are HP% or more",
        tooltip = "Cast Cure Disease if you or ally has a disease debuff and have more health percentage",
        enabled = true,
        value = 80,
        key = "curedisease",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(988)) .. ":26:26\124t Dispell Magic if you or ally has a magic debuff and are HP% or more",
        tooltip = "Cast Dispell Magic if you or ally has a magic debuff and have more health percentage",
        enabled = true,
        value = 80,
        key = "dispellmagic",
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
        text = "\124T" .. select(3, GetSpellInfo(48072)) .. ":26:26\124t Prayer of Healing if more than 3 allys are HP% or less",
        tooltip = "Cast Prayer of Healing if more than 3 allys are at or below health percentage",
        enabled = true,
        value = 60,
        key = "prayerofhealing",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(53007)) .. ":26:26\124t Penance if you or ally are HP% or less",
        tooltip = "Cast Penance if you or ally are at or below health percentage",
        enabled = true,
        value = 80,
        key = "penance",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(33206)) .. ":26:26\124t Pain Suppression if you or ally are HP% or less",
        tooltip = "Cast Pain Suppression if you or ally is at or below health percentage",
        enabled = true,
        value = 20,
        key = "painsuppression",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48071)) .. ":26:26\124t Flash Heal if you or ally are HP% or less",
        tooltip = "Cast Flash Heal if you or ally are at or below health percentage. If you raid at 25man i recommend too disable Flash Heal, because you dont use Flash Heal in 25man you rather want too shield the entire raid",
        enabled = true,
        value = 80,
        key = "flashheal",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48066)) .. ":26:26\124t Power Word: Shield if you or ally are HP% or less (Low HP)",
        tooltip = "Cast Power Word: Shield if you or ally are at or below health percentage",
        enabled = true,
        value = 60,
        key = "powerwordshieldlowhp",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48066)) .. ":26:26\124t Power Word: Shield (All)",
        tooltip = "Cast Power Word: Shield on all allys in raid",
        enabled = true,
        key = "powerwordshieldall",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff00ccffTank Settings",
    },
    {
        type = "separator",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48068)) .. ":26:26\124t Renew",
        tooltip = "Cast Renew and keeps it active on tank",
        enabled = true,
        key = "renewtank",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48113)) .. ":26:26\124t Prayer of Mending",
        tooltip = "Cast Prayer of Mending and keeps it active on tank",
        enabled = true,
        key = "prayerofmendingtank",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(33206)) .. ":26:26\124t Pain Suppression if Tank is HP% or less (High Priority)",
        tooltip = "Cast Pain Suppression if Tank is at or below health percentage",
        enabled = true,
        value = 40,
        key = "painsuppressiontank",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48071)) .. ":26:26\124t Flash Heal if Tank is HP% or less (High Priority)",
        tooltip = "Cast Flash Heal if Tank is at or below health percentage",
        enabled = true,
        value = 80,
        key = "flashhealtank",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(53007)) .. ":26:26\124t Penance if Tank is HP% or less (High Priority)",
        tooltip = "Cast Penance if Tank is at or below health percentage",
        enabled = true,
        value = 80,
        key = "penancetank",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(48066)) .. ":26:26\124t Power Word: Shield if Tank is HP% or less (High Priority)",
        tooltip = "Cast Power Word: Shield if Tank is at or below health percentage",
        enabled = true,
        value = 80,
        key = "powerwordshieldtank",
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

local spell = {
    innerfire = GetSpellInfo(48168),
    painsuppression = GetSpellInfo(33206),
    powerinfusion = GetSpellInfo(10060),
    shadowfiend = GetSpellInfo(34433),
    curedisease = GetSpellInfo(528),
    dispelmagic = GetSpellInfo(988),
    renew = GetSpellInfo(48068),
    prayerofmending = GetSpellInfo(48113),
    prayerofhealing = GetSpellInfo(48072),
    penance = GetSpellInfo(53007),
    flashheal = GetSpellInfo(48071),
    powerwordshield = GetSpellInfo(48066),
    weakenedsoul = GetSpellInfo(6788),
}

local item = {
    food = GetSpellInfo(45548),
    drink = GetSpellInfo(57073),
    runicmanapotion = GetItemInfo(33448),
}

local queue = {
    "Inner Fire",
    "Pause Rotation",
    "Power Infusion",
    "Runic Mana Potion",
    "Shadowfiend",
    "Pain Suppression (Tank)",
    "Pain Suppression",
    "Power Word: Shield (Tank)",
    "Power Word: Shield (Low HP)",
    "Penance (Tank)",
    "Penance",
    "Flash Heal (Tank)",
    "Flash Heal",
    "Prayer of Mending (Tank)",
    "Prayer of Healing",
    "Renew (Tank)",
    "Disease",
    "Dispel Magic",
    "Power Word: Shield (All)",
}

local abilities = {
    ["Inner Fire"] = function()
        local _, enabled = GetSetting("innerfire")
        if enabled then
            if ni.spell.available(spell.innerfire)
            and not ni.unit.buff("player", spell.innerfire) then
                ni.spell.cast(spell.innerfire)
                return true;
            end
        end
    end,

    ["Pause Rotation"] = function()
        if IsMounted()
        or UnitIsDeadOrGhost("player")
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

    ["Pain Suppression"] = function()
        local value, enabled = GetSetting("painsuppression")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(spell.painsuppression)
                and ni.spell.valid(ni.members[i].unit, spell.painsuppression, false, true, true) then
                    ni.spell.cast(spell.painsuppression, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Power Infusion"] = function()
        local value, enabled = GetSetting("powerinfusion")
        if enabled then
            if ni.spell.available(spell.powerinfusion)
            and not ni.unit.buff("player", spell.powerinfusion)
            and ni.player.power() < value then
                ni.spell.cast(spell.powerinfusion, "player")
                return true;
            end
        end
    end,

    ["Shadowfiend"] = function()
        local value, enabled = GetSetting("shadowfiend")
        if enabled then
            if ni.spell.available(spell.shadowfiend)
            and ni.spell.valid("target", spell.shadowfiend, true, true)
            and ni.unit.exists("target")
            and ni.player.power() < value then
                ni.spell.cast(spell.shadowfiend, "target")
                return true;
            end
        end
    end,

    ["Runic Mana Potion"] = function()
        local value, enabled = GetSetting("runicmanapotion")
        if enabled then
            if ni.player.itemcd(item.runicmanapotion) == 0
            and ni.player.power() < value
            and ni.player.hasitem(item.runicmanapotion) then
                ni.player.useitem(item.runicmanapotion)
                return true;
            end
        end
    end,

    ["Disease"] = function()
        local value, enabled = GetSetting("curedisease")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i]:debufftype("Disease")
                and ni.members[i].hp > value
                and ni.spell.available(spell.curedisease)
                and ni.spell.valid(ni.members[i].unit, spell.curedisease, false, true, true) then
                    ni.spell.cast(spell.curedisease, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Dispel Magic"] = function()
        local value, enabled = GetSetting("dispellmagic")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i]:debufftype("Magic")
                and ni.members[i].hp > value
                and ni.spell.available(spell.dispelmagic)
                and ni.spell.valid(ni.members[i].unit, spell.dispelmagic, false, true, true) then
                    ni.spell.cast(spell.dispelmagic, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Power Word: Shield (Tank)"] = function()
        local value, enabled = GetSetting("powerwordshieldtank")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and ni.members[i].hp < value
                and not ni.unit.debuff(ni.members[i].unit, spell.weakenedsoul, "player")
                and not ni.unit.buff(ni.members[i].unit, spell.powerwordshield, "player")
                and ni.spell.available(spell.powerwordshield)
                and ni.spell.valid(ni.members[i].unit, spell.powerwordshield, false, true, true) then
                    ni.spell.cast(spell.powerwordshield, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Penance (Tank)"] = function()
        local value, enabled = GetSetting("penancetank")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and ni.members[i].hp < value
                and ni.spell.available(spell.penance)
                and ni.spell.valid(ni.members[i].unit, spell.penance, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.penance, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Pain Suppression (Tank)"] = function()
        local value, enabled = GetSetting("painsuppressiontank")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and ni.members[i].hp < value
                and ni.spell.available(spell.painsuppression)
                and ni.spell.valid(ni.members[i].unit, spell.painsuppression, false, true, true) then
                    ni.spell.cast(spell.painsuppression, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Renew (Tank)"] = function()
        local _, enabled = GetSetting("renewtank")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and not ni.members[i]:buff(spell.renew, "player")
                and ni.spell.available(spell.renew)
                and ni.spell.valid(ni.members[i].unit, spell.renew, false, true, true) then
                    ni.spell.cast(spell.renew, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Prayer of Mending (Tank)"] = function()
        local _, enabled = GetSetting("prayerofmendingtank")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and not ni.unit.buff(ni.members[i].unit, spell.prayerofmending, "player")
                and ni.spell.available(spell.prayerofmending)
                and ni.spell.valid(ni.members[i].unit, spell.prayerofmending, false, true, true) then
                    ni.spell.cast(spell.prayerofmending, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Prayer of Healing"] = function()
        local value, enabled = GetSetting("prayerofhealing")
        if enabled then
            local count = ni.members.below(value);
            for i = 1, #ni.members do
                if count >= 3
                and ni.spell.available(spell.prayerofhealing)
                and ni.spell.valid(ni.members[i].unit, spell.prayerofhealing, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.prayerofhealing, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Penance"] = function()
        local value, enabled = GetSetting("penance")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(spell.penance)
                and ni.spell.valid(ni.members[i].unit, spell.penance, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.penance, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Flash Heal"] = function()
        local value, enabled = GetSetting("flashheal")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and ni.spell.available(spell.flashheal)
                and ni.spell.valid(ni.members[i].unit, spell.flashheal, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.flashheal, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Flash Heal (Tank)"] = function()
        local value, enabled = GetSetting("flashhealtank")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].istank
                and ni.members[i].hp < value
                and ni.spell.available(spell.flashheal)
                and ni.spell.valid(ni.members[i].unit, spell.flashheal, false, true, true)
                and not ni.unit.ismoving("player") then
                    ni.spell.cast(spell.flashheal, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Power Word: Shield (Low HP)"] = function()
        local value, enabled = GetSetting("powerwordshieldlowhp")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp < value
                and not ni.unit.debuff(ni.members[i].unit, spell.weakenedsoul, "player")
                and not ni.unit.buff(ni.members[i].unit, spell.powerwordshield, "player")
                and ni.spell.available(spell.powerwordshield)
                and ni.spell.valid(ni.members[i].unit, spell.powerwordshield, false, true, true) then
                    ni.spell.cast(spell.powerwordshield, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,

    ["Power Word: Shield (All)"] = function()
        local _, enabled = GetSetting("powerwordshieldall")
        if enabled then
            for i = 1, #ni.members do
                if ni.members[i].hp <= 100
                and not ni.unit.debuff(ni.members[i].unit, spell.weakenedsoul, "player")
                and not ni.unit.buff(ni.members[i].unit, spell.powerwordshield, "player")
                and ni.spell.available(spell.powerwordshield)
                and ni.spell.valid(ni.members[i].unit, spell.powerwordshield, false, true, true) then
                    ni.spell.cast(spell.powerwordshield, ni.members[i].unit)
                    return true;
                end
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Priest Discipline PvE", queue, abilities, onload, onunload)