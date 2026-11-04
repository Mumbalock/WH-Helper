-- Enchantements et consommables (écrit à la main, PAS remplacé par la mise à jour automatique).
-- Base : les classiques de WoW Classic. WoW Forever ajoute des recettes : vérifie sur Wowhead.
--
-- Une entrée : E(emplacement, sortOuNil, nom, note, icone) pour un enchantement (sort = infobulle + icône),
--              C(objet, nom, note) pour un consommable (objet = icône, nom traduit et infobulle).
-- Tranches de consommables : { niveauMin, niveauMax, C(...), ... }.
local _, ns = ...

local function E(e, s, n, t, ic) return { e = e, s = s, n = n, t = t, ic = ic } end
local function C(i, n, t) return { i = i, n = n, t = t } end

-- Potions communes à tous les profils, par tranche.
local SOINS = {
    [1] = C(118, "Potion de soins mineure"), [2] = C(858, "Potion de soins inférieure"),
    [3] = C(929, "Potion de soins"), [4] = C(1710, "Potion de soins supérieure"),
    [5] = C(3928, "Potion de soins excellente"), [6] = C(13446, "Potion de soins majeure"),
}
local MANA = {
    [1] = C(2455, "Potion de mana mineure"), [2] = C(3385, "Potion de mana inférieure"),
    [3] = C(3827, "Potion de mana"), [4] = C(6149, "Potion de mana supérieure"),
    [5] = C(13443, "Potion de mana excellente"), [6] = C(13444, "Potion de mana majeure"),
}
local BOTTES_MONTEE = E("Bottes", 13890, "Vitesse mineure", "le meilleur enchantement de montée : +8 % de vitesse")

ns.enchantsProfils = {
    force = {
        nom = "Mêlée (Force)",
        montee = {
            BOTTES_MONTEE,
            E("Arme", nil, "Frappe inférieure ou Frappe", "dégâts fixes, peu cher", "inv_sword_04"),
            E("Plastron", nil, "Caractéristiques inférieures", "toutes les stats", "inv_chest_plate06"),
            E("Bracelets", nil, "Force", "rang adapté à ton niveau", "inv_bracer_07"),
        },
        max = {
            E("Arme", 20034, "Croisé", "le meilleur pour la mêlée"),
            E("Arme 2M", 20030, "Impact excellent", "si le Croisé est trop cher"),
            E("Plastron", 20025, "Caractéristiques supérieures", "+4 à toutes les stats"),
            E("Bracelets", 20010, "Force excellente", "+9 Force"),
            E("Gants", 20013, "Force supérieure", "+7 Force"),
            E("Cape", 13882, "Agilité inférieure", "+3 Agilité"),
            E("Bottes", 20023, "Agilité supérieure", "+7 Agilité (ou Vitesse mineure)"),
            E("Tête / Jambes", nil, "Arcanum de rapidité", "quêtes des Librams (Hache-tripes)", "inv_misc_book_11"),
        },
        compos = {
            { 1, 20, SOINS[2], C(2862, "Pierre à aiguiser brute"), C(2863, "Pierre à aiguiser grossière"), C(3391, "Élixir de force de l'ogre") },
            { 20, 40, SOINS[3], SOINS[4], C(2871, "Pierre à aiguiser lourde"), C(7964, "Pierre à aiguiser solide"), C(3391, "Élixir de force de l'ogre") },
            { 40, 60, SOINS[5], C(12404, "Pierre à aiguiser dense"), C(9206, "Élixir de force de géant"), C(13452, "Élixir de la mangouste") },
            { 60, 60, SOINS[6], C(13510, "Flacon des Titans", "raid"), C(13452, "Élixir de la mangouste"), C(12451, "Juju puissance"),
                C(12820, "Eau-de-feu des Tombe-hiver"), C(18262, "Pierre à aiguiser élémentaire"), C(20452, "Boulettes du désert fumées") },
        },
    },
    agilite = {
        nom = "Mêlée et distance (Agilité)",
        montee = {
            BOTTES_MONTEE,
            E("Cape", 13882, "Agilité inférieure", "+3 Agilité, peu cher"),
            E("Plastron", nil, "Caractéristiques inférieures", "toutes les stats", "inv_chest_leather_01"),
            E("Arme", nil, "Frappe inférieure ou Frappe", "dégâts fixes, peu cher", "inv_sword_04"),
        },
        max = {
            E("Arme", 20034, "Croisé", "mêlée ; Agilité +15 en second choix"),
            E("Arme 1M", 23800, "Agilité", "+15 Agilité, chasseurs et voleurs"),
            E("Plastron", 20025, "Caractéristiques supérieures", "+4 à toutes les stats"),
            E("Bracelets", 20010, "Force excellente", "+9 Force (voleur, félin)"),
            E("Gants", 25080, "Agilité supérieure", "+7 Agilité"),
            E("Cape", 13882, "Agilité inférieure", "+3 Agilité"),
            E("Bottes", 20023, "Agilité supérieure", "+7 Agilité (ou Vitesse mineure)"),
            E("Tête / Jambes", nil, "Arcanum de rapidité", "quêtes des Librams (Hache-tripes)", "inv_misc_book_11"),
        },
        compos = {
            { 1, 20, SOINS[2], C(3390, "Élixir d'agilité inférieure"), C(2863, "Pierre à aiguiser grossière") },
            { 20, 40, SOINS[3], SOINS[4], C(8949, "Élixir d'agilité"), C(7964, "Pierre à aiguiser solide") },
            { 40, 60, SOINS[5], C(9187, "Élixir d'agilité supérieure"), C(13452, "Élixir de la mangouste"), C(12404, "Pierre à aiguiser dense") },
            { 60, 60, SOINS[6], C(13452, "Élixir de la mangouste"), C(12460, "Juju pouvoir"), C(12820, "Eau-de-feu des Tombe-hiver"),
                C(13928, "Calmar grillé", "+10 Agilité"), C(13510, "Flacon des Titans", "raid") },
        },
    },
    caster = {
        nom = "Lanceur de sorts",
        montee = {
            BOTTES_MONTEE,
            E("Plastron", nil, "Mana supérieure ou Caractéristiques", "plus de mana entre deux pauses", "inv_chest_cloth_21"),
            E("Bracelets", nil, "Intelligence", "rang adapté à ton niveau", "inv_bracer_07"),
            E("Arme", nil, "Huile de sorcier", "plutôt qu'un enchantement cher", "inv_potion_104"),
        },
        max = {
            E("Arme", 22749, "Puissance des sorts", "+30 dégâts des sorts"),
            E("Arme (budget)", 23804, "Intelligence considérable", "+22 Intelligence"),
            E("Plastron", 20025, "Caractéristiques supérieures", "+4 à toutes les stats"),
            E("Bracelets", 20008, "Intelligence supérieure", "+7 Intelligence"),
            E("Gants", 25078, "Puissance du feu", "+20 feu (mage feu, démoniste destruction)"),
            E("Gants", 25073, "Puissance de l'ombre", "+20 ombre (démoniste, prêtre ombre)"),
            E("Gants", 25074, "Puissance du givre", "+20 givre (mage givre)"),
            E("Bottes", 20020, "Endurance supérieure", "+7 Endurance (ou Vitesse mineure)"),
            E("Tête / Jambes", nil, "Arcanum de concentration", "+8 dégâts des sorts, quêtes des Librams", "inv_misc_book_11"),
        },
        compos = {
            { 1, 20, SOINS[2], MANA[2], C(20744, "Huile de sorcier mineure"), C(3383, "Élixir de sagesse") },
            { 20, 40, SOINS[3], MANA[3], MANA[4], C(20746, "Huile de sorcier inférieure"), C(6373, "Élixir de puissance de feu") },
            { 40, 60, SOINS[5], MANA[5], C(20750, "Huile de sorcier"), C(9155, "Élixir des arcanes"), C(9264, "Élixir de puissance de l'ombre") },
            { 60, 60, MANA[6], C(13512, "Flacon de puissance suprême", "raid"), C(13454, "Élixir des arcanes supérieur"),
                C(20749, "Huile de sorcier brillante"), C(18254, "Surprise de tubercule Tum") },
        },
    },
    soigneur = {
        nom = "Soigneur",
        montee = {
            BOTTES_MONTEE,
            E("Plastron", nil, "Mana supérieure ou Caractéristiques", "plus de mana", "inv_chest_cloth_21"),
            E("Bracelets", nil, "Intelligence ou Esprit", "rang adapté à ton niveau", "inv_bracer_07"),
            E("Arme", nil, "Huile de mana", "regain de mana en combat", "inv_potion_100"),
        },
        max = {
            E("Arme", 22750, "Puissance de guérison", "+55 soins"),
            E("Plastron", 20028, "Intelligence majeure", "ou Caractéristiques supérieures"),
            E("Bracelets", 23802, "Guérison", "+24 soins"),
            E("Gants", 25079, "Soins", "+30 soins"),
            E("Cape", 13882, "Agilité inférieure", "ou Résistance au feu en raid"),
            E("Bottes", 20020, "Endurance supérieure", "+7 Endurance (ou Vitesse mineure)"),
            E("Tête / Jambes", nil, "Arcanum de concentration", "quêtes des Librams (Hache-tripes)", "inv_misc_book_11"),
        },
        compos = {
            { 1, 20, MANA[2], SOINS[2], C(3383, "Élixir de sagesse") },
            { 20, 40, MANA[3], MANA[4], C(20747, "Huile de mana inférieure") },
            { 40, 60, MANA[5], C(9179, "Élixir d'intelligence supérieure") },
            { 60, 60, MANA[6], C(13511, "Flacon de sagesse distillée", "raid"), C(20007, "Potion de sang-de-mage"),
                C(20748, "Huile de mana brillante"), C(13931, "Soupe d'aileron de nuit") },
        },
    },
    tank = {
        nom = "Tank",
        montee = {
            BOTTES_MONTEE,
            E("Plastron", nil, "Santé supérieure ou Caractéristiques", "plus de vie", "inv_chest_plate06"),
            E("Bouclier", nil, "Endurance", "rang adapté à ton niveau", "inv_shield_06"),
            E("Arme", nil, "Frappe", "la menace vient aussi des dégâts", "inv_sword_04"),
        },
        max = {
            E("Arme", 20034, "Croisé", "ou Force +15"),
            E("Plastron", 20025, "Caractéristiques supérieures", "+4 à toutes les stats"),
            E("Bracelets", 20011, "Endurance excellente", "+9 Endurance"),
            E("Gants", 25072, "Menace", "+2 % de menace"),
            E("Cape", 13882, "Agilité inférieure", "ou Défense / Résistance au feu"),
            E("Bottes", 20020, "Endurance supérieure", "+7 Endurance"),
            E("Bouclier", 20017, "Endurance supérieure", "+7 Endurance"),
            E("Tête / Jambes", nil, "Arcanum de protection", "quêtes des Librams (Hache-tripes)", "inv_misc_book_11"),
        },
        compos = {
            { 1, 20, SOINS[2], C(3825, "Élixir de robustesse", "+120 vie") },
            { 20, 40, SOINS[3], SOINS[4], C(3825, "Élixir de robustesse"), C(8951, "Élixir de défense supérieure") },
            { 40, 60, SOINS[5], C(13445, "Élixir de défense excellente"), C(13455, "Potion de peau de pierre supérieure") },
            { 60, 60, SOINS[6], C(13510, "Flacon des Titans", "raid"), C(13445, "Élixir de défense excellente"),
                C(20004, "Potion de sang-de-troll majeure"), C(21151, "Rhum Rumsey étiquette noire") },
        },
    },
}

-- Profil de chaque spécialisation.
ns.enchantsSpecs = {
    WARRIOR = { arms = "force", fury = "force", protection = "tank" },
    PALADIN = { holy = "soigneur", protection = "tank", retribution = "force" },
    HUNTER = { beast_mastery = "agilite", marksmanship = "agilite", survival = "agilite" },
    ROGUE = { assassination = "agilite", combat = "agilite", subtlety = "agilite" },
    PRIEST = { discipline = "caster", holy = "soigneur", shadow = "caster" },
    SHAMAN = { elemental = "caster", enhancement = "force", restoration = "soigneur" },
    MAGE = { arcane = "caster", fire = "caster", frost = "caster" },
    WARLOCK = { affliction = "caster", demonology = "caster", destruction = "caster" },
    DRUID = { balance = "caster", feral_dps = "agilite", feral_tank = "tank", restoration = "soigneur" },
}
