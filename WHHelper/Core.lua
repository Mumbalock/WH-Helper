-- WH Helper : noyau (base de données sauvegardée, événements, commandes)
local addonName, ns = ...

ns.data = {}          -- rempli par Data\<Classe>.lua (généré depuis Wowhead), indexé par classe
ns.version = "0.5.0"

local defaults = {
    minimap = { angle = 225, hide = false },
    lastTab = "talents",
    conseilsMode = "classe", -- sous-onglet de Conseils : "classe", "rotation" ou "zones"
    stuffMode = "equipement", -- sous-onglet de Stuff : "equipement" ou "enchants"
    spec = {},   -- [classe] = "affliction"
    build = {},  -- [classe..spec] = numéro du build choisi
    replis = {}, -- [clé de section] = true quand la section est repliée
}

local function applyDefaults(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            applyDefaults(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

function ns.Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff9482c9WH Helper|r : " .. tostring(msg))
end

-- Classe, spé et build ------------------------------------------------------

function ns.GetClassData()
    local _, classToken = UnitClass("player")
    return ns.data[classToken], classToken
end

function ns.SpecKeys(classData)
    if classData.ordreSpecs then return classData.ordreSpecs end
    local keys = {}
    for k in pairs(classData.specs) do table.insert(keys, k) end
    table.sort(keys)
    return keys
end
local specKeys = ns.SpecKeys

function ns.SetSpec(key)
    local classData = ns.GetClassData()
    if classData and classData.specs[key] then ns.db.spec[classData.token] = key end
end

function ns.SetBuild(i)
    local classData = ns.GetClassData()
    if not classData then return end
    local _, specKey = ns.GetSpec(classData)
    ns.db.build[classData.token .. specKey] = i
end

-- Rangs de chaque talent après les `points` premiers points d'un build ordonné.
-- Renvoie { [sort] = rang }, le sort qui reçoit le point n° `points`, et son rang à ce moment.
function ns.RanksAt(build, points)
    local ranks, last, lastRank = {}, nil, 0
    local left = points
    for _, e in ipairs(build.etapes or {}) do
        if left <= 0 then break end
        local n = math.min(e.points, left)
        ranks[e.sort] = (ranks[e.sort] or 0) + n
        left = left - n
        last, lastRank = e.sort, ranks[e.sort]
    end
    return ranks, last, lastRank
end

-- Niveaux auxquels chaque point d'un talent est pris : { [sort] = { premier, dernier } }.
function ns.LevelsForTalents(build)
    local res, cumul = {}, 0
    for _, e in ipairs(build.etapes or {}) do
        local from, to = cumul + 10, cumul + e.points + 9
        cumul = cumul + e.points
        local r = res[e.sort]
        if r then r[2] = to else res[e.sort] = { from, to } end
    end
    return res
end

function ns.GetSpec(classData)
    if not classData then return nil end
    local key = ns.db and ns.db.spec[classData.token]
    if not (key and classData.specs[key]) then key = classData.defaultSpec end
    return classData.specs[key], key
end

function ns.NextSpec()
    local classData = ns.GetClassData()
    if not classData then return end
    local _, current = ns.GetSpec(classData)
    local keys = specKeys(classData)
    for i, k in ipairs(keys) do
        if k == current then
            ns.db.spec[classData.token] = keys[i % #keys + 1]
            break
        end
    end
end

function ns.GetBuild(classData)
    local spec, specKey = ns.GetSpec(classData)
    if not spec or not spec.builds or #spec.builds == 0 then return nil end
    local i = ns.db.build[classData.token .. specKey] or 1
    if not spec.builds[i] then i = 1 end
    return spec.builds[i], i, #spec.builds
end

function ns.NextBuild()
    local classData = ns.GetClassData()
    if not classData then return end
    local _, i, n = ns.GetBuild(classData)
    if not i then return end
    local _, specKey = ns.GetSpec(classData)
    ns.db.build[classData.token .. specKey] = i % n + 1
end

-- Noms traduits par le jeu ----------------------------------------------------

function ns.SpellName(id, fallback)
    local name
    if C_Spell and C_Spell.GetSpellName then
        local ok, n = pcall(C_Spell.GetSpellName, id)
        if ok then name = n end
    elseif GetSpellInfo then
        local ok, n = pcall(GetSpellInfo, id)
        if ok then name = n end
    end
    if name and name ~= "" then return name end
    return (fallback and fallback ~= "") and fallback or ns.T("sort %d", id)
end

function ns.ItemName(id, fallback)
    local getInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    local name
    if getInfo then
        local ok, n = pcall(getInfo, id)
        if ok then name = n end
    end
    if name then return name end
    -- Pas encore en cache : on demande l'objet au serveur, l'affichage se met à jour ensuite.
    if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, id) end
    return (fallback and fallback ~= "") and fallback or ns.T("objet %d", id)
end

-- Remplace {s:ID:Nom} et {i:ID:Nom} (produits par la mise à jour) par les noms du jeu.
function ns.Texte(s)
    if not s then return "" end
    s = s:gsub("{s:(%d+):([^}]*)}", function(id, nom)
        return "|cff71d5ff|Hspell:" .. id .. "|h" .. ns.SpellName(tonumber(id), nom) .. "|h|r"
    end)
    s = s:gsub("{i:(%d+):([^}]*)}", function(id, nom)
        return "|cffa335ee|Hitem:" .. id .. "|h" .. ns.ItemName(tonumber(id), nom) .. "|h|r"
    end)
    return s
end

-- Points de route (TomTom, sinon le point de carte du jeu) --------------------

-- Nom de zone donné par le jeu (dans la langue du client), sinon `fallback`.
function ns.MapName(map, fallback)
    if map and C_Map and C_Map.GetMapInfo then
        local ok, info = pcall(C_Map.GetMapInfo, map)
        if ok and info and info.name and info.name ~= "" then return info.name end
    end
    return fallback
end

-- Commande /way à copier (TomTom comprend « #uiMapID »).
function ns.WayCommand(map, x, y, title)
    return string.format("/way #%d %.1f %.1f %s", map, x, y, title or "")
end

-- Pose un point sur (map, x, y en %). Renvoie la méthode utilisée.
function ns.SetWaypoint(map, x, y, title)
    if TomTom and TomTom.AddWaypoint then
        local ok = pcall(TomTom.AddWaypoint, TomTom, map, x / 100, y / 100,
            { title = title, persistent = false, minimap = true, world = true, from = "WH Helper" })
        if ok then return "TomTom" end
    end
    if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
        local ok = pcall(function()
            if C_Map.CanSetUserWaypointOnMap and not C_Map.CanSetUserWaypointOnMap(map) then error("carte refusée") end
            C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(map, x / 100, y / 100))
            if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
                C_SuperTrack.SetSuperTrackedUserWaypoint(true)
            end
        end)
        if ok then return "carte" end
    end
    return nil
end

-- Nombre de points de talent déjà dépensés (nil si l'API n'existe pas).
function ns.GetSpentTalentPoints()
    local level = UnitLevel("player") or 1
    local earned = math.max(0, level - 9)
    if UnitCharacterPoints then
        local ok, unspent = pcall(UnitCharacterPoints, "player")
        if ok and type(unspent) == "number" then
            return earned - unspent, earned
        end
    end
    -- Plan B : additionner les points de chaque arbre.
    if GetNumTalentTabs and GetTalentTabInfo then
        local okTabs, numTabs = pcall(GetNumTalentTabs)
        if okTabs and numTabs then
            local total = 0
            for i = 1, numTabs do
                local r = { pcall(GetTalentTabInfo, i) }
                if r[1] then
                    -- Selon la version, pointsSpent est le 3e ou le 5e retour.
                    local spent = (type(r[4]) == "number" and r[4]) or (type(r[6]) == "number" and r[6]) or 0
                    total = total + spent
                end
            end
            return total, earned
        end
    end
    return nil, earned
end

-- Événements ----------------------------------------------------------------

local pendingRefresh = false
local function refreshSoon()
    if pendingRefresh or not ns.Refresh then return end
    pendingRefresh = true
    if C_Timer and C_Timer.After then
        C_Timer.After(0.3, function() pendingRefresh = false; ns.Refresh() end)
    else
        pendingRefresh = false
        ns.Refresh()
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LEVEL_UP")
f:RegisterEvent("CHARACTER_POINTS_CHANGED")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("GET_ITEM_INFO_RECEIVED")

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        WHHelperDB = WHHelperDB or {}
        applyDefaults(WHHelperDB, defaults)
        ns.db = WHHelperDB
    elseif event == "PLAYER_LOGIN" then
        if ns.CreateMinimapButton then ns.CreateMinimapButton() end
        if ns.HookTooltips then ns.HookTooltips() end
        local classData = ns.GetClassData()
        if classData then
            ns.Print(ns.T("chargé (données Wowhead du %s). Tape /whh ou clique sur l'icône de la minimap.", classData.majLe or "?"))
        else
            ns.Print(ns.T("pas encore de données pour ta classe. Tape /whh pour plus d'infos."))
        end
    elseif event ~= "ADDON_LOADED" then
        refreshSoon()
    end
end)

-- Commandes -----------------------------------------------------------------

SLASH_WHHELPER1 = "/whh"
SLASH_WHHELPER2 = "/whhelper"
SLASH_WHHELPER3 = "/aideclasse" -- ancien nom de l'addon
SLASH_WHHELPER4 = "/acl"
SlashCmdList["WHHELPER"] = function(msg)
    msg = strlower(strtrim(msg or ""))
    if msg == "minimap" then
        ns.db.minimap.hide = not ns.db.minimap.hide
        if ns.UpdateMinimapButton then ns.UpdateMinimapButton() end
        ns.Print(ns.T(ns.db.minimap.hide and "icône minimap cachée." or "icône minimap affichée."))
    elseif msg == "fr" or msg == "en" then
        ns.SetLang(msg)
        ns.Print(ns.T("langue : français."))
    elseif msg == "langue" or msg == "lang" or msg == "language" then
        ns.ToggleLang()
        ns.Print(ns.T("langue : français."))
    elseif msg == "talents" or msg == "stuff" or msg == "conseils" then
        ns.Show(msg)
    elseif msg == "zones" or msg == "zone" then
        ns.db.conseilsMode = "zones"; ns.Show("conseils")
    elseif msg == "rotation" or msg == "rota" then
        ns.db.conseilsMode = "rotation"; ns.Show("conseils")
    elseif msg == "enchants" or msg == "compos" then
        ns.db.stuffMode = "enchants"; ns.Show("stuff")
    elseif msg == "spe" or msg == "spé" then
        ns.NextSpec(); ns.Show("talents")
    elseif msg == "build" then
        ns.NextBuild(); ns.Show("talents")
    elseif msg == "taille" or msg == "reset" then
        ns.ResetSize(); ns.Print(ns.T("taille de la fenêtre remise par défaut."))
    elseif msg == "aide" or msg == "help" then
        ns.Print(ns.T("/whh : ouvrir/fermer la fenêtre"))
        ns.Print(ns.T("/whh talents | stuff | conseils : ouvrir un onglet"))
        ns.Print(ns.T("/whh zones : zones de montée en niveau"))
        ns.Print(ns.T("/whh rotation : rotation de ta spé — /whh enchants : enchantements et compos"))
        ns.Print(ns.T("/whh spe : spécialisation suivante — /whh build : build suivant"))
        ns.Print(ns.T("/whh minimap : cacher/afficher l'icône"))
        ns.Print(ns.T("/whh fr | en : langue de l'interface"))
        ns.Print(ns.T("/whh taille : remettre la fenêtre à sa taille par défaut"))
    else
        ns.Toggle()
    end
end
