-- AideClasse : version anglaise de Data\Conseils.lua (écrite à la main, PAS remplacée par la mise à jour).
-- Même ordre et mêmes catégories que le fichier français : si tu modifies un conseil là-bas, modifie-le ici aussi.
-- Les titres « ## Levels A to B » sont mis en avant quand le personnage est dans cette tranche.
-- Pas de guillemets doubles dans les textes.
local _, ns = ...

ns.conseilsEN = ns.conseilsEN or {}

ns.conseilsEN.WARRIOR = {
    "## General tips",
    "The hardest class to level: your worst enemy is the downtime spent eating.",
    "Grouping with a healer changes everything: you can chain pulls without stopping.",
    "Protection is the best leveling spec until level 35-40, even if you are aiming for Arms or Fury.",
    "Upgrade your weapon as soon as you can: no class benefits more from a new weapon.",
    "Kill everything in your path, and already move toward the next target during the fight.",
    "In trouble: Piercing Howl or Intimidating Shout to escape. Dying makes you lose your buffs.",

    "## Levels 1 to 10",
    "Learn Rend (lvl 4) and keep it up on every target.",
    "If your starting zone gives no decent weapon, buy a Cutlass from a vendor.",
    "Rough Sharpening Stone on your weapon: a big damage boost early on.",

    "## Levels 10 to 20",
    "Overpower at level 12: a must-learn.",
    "Level 16: Shield Mastery and Revenge, the Warrior gets much stronger.",
    "Run Ragefire Chasm with all its quests: the Axe of Orgrimmar is now a blue item.",

    "## Levels 20 to 30",
    "Victory Rush (lvl 20): a heal to use as soon as you drop below 90% health.",
    "Cleave (lvl 20) for packs of mobs.",

    "## Levels 30 to 40",
    "Intercept (lvl 30): a second charge, great for chaining targets.",
    "No need to save every coin for the level 40 mount: gold comes faster afterwards.",

    "## Levels 40 to 60",
    "Arms: Mortal Strike at level 40, the spec's biggest power spike.",
    "Recklessness at level 50.",
    "Weapons to aim for: Sword of the Victor (Razorfen Kraul), then Bludgeoning Blade (Maraudon quest).",

    "## Talents and spells to learn",
    "Arms: Improved Overpower, Bloodthrill, Improved Slam, Mortal Strike and Enrage are the big milestones.",
    "Arms: don't use Slam before you have Improved Slam.",
    "Fury: Gore Drinker and Bloodthirst first (your survival), then Flurry, then Deflection in Arms.",
    "Protection: Shield Specialization, Improved Revenge and Defense Mastery first.",
    "Spells to skip if gold is tight: Thunder Clap, Hamstring, Demoralizing Shout, Mocking Blow.",

    "## Professions, camp and consumables",
    "Professions: Blacksmithing + Mining. Blacksmithing has new leveling recipes; you can smelt ore from 1 to 300.",
    "Camp: Tent (rest), Lodestone (attack power), Grindstone (Strength), Chair (2% crit).",
    "Always eat food with a buff: +5% experience from killed mobs.",
    "Keep healing potions: they save you long runs back from the graveyard.",
    "Run each dungeon once with all its quests: the experience is in the quests.",
}

ns.conseilsEN.PALADIN = {
    "## General tips",
    "A very sturdy class: heavy armor and self-heals. It very rarely dies.",
    "Heal yourself instead of eating: restore your health with spells, then drink for mana.",
    "Keep Lay on Hands and Divine Shield for emergencies.",
    "No ranged attack and no interrupt: you walk up to every target.",
    "Holy: a group and dungeon spec, slow when solo.",

    "## Levels 1 to 10",
    "Seal of Righteousness from level 1, Holy Strike at level 6.",

    "## Levels 10 to 20",
    "Blessing of Wisdom (lvl 14): rank 1 is enough.",
    "First talents: Benediction (cheaper seals and judgements), then Pursuit of Justice.",

    "## Levels 20 to 30",
    "Consecration and Exorcism come at level 20.",
    "Pursuit of Justice 2/2 at level 21: you run faster.",
    "Retribution: Seal of Command as soon as possible, a big damage boost at the start of the fight.",

    "## Levels 30 to 40",
    "Retribution: Champion of the Light around level 35-37.",
    "Protection: you can respec at 30 for Holy Shield if you tank a lot.",

    "## Levels 40 to 60",
    "Your mount is free (Tome of Nobility): keep the gold for your spells or a good weapon.",
    "Hammer of Wrath (44) and Holy Wrath (50): skip them unless talented or for undead dungeons.",
    "Delay Unsealed Wrath: it costs mana for little damage.",

    "## Talents and spells to learn",
    "Retribution: Benediction, Pursuit of Justice, Seal of Command, then Sanctified Judgement (mana).",
    "Use a slow two-handed weapon with Seal of Command.",
    "Seal of Justice and Seal of Fury are useless for solo Retribution.",
    "Utility spells (Blessing of Protection, Purify...): rank 1 is enough.",

    "## Professions, camp and consumables",
    "Professions: Blacksmithing + Mining, the only source of plate with spell power early on.",
    "Also level First Aid (healing potions) and Cooking (food with an experience bonus).",
    "Camp buffs don't stack with your blessings: Lodestone = Might, Fishbowl = Kings.",
    "Always eat food with a buff: +5% experience from killed mobs.",
    "Keep mana potions: running out of mana is your only real weakness.",
    "Run each dungeon once with all its quests.",
}

ns.conseilsEN.HUNTER = {
    "## General tips",
    "Probably the easiest class to level: your pet tanks and you can kite.",
    "Your shots are not penalized against higher-level mobs.",
    "Beast Mastery is the best leveling spec.",
    "Restock arrows or bullets in every village.",
    "Keep food for your pet: if it dies, its happiness and damage drop.",
    "Feign Death gets you out of a fight gone wrong.",

    "## Levels 1 to 10",
    "Serpent Sting (lvl 4) and Arcane Shot (lvl 6).",
    "Aspect of the Hawk at level 10.",

    "## Levels 10 to 20",
    "Mend Pet (lvl 12): protect your pet, reviving it costs a lot of time.",
    "Learn Claw: tame a Clattering Crawler, a Shore Crawler, the Black Bear Patriarch or the Den Mother.",
    "Immolation Trap at level 16.",

    "## Levels 20 to 30",
    "Aspect of the Cheetah at level 20: you move much faster.",
    "Aimed Shot at level 20.",
    "Look for higher ranks of Claw and Bite every 10 levels or so.",

    "## Levels 30 to 40",
    "Trueshot Aura from level 30.",
    "Survival: don't play it before level 32 (Strider Kick and Expose Prey).",

    "## Levels 40 to 60",
    "Volley at level 40: AoE becomes much easier.",

    "## Talents and spells to learn",
    "Beast Mastery: fill the Beast Mastery tree top to bottom, then Marksmanship.",
    "No Lone Wolf while leveling: you need your pet.",
    "Marksmanship: Sniper Shot costs too much mana, wait for max level.",
    "Track Beasts and Track Humanoids, Aspect of the Monkey: useful but optional.",

    "## Professions, camp and consumables",
    "Professions: Skinning + Leatherworking. Leatherworking has very strong new blue items.",
    "Examples: Dark Leather Boots, Trapper's Belt.",
    "Keep cloth for First Aid and make bandages in town.",
    "Eat food with a buff: +5% experience, ideally with Agility or attack power.",
    "Keep healing potions of your level.",
}

ns.conseilsEN.ROGUE = {
    "## General tips",
    "Start every fight with a full energy bar: your damage is front-loaded.",
    "No healing: bandages and food are mandatory.",
    "Low energy: Gouge, back off, let your energy refill and go again.",
    "Stealth + Sap: pick up quest objects without fighting.",
    "Add Pick Pocket to your opener macro to earn gold along the way.",

    "## Levels 1 to 10",
    "Sinister Strike and Eviscerate from level 1. Backstab at level 4.",

    "## Levels 10 to 20",
    "First talents: Precision Strikes and Relentless Strikes (+40% crit after a kill).",
    "Subtlety: once you have Ambush (lvl 18), respec to strengthen your opener.",

    "## Levels 20 to 30",
    "Do the poisons quest (Klaven's Tower / Mission: Possible But Not Probable): it also gives Thistle Tea.",
    "Combat: at level 20, respec to take Riposte.",
    "Vanish at level 22: your emergency exit.",

    "## Levels 30 to 40",
    "Assassination: Mutilate at level 30, the spec finally gets interesting.",
    "Stealth quests: Horn of Xelthos (ring) and Eye of Bhossca (Ruby Encrusted Blade).",

    "## Levels 40 to 60",
    "Mount at level 40: plan the gold with a gathering profession or Pick Pocket.",

    "## Talents and spells to learn",
    "Combat: Riposte, then Relentless Strikes, Lightning Reflexes and Deflection.",
    "Assassination: until 30, same talents as Combat, then Mutilate and poison talents.",
    "Subtlety: Improved Ambush, then Master of Deception and Camouflage.",

    "## Poisons and dungeons",
    "Instant Poison for damage, Crippling Poison against runners.",
    "Mind-numbing Poison against casters.",
    "In dungeons: Sprint + Kick on casters in the back.",
    "Gouge and Kick to interrupt spells. Pick the chests' locks for the group.",

    "## Professions, camp and consumables",
    "Professions: two gathering professions for gold, or a crafting one for your gear.",
    "Agility consumables, sharpening stones and poisons on your weapons.",
    "Camp: Chair (crit), Grindstone (Strength), Lodestone (attack power).",
    "Always eat food with a buff: +5% experience from killed mobs.",
}

ns.conseilsEN.PRIEST = {
    "## General tips",
    "Shadow: the fastest solo. Discipline: almost unkillable, excellent in dungeons. Holy: for groups only.",
    "The wand is your best weapon until around level 40.",
    "Power Word: Shield before pulling: it absorbs hits and prevents spell pushback.",
    "Drink every 1 to 2 mobs. Carry 3 stacks of 20 drinks.",
    "No movement spell before the level 40 mount: plan your travel.",

    "## Levels 1 to 10",
    "Smite to start with, Lesser Heal between mobs.",
    "Shadow Word: Pain at level 4: cast it first.",
    "Apprentice wand from level 1, then Lesser Magic Wand at level 5.",

    "## Levels 10 to 20",
    "Wand Specialization 2/2 at level 10: the biggest damage gain.",
    "Inner Fire (lvl 12), Greater Magic Wand (lvl 13).",
    "Cure Disease (14) and Dispel Magic (18).",

    "## Levels 20 to 30",
    "Big trainer visit at level 20: Flash Heal, Holy Fire, Mind Flay, Devouring Plague.",
    "Discipline: Meditation around level 20, your mana regenerates even while casting.",

    "## Levels 30 to 40",
    "Level 30: Divine Spirit for everyone, Penance for Discipline.",
    "Shadow Word: Death at level 32: a good finisher.",

    "## Levels 40 to 60",
    "Shadow: Shadowform at level 40, the big milestone. Respec if you were leveling as Discipline.",
    "Discipline: around level 41, spells overtake the wand (Holy Fire, Penance, Smite).",
    "Holy: Greater Heal at level 40, Prayer of Healing around 40-45.",

    "## Talents and spells to learn",
    "Five-second rule: mana only regenerates after 5 s without casting, except with Meditation.",
    "Finishing with the wand does not reset that timer.",
    "Discipline: Wand Specialization, Meditation, Improved Inner Fire, Penance.",
    "Shadow: Smite and Holy Fire can be skipped.",
    "Visit your trainer especially at levels 20, 26 and 30.",

    "## Professions, camp and consumables",
    "Professions: Tailoring (cloth gear) + Enchanting (wands).",
    "Also level First Aid for healing potions.",
    "Gear: Spell power, Intellect, Spirit.",
    "Camp: Mana Well, Incense Candle (Intellect), Enchanted Lute, Tent.",
    "Eat food with a buff: +5% experience from killed mobs.",
}

ns.conseilsEN.SHAMAN = {
    "## General tips",
    "Enhancement is the most flexible leveling spec: damage, self-heals and totems.",
    "Restoration and ranged Elemental are slow when solo.",
    "Mana is your weak point: pull calmly.",
    "Your white hits do most of the damage: every extra spell means more time spent drinking.",
    "Use a weapon close to your level.",

    "## Levels 1 to 10",
    "Earth Shock and Strength of Earth Totem at level 4.",
    "Earthbind Totem (lvl 6) and Lightning Shield (lvl 8).",

    "## Levels 10 to 20",
    "Level 10: Flametongue Weapon (your best weapon imbue), Flame Shock, Searing Totem.",
    "Fire Nova at level 12, after the Call of Fire quest.",
    "Tremor Totem at level 18.",

    "## Levels 20 to 30",
    "Ghost Wolf at level 20: essential.",
    "Improved Ghost Wolf early: instant and usable indoors.",
    "Magma Totem at level 26.",
    "Elemental: Elemental Alacrity around level 28.",

    "## Levels 30 to 40",
    "Astral Recall at level 30: a second hearthstone (15 min).",
    "Spellhance: respec around 31 for Improved Stormstrike.",
    "Chain Lightning and Windfury Totem at level 32.",

    "## Levels 40 to 60",
    "Chain Heal at level 40, with Riptide for Restoration.",
    "Grace of Air Totem at level 42.",

    "## Talents and totems",
    "Spellhance (caster gear + Enhancement talents): the strongest variant.",
    "Spellhance: Restoration first (Awakened Spirit, Water Shield), then Enhancement.",
    "Use lower ranks if mana is short: the difference between ranks is small.",
    "Place buff totems where you will kill several mobs.",
    "Earthbind to escape, Stoneclaw to soak hits, Grounding against spells.",

    "## Professions, camp and consumables",
    "Professions: Skinning + Leatherworking (mail with spell power, mystic kits).",
    "Tailoring is not recommended.",
    "Wizard oils: they stack with your weapon imbues.",
    "Camp: Tent, Chair (crit), Incense Candle (Intellect), Fishbowl.",
    "Always eat food with a buff: +5% experience from killed mobs.",
}

ns.conseilsEN.MAGE = {
    "## General tips",
    "Frost: the safest spec to start with. Arcane: good mana management. Fire: long range.",
    "Craft or buy a wand early: it finishes mobs without mana and suffers no pushback.",
    "Conjure a good stock of food and water when you log in.",
    "Evocation as soon as your mana is low, and your racials on every cooldown.",
    "One mob too many? Frost Nova + Polymorph on one of them, or run.",
    "Mail your items to another character to keep your bags free.",

    "## Levels 1 to 10",
    "Until level 8: Frostbolt then wand.",
    "Put 2 points into Wand Specialization at level 10.",

    "## Levels 10 to 20",
    "Frostbolt to slow, then your damage spells.",
    "Frost Nova to get some distance back.",

    "## Levels 20 to 30",
    "Buy the Teleports from level 20 (the third city at 30).",
    "Arcane: Arcane Blast at 21, Arcane Missiles rank 3 at 24, Arcane Wrath at 26.",
    "Arcane: 2nd point in Precision around 27 to always hit.",

    "## Levels 30 to 40",
    "Level 34: switch from Ice Armor to Mage Armor to drink less often.",

    "## Levels 40 to 60",
    "Portals at level 40 (50 for the last cities): you can sell them to players.",
    "Arcane: aim for Arcane Power, the last talent of the tree.",

    "## Talents and spells to learn",
    "Arcane: Wand Specialization, Precision, Improved Arcane Missiles, then Missile Barrage.",
    "Arcane: Arcane Concentration and Arcane Meditation once you stop using the wand.",
    "Fire: Accelerant first, then Improved Fire Blast and Incinerate.",
    "Frost: drop Wand Specialization and Frostbite later for Ice Barrier.",

    "## Professions, camp and consumables",
    "Gear: Intellect and Spell power.",
    "Elixirs and wizard oils: cheap and very useful.",
    "Eat food with a buff: +5% experience, ideally with Spell power (Smoked Sagefish).",
    "Camp: Tent (the most important), Mana Well, Enchanted Lute.",
    "Keep mana and healing potions.",
}

ns.conseilsEN.WARLOCK = {
    "## General tips",
    "Always send your pet in before attacking, so the mobs target it.",
    "Use your wand rather than Drain Life, unless you need healing.",
    "Don't sit at full health and low mana: Life Tap, then Drain Life will heal you.",
    "Keep your demon alive: between pulls, a bandage or a resummon beats Health Funnel.",
    "Fear reaches 20 m: be careful the mob doesn't run into other packs.",
    "If it runs the wrong way: Curse of Recklessness brings it back.",

    "## Levels 1 to 10",
    "Sell your starting gear as soon as you log in: it pays for Immolate rank 1 (10 c), very strong early on.",
    "Pet: Imp at the very start.",
    "Wand as soon as possible: Lesser Magic Wand at level 5.",
    "Corruption (4), Life Tap (6), Curse of Agony and Fear (8).",

    "## Levels 10 to 20",
    "Voidwalker at level 10 to tank.",
    "Healthstone from level 10: always keep one.",
    "Greater Magic Wand at level 13.",

    "## Levels 20 to 30",
    "Succubus (Sayaad) at level 20: she deals the most damage.",
    "Demonology: weak until 25-27, then Demonic Brand makes your demon very strong.",

    "## Levels 30 to 40",
    "From level 30, switch to drain-tanking (Drain Life rank 3).",
    "Your demon or you hold the mob, and you heal yourself with drains.",
    "Hellfire at level 30: essential in dungeons.",
    "Spellstone at level 36 to enchant your weapon.",

    "## Levels 40 to 60",
    "Dual specialization at level 40 from your class trainer (10 g).",
    "Felsteed (mount) at level 40.",
    "Howl of Terror (40) for bad pulls, Death Coil (42) in emergencies.",
    "Demonology: Demonic Pact at level 40.",

    "## Soul shards and dungeons",
    "Shards: finish mobs with Drain Soul rank 1.",
    "Meeting stones no longer summon: keep shards for Ritual of Summoning.",
    "In dungeons, put a Soulstone on the healer.",
    "Curse of the Elements with casters, Curse of Recklessness with melee.",

    "## Professions, camp and consumables",
    "Recommended professions: Tailoring + Enchanting (you disenchant what you sew).",
    "Spell power elixirs and food with a buff (+5% experience).",
    "Keep mana potions for long fights and dungeons: Life Tap is enough the rest of the time.",
}

ns.conseilsEN.DRUID = {
    "## General tips",
    "Your strength is flexibility: damage, tanking and self-heals between pulls.",
    "No need to drink after every fight: mana regenerates while in form.",
    "Bash and Dash when a fight goes wrong, Prowl to sneak past.",
    "Never forget Thorns: it is a real part of your damage when you get hit.",
    "Solo Restoration is the slowest path: only switch near max level.",
    "Expect to tank in dungeons: get used to it early.",

    "## Levels 1 to 10",
    "Gear with Spell power: it matters a lot before forms.",

    "## Levels 10 to 20",
    "Bear Form at level 10 (class quest).",
    "Balance: take Improved Wrath first.",
    "Upgrade your weapon early: caster weapons give power from level 10.",
    "Cure Poison (14), Aquatic Form (16).",

    "## Levels 20 to 30",
    "Cat Form at level 20 (class quest).",
    "Take Feline Swiftness as soon as possible: it stays useful even with the mount.",
    "Omen of Clarity at level 20.",
    "Remove Curse (24), Abolish Poison (26).",

    "## Levels 30 to 40",
    "Travel Form at level 30.",
    "Balance: Insect Swarm and Nature's Splendor around 30, your DoTs last longer.",

    "## Levels 40 to 60",
    "Dire Bear Form, Primal Bite and Moonkin Form at level 40.",
    "Barkskin at level 44.",
    "Balance: Eclipse, Improved Starfire and Vengeance late in leveling.",

    "## Talents and spells to learn",
    "Feral: Feline Swiftness early, then the bear's rage and damage talents.",
    "Feral: finish in the Restoration tree to heal without running out of mana.",
    "Spells to skip: Abolish Poison, Cower, Soothe Animal, Starfire (as Feral).",
    "Entangling Roots: rank 1 is enough as Feral.",

    "## Professions, camp and consumables",
    "Professions: Skinning + Leatherworking (armor kits, new recipes).",
    "The camp Tent becomes very strong after level 30.",
    "Always eat food with a buff: +5% experience from killed mobs.",
    "All potions share the same cooldown: be careful with offensive potions.",
}
