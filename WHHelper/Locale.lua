-- WH Helper : langue de l'interface (français / anglais)
-- Le code est écrit en français ; ns.T() renvoie la traduction anglaise quand la langue est "en".
--   ns.T("Niveau %d", 12)  -> "Niveau 12" ou "Level 12"
--   ns.D("Givre")          -> nom venant des données (classe, arbre, spé, build, emplacement...)
local _, ns = ...

local EN = {
    -- Onglets et boutons
    ["Talents"] = "Talents",
    ["Stuff"] = "Gear",
    ["Conseils"] = "Tips",
    ["Classe"] = "Class",
    ["Zones d'xp"] = "XP zones",
    ["Équipement"] = "Gear",
    ["Enchants & compos"] = "Enchants & consumables",

    -- Rotation
    ["Rotation – %s"] = "Rotation – %s",
    ["Du haut vers le bas : lance le premier sort disponible. Survole une icône pour le détail."] =
        "Top to bottom: cast the first spell available. Hover an icon for details.",
    ["Ton niveau (%d) : "] = "Your level (%d): ",
    ["Pas encore de rotation écrite pour cette spécialisation."] = "No rotation written yet for this specialization.",

    -- Enchants & compos
    ["Enchantements et consommables (%s)"] = "Enchants and consumables (%s)",
    ["Profil : %s. Bases de WoW Classic : WoW Forever ajoute des recettes, vérifie sur Wowhead."] =
        "Profile: %s. WoW Classic basics: WoW Forever adds new recipes, check Wowhead.",
    ["Pas encore de liste pour cette spécialisation."] = "No list yet for this specialization.",
    ["Enchantements pendant la montée"] = "Enchants while leveling",
    ["Enchantements au niveau 60"] = "Enchants at level 60",
    ["Consommables par tranche de niveau"] = "Consumables by level range",
    ["/whh rotation : rotation de ta spé — /whh enchants : enchantements et compos"] =
        "/whh rotation: your spec's rotation — /whh enchants: enchants and consumables",
    ["Build :"] = "Build:",
    ["Lien Wowhead :"] = "Wowhead link:",
    ["Point"] = "Waypoint",
    ["Changer de langue"] = "Change language",
    ["Interface en français. Clic : passer en anglais."] = "Interface in English. Click: switch to French.",

    -- Talents
    ["Niveau %d"] = "Level %d",
    ["Niveau %d : %d/%d"] = "Level %d: %d/%d",
    ["Dans ce build : %d/%d"] = "In this build: %d/%d",
    ["À prendre au niveau %d"] = "Take at level %d",
    ["À prendre du niveau %d au %d"] = "Take from level %d to %d",
    ["Pas pris dans ce build"] = "Not taken in this build",
    ["%d pt"] = "%d pt",
    ["%d pts"] = "%d pts",
    ["%d points"] = "%d points",
    ["Aucun build"] = "No build",
    ["Aucun build disponible pour cette spécialisation."] = "No build available for this specialization.",
    ["Wowhead ne donne pas d'ordre pour ce build : voici la répartition finale au niveau 60."] =
        "Wowhead gives no order for this build: here is the final distribution at level 60.",
    ["Au niveau %d : +1 point en %s"] = "At level %d: +1 point in %s",
    ["Ton personnage : niveau %d"] = "Your character: level %d",
    [", %d/%d points dépensés"] = ", %d/%d points spent",
    ["→ prochain : %s"] = "→ next: %s",

    -- Stuff
    ["Priorité des statistiques (%s)"] = "Stat priority (%s)",
    ["  Pas encore disponible."] = "  Not available yet.",
    ["Meilleur équipement (BiS)"] = "Best in slot (BiS)",
    ["Wowhead n'a pas encore rempli sa liste BiS pour WoW Forever. Elle apparaîtra ici automatiquement dès qu'elle sera publiée."] =
        "Wowhead hasn't filled in its BiS list for WoW Forever yet. It will show up here automatically once it is published.",
    ["porté"] = "equipped",
    ["à chercher"] = "to find",

    -- Conseils
    ["Pas encore de conseils écrits pour cette classe. Le lien en bas de la fenêtre ouvre le guide Wowhead de ta spécialisation."] =
        "No tips written for this class yet. The link at the bottom of the window opens the Wowhead guide for your specialization.",
    ["Niveaux %d à %d"] = "Levels %d to %d",
    ["(ton niveau)"] = "(your level)",
    ["Talents, stats et BiS : %s, mis à jour le %s."] = "Talents, stats and BiS: %s, updated %s.",
    ["Les textes de cette section ne sont pas encore traduits."] =
        "This section's texts are not translated yet (French only for now).",

    -- Zones
    ["Zones de montée en niveau"] = "Leveling zones",
    ["Niveaux estimés par Wowhead (le jeu n'en donne pas). Bouton Point : flèche TomTom, sinon point sur la carte."] =
        "Levels estimated by Wowhead (the game gives none). Waypoint button: TomTom arrow, otherwise a pin on the map.",
    ["TomTom détecté."] = "TomTom detected.",
    ["TomTom non détecté : la commande /way s'affiche en bas pour la copier."] =
        "TomTom not detected: the /way command is shown at the bottom so you can copy it.",
    ["Pour ton niveau (%d) : "] = "For your level (%d): ",
    ["aucune zone listée"] = "no zone listed",
    ["Contestée"] = "Contested",
    [", nouvelle zone Forever"] = ", new Forever zone",
    ["niv. %d–%d"] = "lvl %d–%d",
    ["Accès : "] = "Access: ",
    ["Alliance : %s Horde : %s"] = "Alliance: %s Horde: %s",
    ["Centre de la zone"] = "Zone center",
    ["Coordonnées pas encore connues pour cette nouvelle zone."] = "Coordinates not known yet for this new zone.",
    ["Pas de camp de ta faction dans cette zone."] = "No camp for your faction in this zone.",
    ["Niveau 60 : Mont Hyjal (nouvelle zone de fin de jeu). Source : %s"] = "Level 60: Mount Hyjal (new endgame zone). Source: %s",
    ["point TomTom posé : %s (%s, %s)."] = "TomTom waypoint set: %s (%s, %s).",
    ["point posé sur ta carte : %s (%s, %s)."] = "waypoint set on your map: %s (%s, %s).",
    ["%s : %s, %s. Installe TomTom pour avoir une flèche ; la commande /way est en bas de la fenêtre (Ctrl+C)."] =
        "%s: %s, %s. Install TomTom to get an arrow; the /way command is at the bottom of the window (Ctrl+C).",
    ["Clic : flèche TomTom vers ce lieu."] = "Click: TomTom arrow to this place.",
    ["Clic : point sur la carte (TomTom conseillé pour la flèche)."] = "Click: pin on the map (TomTom recommended for the arrow).",

    -- Fenêtre, infobulles, minimap
    ["%s : pas encore de données pour cette classe.\n\nLes données arrivent avec la mise à jour automatique depuis Wowhead."] =
        "%s: no data for this class yet.\n\nData arrives with the automatic update from Wowhead.",
    ["WH Helper : %s %s (%s)"] = "WH Helper: %s %s (%s)",
    ["Clic gauche : ouvrir / fermer"] = "Left-click: open / close",
    ["Clic droit : onglet Stuff"] = "Right-click: Gear tab",
    ["Glisser : déplacer l'icône"] = "Drag: move the icon",
    ["Redimensionner"] = "Resize",
    ["Glisser : changer la taille de la fenêtre."] = "Drag: change the window size.",
    ["Clic droit : taille par défaut."] = "Right-click: default size.",

    -- Messages et commandes
    ["sort %d"] = "spell %d",
    ["objet %d"] = "item %d",
    ["chargé (données Wowhead du %s). Tape /whh ou clique sur l'icône de la minimap."] =
        "loaded (Wowhead data from %s). Type /whh or click the minimap icon.",
    ["pas encore de données pour ta classe. Tape /whh pour plus d'infos."] =
        "no data for your class yet. Type /whh for more info.",
    ["icône minimap cachée."] = "minimap icon hidden.",
    ["icône minimap affichée."] = "minimap icon shown.",
    ["langue : français."] = "language: English.",
    ["/whh : ouvrir/fermer la fenêtre"] = "/whh: open/close the window",
    ["/whh talents | stuff | conseils : ouvrir un onglet"] = "/whh talents | stuff | conseils: open a tab",
    ["/whh zones : zones de montée en niveau"] = "/whh zones: leveling zones",
    ["/whh spe : spécialisation suivante — /whh build : build suivant"] =
        "/whh spe: next specialization — /whh build: next build",
    ["/whh minimap : cacher/afficher l'icône"] = "/whh minimap: hide/show the icon",
    ["/whh fr | en : langue de l'interface"] = "/whh fr | en: interface language",
    ["taille de la fenêtre remise par défaut."] = "window size reset to default.",
    ["/whh taille : remettre la fenêtre à sa taille par défaut"] = "/whh taille: reset the window to its default size",
}

-- Libellés venant des fichiers de données (générés en français).
local DATA_EN = {
    -- Classes
    ["Guerrier"] = "Warrior", ["Paladin"] = "Paladin", ["Chasseur"] = "Hunter", ["Voleur"] = "Rogue",
    ["Prêtre"] = "Priest", ["Chaman"] = "Shaman", ["Mage"] = "Mage", ["Démoniste"] = "Warlock", ["Druide"] = "Druid",
    -- Arbres et spécialisations
    ["Armes"] = "Arms", ["Fureur"] = "Fury", ["Protection"] = "Protection",
    ["Sacré"] = "Holy", ["Vindicte"] = "Retribution",
    ["Maîtrise des bêtes"] = "Beast Mastery", ["Précision"] = "Marksmanship", ["Survie"] = "Survival",
    ["Assassinat"] = "Assassination", ["Combat"] = "Combat", ["Finesse"] = "Subtlety",
    ["Discipline"] = "Discipline", ["Ombre"] = "Shadow",
    ["Élémentaire"] = "Elemental", ["Amélioration"] = "Enhancement", ["Restauration"] = "Restoration",
    ["Arcanes"] = "Arcane", ["Feu"] = "Fire", ["Givre"] = "Frost",
    ["Affliction"] = "Affliction", ["Démonologie"] = "Demonology", ["Destruction"] = "Destruction",
    ["Équilibre"] = "Balance", ["Combat farouche"] = "Feral Combat",
    ["Combat farouche (DPS)"] = "Feral Combat (DPS)", ["Combat farouche (Tank)"] = "Feral Combat (Tank)",
    -- Builds
    ["Montée en niveau"] = "Leveling", ["Donjon"] = "Dungeon", ["Raid"] = "Raid", ["PvP"] = "PvP",
    -- Emplacements
    ["Tête"] = "Head", ["Cou"] = "Neck", ["Épaules"] = "Shoulders", ["Dos"] = "Back", ["Torse"] = "Chest",
    ["Poignets"] = "Wrists", ["Mains"] = "Hands", ["Taille"] = "Waist", ["Jambes"] = "Legs", ["Pieds"] = "Feet",
    ["Anneaux"] = "Rings", ["Bijoux"] = "Trinkets", ["Main droite"] = "Main Hand", ["Arme"] = "Weapon",
    ["Deux mains"] = "Two-Hand", ["Main gauche"] = "Off Hand", ["Baguette"] = "Wand", ["Relique"] = "Relic",
    -- Rangs
    ["Très bon"] = "Great", ["Bon"] = "Good",
    -- Titres des conseils
    ["Conseils généraux"] = "General tips", ["Rotation"] = "Rotation",
    ["Talents et sorts à apprendre"] = "Talents and spells to learn", ["Talents et totems"] = "Talents and totems",
    ["Métiers, camp et consommables"] = "Professions, camp and consumables",
    ["Poisons et donjons"] = "Poisons and dungeons", ["Fragments d'âme et donjons"] = "Soul shards and dungeons",
    -- Divers
    ["Wowhead – guides WoW Forever"] = "Wowhead – WoW Forever guides",
}

local function clientDefault()
    local loc = GetLocale and GetLocale() or "frFR"
    return (loc == "frFR") and "fr" or "en"
end

function ns.GetLang()
    local l = ns.db and ns.db.lang
    if l ~= "fr" and l ~= "en" then l = clientDefault() end
    return l
end

function ns.SetLang(l)
    if l ~= "fr" and l ~= "en" then return end
    if ns.db then ns.db.lang = l end
    if ns.OnLanguageChanged then ns.OnLanguageChanged() end
end

function ns.ToggleLang()
    ns.SetLang(ns.GetLang() == "fr" and "en" or "fr")
end

-- Texte de l'interface, avec arguments de string.format éventuels.
function ns.T(s, ...)
    local out = s
    if ns.GetLang() == "en" then
        local e = EN[s]
        if e and e ~= "" then out = e end
    end
    if select("#", ...) > 0 then return out:format(...) end
    return out
end

-- Libellé venant des données : nom exact, sinon le début avant « (2) » ou « – détail ».
function ns.D(s)
    if not s or ns.GetLang() ~= "en" then return s end
    if DATA_EN[s] then return DATA_EN[s] end
    local head, tail = s:match("^(.-)( %(.*)$")
    if not head then head, tail = s:match("^(.-)( – .*)$") end
    if head and DATA_EN[head] then return DATA_EN[head] .. tail end
    return s
end
