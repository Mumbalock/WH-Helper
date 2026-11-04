-- AideClasse : fenêtre principale
--   Talents  : les 3 arbres en icônes + barre de niveau (quel talent à quel niveau)
--   Stuff    : Équipement (stats + BiS) / Enchants & compos
--   Conseils : Classe / Rotation (icônes, par tranche de niveau) / Zones d'xp
local _, ns = ...
local T, D = ns.T, ns.D

local GREEN, GREY, GOLD, WHITE, ORANGE = "|cff40ff40", "|cff808080", "|cffffd100", "|cffffffff", "|cffff9933"
local TABS = {
    { key = "talents",  label = "Talents" },
    { key = "stuff",    label = "Stuff" },
    { key = "conseils", label = "Conseils" },
}
local W, H = 700, 650                    -- taille par défaut de la fenêtre
local MIN_W, MIN_H, MAX_W, MAX_H = 580, 440, 1600, 1200
local TALENTS_W, TALENTS_H = W - 28, H - 108 -- zone Talents à l'échelle 1
local contentW = W - 80                  -- largeur du texte dans la zone qui défile
local TREE_W, TREE_H, CELL, CELL_Y, ICON = 216, 360, 50, 46, 36
local TREE_TINT = { { 0.10, 0.22, 0.14 }, { 0.12, 0.24, 0.08 }, { 0.30, 0.12, 0.04 } }

local frame, currentTab
local tabButtons, specButtons = {}, {}
local talentsView, scrollView, scroll, content, text
local buildButton, buildMenu, trees, slider, levelText, infoText, playerText, linkBox
local buildLabel, linkLabel, langButton
local itemRows, zoneRows = {}, {}
local subBar, subButtons = nil, {} -- subButtons[onglet][mode] = bouton
local viewLevel -- niveau affiché par la barre
local ZONES_URL = "https://www.wowhead.com/forever/zones"

-- Sous-onglets : clé sauvegardée dans ns.db, liste des modes (le premier est celui par défaut).
local SUBTABS = {
    conseils = { db = "conseilsMode", modes = {
        { key = "classe", label = "Classe" },
        { key = "rotation", label = "Rotation" },
        { key = "zones", label = "Zones d'xp" },
    } },
    stuff = { db = "stuffMode", modes = {
        { key = "equipement", label = "Équipement" },
        { key = "enchants", label = "Enchants & compos" },
    } },
}

local function subMode(tab)
    local def = SUBTABS[tab]
    if not def then return nil end
    local v = ns.db and ns.db[def.db]
    for _, m in ipairs(def.modes) do
        if m.key == v then return v end
    end
    return def.modes[1].key
end

local function conseilsMode() return subMode("conseils") end

local function icon(name)
    if not name or name == "" then return "Interface\\Icons\\INV_Misc_QuestionMark" end
    return "Interface\\Icons\\" .. name
end

local function makeButton(parent, label, width)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(width, 22)
    b:SetText(label)
    return b
end

-- Arbres de talents -----------------------------------------------------------

local function createTree(parent, index)
    local t = CreateFrame("Frame", nil, parent)
    t:SetSize(TREE_W, TREE_H)

    local base = t:CreateTexture(nil, "BACKGROUND", nil, -8)
    base:SetAllPoints()
    local c = TREE_TINT[index] or { 0.1, 0.1, 0.1 }
    base:SetColorTexture(c[1], c[2], c[3], 1)

    -- Fond de l'arbre du jeu (4 morceaux, comme la fenêtre de talents Classic).
    t.bg = {}
    local sx, sy = TREE_W / 320, (TREE_H - 26) / 384
    local pieces = { { "TopLeft", 256, 256, 0, 0 }, { "TopRight", 64, 256, 256, 0 },
                     { "BottomLeft", 256, 128, 0, 256 }, { "BottomRight", 64, 128, 256, 256 } }
    for _, p in ipairs(pieces) do
        local tex = t:CreateTexture(nil, "BACKGROUND", nil, -7)
        tex:SetSize(p[2] * sx, p[3] * sy)
        tex:SetPoint("TOPLEFT", t, "TOPLEFT", p[4] * sx, -26 - p[5] * sy)
        tex:SetAlpha(0.75)
        t.bg[p[1]] = tex
    end

    local header = t:CreateTexture(nil, "BORDER")
    header:SetPoint("TOPLEFT"); header:SetPoint("TOPRIGHT"); header:SetHeight(26)
    header:SetColorTexture(0, 0, 0, 0.75)
    t.headerIcon = t:CreateTexture(nil, "ARTWORK")
    t.headerIcon:SetSize(20, 20)
    t.headerIcon:SetPoint("TOPLEFT", 4, -3)
    t.title = t:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t.title:SetPoint("LEFT", t.headerIcon, "RIGHT", 6, 0)
    t.points = t:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    t.points:SetPoint("TOPRIGHT", -8, -7)

    t.cells, t.lines = {}, {}
    return t
end

local function cellPos(talent)
    return 14 + talent.col * CELL, -(34 + talent.ligne * CELL_Y)
end

local function getCell(tree, i)
    local cell = tree.cells[i]
    if cell then return cell end
    cell = CreateFrame("Button", nil, tree)
    cell:SetSize(ICON, ICON)
    cell.icon = cell:CreateTexture(nil, "ARTWORK")
    cell.icon:SetAllPoints()
    cell.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    cell.border = cell:CreateTexture(nil, "OVERLAY")
    cell.border:SetPoint("TOPLEFT", -2, 2); cell.border:SetPoint("BOTTOMRIGHT", 2, -2)
    cell.border:SetDrawLayer("BACKGROUND", 1)
    cell.glow = cell:CreateTexture(nil, "OVERLAY")
    cell.glow:SetTexture("Interface\\Buttons\\CheckButtonHilight")
    cell.glow:SetBlendMode("ADD")
    cell.glow:SetPoint("TOPLEFT", -6, 6); cell.glow:SetPoint("BOTTOMRIGHT", 6, -6)
    local rankBg = cell:CreateTexture(nil, "OVERLAY")
    rankBg:SetColorTexture(0, 0, 0, 0.85)
    rankBg:SetSize(26, 13)
    rankBg:SetPoint("BOTTOMRIGHT", 8, -5)
    cell.rankBg = rankBg
    cell.rank = cell:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cell.rank:SetPoint("CENTER", rankBg, "CENTER", 0, 0)
    cell.rank:SetDrawLayer("OVERLAY", 7)
    cell:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local ok = pcall(GameTooltip.SetSpellByID, GameTooltip, self.talent.sort)
        if not ok then GameTooltip:SetText(ns.SpellName(self.talent.sort, self.talent.nom)) end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(T("Niveau %d : %d/%d", viewLevel, self.r, self.talent.rangMax), 1, 0.82, 0)
        if self.final > 0 then
            GameTooltip:AddLine(T("Dans ce build : %d/%d", self.final, self.talent.rangMax), 1, 1, 1)
            if self.levels then
                local a, b = self.levels[1], self.levels[2]
                GameTooltip:AddLine(a == b and T("À prendre au niveau %d", a) or T("À prendre du niveau %d au %d", a, b), 0.25, 1, 0.25)
            end
        else
            GameTooltip:AddLine(T("Pas pris dans ce build"), 0.5, 0.5, 0.5)
        end
        GameTooltip:Show()
    end)
    cell:SetScript("OnLeave", function() GameTooltip:Hide() end)
    tree.cells[i] = cell
    return cell
end

local function getLine(tree, i)
    local l = tree.lines[i]
    if not l then
        l = tree:CreateTexture(nil, "BORDER")
        tree.lines[i] = l
    end
    return l
end

local function drawTree(tree, data, index, ranks, finals, lastSort, levels)
    tree.title:SetText(D(data.nom))
    tree.headerIcon:SetTexture(icon(data.icone))
    for name, tex in pairs(tree.bg) do
        tex:SetTexture("Interface\\TalentFrame\\" .. data.fond .. "-" .. name)
    end

    local bySort, total = {}, 0
    for i, t in ipairs(data.talents) do
        bySort[t.sort] = t
        local cell = getCell(tree, i)
        local x, y = cellPos(t)
        cell:ClearAllPoints()
        cell:SetPoint("TOPLEFT", tree, "TOPLEFT", x, y)
        cell.talent = t
        cell.r = ranks[t.sort] or 0
        cell.final = finals[t.sort] or 0
        cell.levels = levels[t.sort]
        total = total + cell.r
        cell.icon:SetTexture(icon(t.icone))
        cell.icon:SetDesaturated(cell.r == 0)
        cell.icon:SetAlpha(cell.r == 0 and (cell.final > 0 and 0.85 or 0.45) or 1)
        if cell.r >= t.rangMax then
            cell.border:SetColorTexture(1, 0.82, 0, 1)
        elseif cell.r > 0 then
            cell.border:SetColorTexture(0.25, 1, 0.25, 1)
        elseif cell.final > 0 then
            cell.border:SetColorTexture(0.45, 0.45, 0.45, 1)
        else
            cell.border:SetColorTexture(0.15, 0.15, 0.15, 1)
        end
        if cell.r > 0 then
            local col = (cell.r >= t.rangMax) and GOLD or GREEN
            cell.rank:SetText(col .. cell.r .. "/" .. t.rangMax .. "|r")
            cell.rank:Show(); cell.rankBg:Show()
        else
            cell.rank:Hide(); cell.rankBg:Hide()
        end
        if lastSort == t.sort then cell.glow:Show() else cell.glow:Hide() end
        cell:Show()
    end
    for i = #data.talents + 1, #tree.cells do tree.cells[i]:Hide() end

    -- Flèches de prérequis (traits verticaux ou horizontaux).
    local n = 0
    for _, t in ipairs(data.talents) do
        local parent = t.requiert and t.requiert > 0 and bySort[t.requiert]
        if parent then
            n = n + 1
            local l = getLine(tree, n)
            local px, py = cellPos(parent)
            local cx, cy = cellPos(t)
            l:ClearAllPoints()
            if parent.col == t.col then
                l:SetSize(4, (py - cy) - ICON)
                l:SetPoint("TOPLEFT", tree, "TOPLEFT", px + ICON / 2 - 2, py - ICON)
            else
                local left = math.min(px, cx)
                l:SetSize(math.abs(cx - px) - ICON, 4)
                l:SetPoint("TOPLEFT", tree, "TOPLEFT", left + ICON, py - ICON / 2 + 2)
            end
            if (ranks[t.sort] or 0) > 0 then l:SetColorTexture(1, 0.82, 0, 0.9) else l:SetColorTexture(0.55, 0.55, 0.55, 0.8) end
            l:Show()
        end
    end
    for i = n + 1, #tree.lines do tree.lines[i]:Hide() end

    tree.points:SetText(T(total > 1 and "%d pts" or "%d pt", total))
end

-- Vue Talents --------------------------------------------------------------------

local function refreshTalents(classData, spec, build, bi, bn)
    buildButton.label:SetText(build and D(build.nom) or T("Aucun build"))

    local ordered = build and build.etapes and #build.etapes > 0
    local finals = {}
    for _, t in ipairs((build and build.final) or {}) do finals[t.sort] = t.points end
    local levels = (ordered and ns.LevelsForTalents(build)) or {}

    local ranks, lastSort, lastRank
    if ordered then
        ranks, lastSort, lastRank = ns.RanksAt(build, viewLevel - 9)
        slider:Enable(); slider:SetAlpha(1)
    else
        ranks = finals
        slider:Disable(); slider:SetAlpha(0.4)
    end

    for i, tree in ipairs(trees) do
        local data = classData.arbres and classData.arbres[i]
        if data then drawTree(tree, data, i, ranks, finals, lastSort, levels); tree:Show() else tree:Hide() end
    end

    if not build then
        levelText:SetText("")
        infoText:SetText(GREY .. T("Aucun build disponible pour cette spécialisation.") .. "|r")
    elseif not ordered then
        levelText:SetText(GOLD .. T("Niveau %d", 60) .. "|r")
        infoText:SetText(GREY .. T("Wowhead ne donne pas d'ordre pour ce build : voici la répartition finale au niveau 60.") .. "|r")
    else
        levelText:SetText(GOLD .. T("Niveau %d", viewLevel) .. "|r  " .. WHITE .. T("%d points", viewLevel - 9) .. "|r")
        local t
        for _, tr in ipairs(classData.arbres or {}) do
            for _, x in ipairs(tr.talents) do if x.sort == lastSort then t = x end end
        end
        if t then
            infoText:SetText(T("Au niveau %d : +1 point en %s", viewLevel, "|cff71d5ff" .. ns.SpellName(t.sort, t.nom) .. "|r") ..
                " (" .. lastRank .. "/" .. t.rangMax .. ")")
        else
            infoText:SetText("")
        end
    end

    -- Où en est le personnage ?
    local spent, earned = ns.GetSpentTalentPoints()
    local level = UnitLevel("player") or 1
    local line = T("Ton personnage : niveau %d", level) .. (spent and T(", %d/%d points dépensés", spent, earned) or "")
    if ordered and spent and spent < earned then
        local _, nextSort = ns.RanksAt(build, spent + 1)
        for _, tr in ipairs(classData.arbres or {}) do
            for _, x in ipairs(tr.talents) do
                if x.sort == nextSort then line = line .. "  " .. ORANGE .. T("→ prochain : %s", ns.SpellName(x.sort, x.nom)) .. "|r" end
            end
        end
    end
    playerText:SetText(GREY .. line .. "|r")
end

local function createBuildMenu(parent)
    buildButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    buildButton:SetSize(320, 22)
    buildButton:SetPoint("TOPLEFT", parent, "TOPLEFT", 60, 0)
    buildButton:SetText("")
    buildButton.label = buildButton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    buildButton.label:SetPoint("LEFT", 10, 0)
    buildButton.label:SetPoint("RIGHT", -24, 0)
    buildButton.label:SetJustifyH("LEFT")
    local arrow = buildButton:CreateTexture(nil, "OVERLAY")
    arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    arrow:SetSize(20, 20)
    arrow:SetPoint("RIGHT", -3, 0)
    buildLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    buildLabel:SetPoint("RIGHT", buildButton, "LEFT", -8, 0)

    buildMenu = CreateFrame("Frame", nil, parent)
    buildMenu:SetFrameStrata("FULLSCREEN_DIALOG")
    buildMenu:SetPoint("TOPLEFT", buildButton, "BOTTOMLEFT", 0, -2)
    buildMenu:SetWidth(320)
    local bg = buildMenu:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.05, 0.05, 0.07, 0.97)
    local edge = buildMenu:CreateTexture(nil, "BORDER")
    edge:SetPoint("TOPLEFT", -1, 1); edge:SetPoint("BOTTOMRIGHT", 1, -1)
    edge:SetColorTexture(0.6, 0.5, 0.25, 1)
    edge:SetDrawLayer("BACKGROUND", -1)
    buildMenu.items = {}
    buildMenu:Hide()

    buildButton:SetScript("OnClick", function()
        if buildMenu:IsShown() then buildMenu:Hide(); return end
        local classData = ns.GetClassData()
        local spec = classData and ns.GetSpec(classData)
        if not spec or not spec.builds then return end
        local _, current = ns.GetBuild(classData)
        for i, b in ipairs(spec.builds) do
            local item = buildMenu.items[i]
            if not item then
                item = CreateFrame("Button", nil, buildMenu)
                item:SetHeight(20)
                item:SetPoint("TOPLEFT", 4, -4 - (i - 1) * 20)
                item:SetPoint("RIGHT", -4, 0)
                item:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
                item.text = item:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                item.text:SetPoint("LEFT", 8, 0)
                item:SetScript("OnClick", function(self)
                    ns.SetBuild(self.index)
                    buildMenu:Hide()
                    ns.Refresh()
                end)
                buildMenu.items[i] = item
            end
            item.index = i
            item.text:SetText((i == current and GOLD or WHITE) .. D(b.nom) .. "|r")
            item:Show()
        end
        for i = #spec.builds + 1, #buildMenu.items do buildMenu.items[i]:Hide() end
        buildMenu:SetHeight(8 + #spec.builds * 20)
        buildMenu:Show()
    end)
end

local function createTalentsView()
    talentsView = CreateFrame("Frame", nil, frame)
    talentsView:SetPoint("TOPLEFT", 14, -64)
    talentsView:SetPoint("BOTTOMRIGHT", -14, 44)

    -- Contenu à taille fixe, mis à l'échelle quand on redimensionne la fenêtre.
    local tv = CreateFrame("Frame", nil, talentsView)
    tv:SetSize(TALENTS_W, TALENTS_H)
    tv:SetPoint("TOP")
    talentsView.inner = tv

    createBuildMenu(tv)

    trees = {}
    for i = 1, 3 do
        local t = createTree(tv, i)
        t:SetPoint("TOPLEFT", tv, "TOPLEFT", (i - 1) * (TREE_W + 8), -30)
        trees[i] = t
    end

    -- Barre de niveau.
    levelText = tv:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    levelText:SetPoint("TOPLEFT", tv, "TOPLEFT", 0, -(30 + TREE_H + 12))

    slider = CreateFrame("Slider", nil, tv)
    slider:SetOrientation("HORIZONTAL")
    slider:SetSize(480, 18)
    slider:SetPoint("TOPLEFT", tv, "TOPLEFT", 170, -(30 + TREE_H + 10))
    slider:SetMinMaxValues(10, 60)
    slider:SetValueStep(1)
    pcall(slider.SetObeyStepOnDrag, slider, true)
    slider:EnableMouseWheel(true)
    local track = slider:CreateTexture(nil, "BACKGROUND")
    track:SetColorTexture(0.25, 0.22, 0.30, 0.9)
    track:SetPoint("LEFT"); track:SetPoint("RIGHT"); track:SetHeight(6)
    local thumb = slider:CreateTexture(nil, "OVERLAY")
    thumb:SetTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    thumb:SetSize(32, 32)
    slider:SetThumbTexture(thumb)
    local low = slider:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, 0); low:SetText("10")
    local high = slider:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    high:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, 0); high:SetText("60")
    slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        if value ~= viewLevel then viewLevel = value; ns.Refresh() end
    end)
    slider:SetScript("OnMouseWheel", function(self, delta)
        self:SetValue(math.max(10, math.min(60, (viewLevel or 10) + delta)))
    end)

    infoText = tv:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    infoText:SetPoint("TOPLEFT", levelText, "BOTTOMLEFT", 0, -16)
    infoText:SetWidth(W - 40)
    infoText:SetJustifyH("LEFT")
    playerText = tv:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    playerText:SetPoint("TOPLEFT", infoText, "BOTTOMLEFT", 0, -6)
    playerText:SetWidth(W - 40)
    playerText:SetJustifyH("LEFT")
end

-- Vues Stuff et Conseils (zone qui défile) ----------------------------------------

local function itemIcon(o)
    local id = o.id
    local fn = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
    if fn then
        local ok, tex = pcall(fn, id)
        if ok and tex then return tex end
    end
    return icon(o.icone)
end

local function itemIsEquipped(id)
    local fn = (C_Item and C_Item.IsEquippedItem) or IsEquippedItem
    if fn then
        local ok, res = pcall(fn, id)
        if ok then return res end
    end
    return false
end

local function getItemRow(i)
    local row = itemRows[i]
    if row then return row end
    row = CreateFrame("Button", nil, content)
    row:SetSize(contentW, 30)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(26, 26)
    row.icon:SetPoint("LEFT", 4, 0)
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
    row.text:SetPoint("RIGHT", -4, 0)
    row.text:SetJustifyH("LEFT")
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
    row:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if self.itemID then
            if not pcall(GameTooltip.SetItemByID, GameTooltip, self.itemID) then
                GameTooltip:SetText(ns.ItemName(self.itemID))
            end
        elseif self.spellID then
            if not pcall(GameTooltip.SetSpellByID, GameTooltip, self.spellID) then
                GameTooltip:SetText(ns.SpellName(self.spellID, self.tipTitle))
            end
        else
            GameTooltip:SetText(self.tipTitle or "")
        end
        if self.tipNote then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(self.tipNote, 0.25, 1, 0.25, true)
        end
        GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function() GameTooltip:Hide() end)
    itemRows[i] = row
    return row
end

-- Zones d'xp ------------------------------------------------------------------------

local function getZoneRow(i)
    local row = zoneRows[i]
    if row then return row end
    row = CreateFrame("Frame", nil, content)
    row:SetWidth(contentW)
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("TOPLEFT", 0, 0)
    row.text:SetWidth(contentW - 90)
    row.text:SetJustifyH("LEFT")
    row.text:SetJustifyV("TOP")
    row.text:SetSpacing(2)
    row.btn = makeButton(row, "Point", 70)
    row.btn:SetHeight(18)
    row.btn:SetPoint("TOPRIGHT", row, "TOPRIGHT", -6, 1)
    row.btn:SetScript("OnClick", function(self)
        local p = self.point
        local cmd = ns.WayCommand(p.map, p.x, p.y, p.title)
        linkBox.url = cmd
        linkBox:SetText(cmd)
        linkBox:SetCursorPosition(0)
        local how = ns.SetWaypoint(p.map, p.x, p.y, p.title)
        local x, y = tostring(p.x), tostring(p.y)
        if how == "TomTom" then
            ns.Print(T("point TomTom posé : %s (%s, %s).", p.title, x, y))
        elseif how == "carte" then
            ns.Print(T("point posé sur ta carte : %s (%s, %s).", p.title, x, y))
        else
            ns.Print(T("%s : %s, %s. Installe TomTom pour avoir une flèche ; la commande /way est en bas de la fenêtre (Ctrl+C).", p.title, x, y))
        end
    end)
    row.btn:SetScript("OnEnter", function(self)
        local p = self.point
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(p.title)
        GameTooltip:AddLine(ns.WayCommand(p.map, p.x, p.y, p.title), 1, 1, 1)
        GameTooltip:AddLine(TomTom and T("Clic : flèche TomTom vers ce lieu.") or
            T("Clic : point sur la carte (TomTom conseillé pour la flèche)."), 0.25, 1, 0.25)
        GameTooltip:Show()
    end)
    row.btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    zoneRows[i] = row
    return row
end

-- Nom de zone : en anglais, notre traduction (le client peut être en français) ; sinon le nom du jeu.
local function zoneName(z)
    if ns.GetLang() == "en" and ns.zonesEN and ns.zonesEN[z.nom] then return ns.zonesEN[z.nom] end
    return ns.MapName(z.map, z.nom)
end

local function zoneVisible(z, faction)
    return not z.camp or not faction or z.camp == faction
end

local function refreshZones()
    local faction = UnitFactionGroup("player")
    if faction ~= "Alliance" and faction ~= "Horde" then faction = nil end
    local level = UnitLevel("player") or 1

    local list = {}
    for _, z in ipairs(ns.zones or {}) do
        if zoneVisible(z, faction) then table.insert(list, z) end
    end
    table.sort(list, function(a, b)
        if a.min ~= b.min then return a.min < b.min end
        return a.max < b.max
    end)

    local good = {}
    for _, z in ipairs(list) do
        if level >= z.min and level <= z.max then table.insert(good, zoneName(z)) end
    end

    local head = {
        GOLD .. T("Zones de montée en niveau") .. (faction and (" – " .. faction) or "") .. "|r",
        GREY .. T("Niveaux estimés par Wowhead (le jeu n'en donne pas). Bouton Point : flèche TomTom, sinon point sur la carte.") .. "|r",
        (TomTom and (GREEN .. T("TomTom détecté.") .. "|r") or (ORANGE .. T("TomTom non détecté : la commande /way s'affiche en bas pour la copier.") .. "|r")),
        " ",
        GREEN .. T("Pour ton niveau (%d) : ", level) .. "|r" .. (#good > 0 and table.concat(good, ", ") or (GREY .. T("aucune zone listée") .. "|r")),
        " ",
    }
    text:SetText(table.concat(head, "\n"))
    local y = -(text:GetStringHeight() + 6)

    local n = 0
    local function addRow(str, point, gap)
        n = n + 1
        local row = getZoneRow(n)
        row:ClearAllPoints()
        y = y - (gap or 0)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
        row.text:SetText(str)
        row.btn:SetText(T("Point"))
        if point then row.btn.point = point; row.btn:Show() else row.btn:Hide() end
        local h = math.max(row.text:GetStringHeight(), point and 18 or 0)
        row:SetHeight(h)
        row:Show()
        y = y - h - 2
    end

    for _, z in ipairs(list) do
        local nom = zoneName(z)
        local col, tag = WHITE, ""
        if level >= z.min and level <= z.max then col, tag = GREEN, "  " .. T("(ton niveau)")
        elseif level > z.max then col = GREY
        elseif level < z.min - 5 then col = ORANGE end
        local camp = z.camp or T("Contestée")
        if z.nouveau then camp = camp .. T(", nouvelle zone Forever") end
        addRow(col .. nom .. "|r  " .. GOLD .. T("niv. %d–%d", z.min, z.max) .. "|r  " .. GREY .. "(" .. camp .. ")|r" .. GREEN .. tag .. "|r", nil, 8)

        local ZT = ns.ZT or function(s) return s end
        local acces = ZT((faction and z.acces[faction]) or z.acces.tous)
        if not acces then
            acces = z.acces.Alliance and z.acces.Horde and T("Alliance : %s Horde : %s", ZT(z.acces.Alliance), ZT(z.acces.Horde))
                or ZT(z.acces.Alliance or z.acces.Horde)
        end
        if acces then addRow("     " .. T("Accès : ") .. acces) end

        local shown = 0
        for _, h in ipairs(z.hubs or {}) do
            if not h.f or not faction or h.f == faction then
                local map = h.map or z.map
                local hubNom = ZT(h.nom)
                addRow("     • " .. hubNom .. GREY .. "  " .. h.x .. ", " .. h.y .. "|r",
                    { map = map, x = h.x, y = h.y, title = hubNom })
                shown = shown + 1
            end
        end
        if not z.hubs and z.map then
            addRow("     • " .. T("Centre de la zone") .. GREY .. "  50, 50|r", { map = z.map, x = 50, y = 50, title = nom })
        elseif z.nouveau then
            addRow("     " .. GREY .. T("Coordonnées pas encore connues pour cette nouvelle zone.") .. "|r")
        elseif shown == 0 then
            addRow("     " .. GREY .. T("Pas de camp de ta faction dans cette zone.") .. "|r")
        end
    end

    y = y - 12
    n = n + 1
    local last = getZoneRow(n)
    last:ClearAllPoints()
    last:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    last.text:SetText(GREY .. T("Niveau 60 : Mont Hyjal (nouvelle zone de fin de jeu). Source : %s", ZONES_URL) .. "|r")
    last.btn:Hide()
    last:SetHeight(last.text:GetStringHeight())
    last:Show()
    y = y - last:GetHeight()
    content:SetHeight(-y + 10)
end

-- Rotation et Enchants & compos (lignes avec icônes) ------------------------------

local function spellIcon(id, fallback)
    if id then
        local fn = (C_Spell and C_Spell.GetSpellTexture) or GetSpellTexture
        if fn then
            local ok, tex = pcall(fn, id)
            if ok and tex then return tex end
        end
    end
    return icon(fallback)
end

local function inlineIcon(tex, size)
    size = size or 20
    return "|T" .. tostring(tex) .. ":" .. size .. ":" .. size .. ":0:0:64:64:5:59:5:59|t"
end

-- Le niveau est-il dans la tranche [a, b] ? `strict` : b exclu même à 60 (quand une tranche « 60 » existe).
local function inBracket(level, a, b, strict)
    if a == b then return level == a end
    return level >= a and (level < b or (not strict and b == 60 and level == 60))
end

local function bracketTitle(a, b)
    return (a == b) and T("Niveau %d", a) or T("Niveaux %d à %d", a, b)
end

-- Empile des lignes (texte ou icône) sous le texte d'en-tête.
local function newStack(y)
    local S = { y = y, ni = 0, nt = 0 }
    function S.line(str, gap)
        S.nt = S.nt + 1
        local row = getZoneRow(S.nt)
        row:ClearAllPoints()
        S.y = S.y - (gap or 0)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, S.y)
        row.text:SetText(str)
        row.btn:Hide()
        local h = row.text:GetStringHeight()
        row:SetHeight(h)
        row:Show()
        S.y = S.y - h - 3
    end
    function S.iconRow(tex, str, tip)
        S.ni = S.ni + 1
        local row = getItemRow(S.ni)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 12, S.y)
        row:SetHeight(28)
        row.icon:SetTexture(tex)
        row.text:SetText(str)
        row.itemID, row.spellID = tip.item, tip.spell
        row.tipTitle, row.tipNote = tip.title, tip.note
        row:Show()
        S.y = S.y - 29
    end
    return S
end

local function untranslatedNote(lines)
    if ns.GetLang() == "en" then
        table.insert(lines, GREY .. T("Les textes de cette section ne sont pas encore traduits.") .. "|r")
    end
end

local function refreshRotation(classData, spec)
    local _, specKey = ns.GetSpec(classData)
    local rot = ns.rotations and ns.rotations[classData.token]
    local brackets = {}
    if rot then
        for _, b in ipairs(rot.debut or {}) do table.insert(brackets, b) end
        for _, b in ipairs(rot[specKey] or {}) do table.insert(brackets, b) end
    end
    local level = UnitLevel("player") or 1

    local lines = {
        GOLD .. T("Rotation – %s", D(spec.nom)) .. "|r",
        GREY .. T("Du haut vers le bas : lance le premier sort disponible. Survole une icône pour le détail.") .. "|r",
    }
    untranslatedNote(lines)
    for _, b in ipairs(brackets) do
        if inBracket(level, b[1], b[2]) then
            local chain = {}
            for i = 3, #b do table.insert(chain, inlineIcon(spellIcon(b[i].s, b[i].ic), 24)) end
            table.insert(lines, " ")
            table.insert(lines, GREEN .. T("Ton niveau (%d) : ", level) .. "|r" .. table.concat(chain, GREY .. "  >  |r"))
            break
        end
    end
    text:SetText(table.concat(lines, "\n"))

    local S = newStack(-(text:GetStringHeight() + 8))
    if #brackets == 0 then
        S.line(GREY .. T("Pas encore de rotation écrite pour cette spécialisation.") .. "|r", 6)
    end
    for _, b in ipairs(brackets) do
        local title = bracketTitle(b[1], b[2])
        if inBracket(level, b[1], b[2]) then
            S.line(GREEN .. "> " .. title .. "  " .. T("(ton niveau)") .. "|r", 12)
        else
            S.line(GOLD .. title .. "|r", 12)
        end
        for i = 3, #b do
            local e = b[i]
            local name = e.s and ns.SpellName(e.s, e.n) or e.n
            S.iconRow(spellIcon(e.s, e.ic),
                WHITE .. (i - 2) .. ".|r  |cff71d5ff" .. name .. "|r" .. (e.t and (GREY .. "  –  " .. e.t .. "|r") or ""),
                { spell = e.s, title = name })
        end
        for _, n in ipairs(b.notes or {}) do S.line("     " .. ORANGE .. "•|r " .. n) end
    end
    content:SetHeight(-S.y + 10)
end

local function refreshEnchants(classData, spec)
    local _, specKey = ns.GetSpec(classData)
    local key = ns.enchantsSpecs and ns.enchantsSpecs[classData.token] and ns.enchantsSpecs[classData.token][specKey]
    local P = key and ns.enchantsProfils and ns.enchantsProfils[key]
    local level = UnitLevel("player") or 1

    local lines = { GOLD .. T("Enchantements et consommables (%s)", D(spec.nom)) .. "|r" }
    if P then
        table.insert(lines, GREY .. T("Profil : %s. Bases de WoW Classic : WoW Forever ajoute des recettes, vérifie sur Wowhead.", P.nom) .. "|r")
    end
    untranslatedNote(lines)
    text:SetText(table.concat(lines, "\n"))

    local S = newStack(-(text:GetStringHeight() + 8))
    if not P then
        S.line(GREY .. T("Pas encore de liste pour cette spécialisation.") .. "|r", 6)
        content:SetHeight(-S.y + 10)
        return
    end

    local function enchantRows(list)
        for _, e in ipairs(list) do
            local tex = e.s and spellIcon(e.s, e.ic or "Trade_Engraving") or icon(e.ic or "Trade_Engraving")
            S.iconRow(tex, WHITE .. (D(e.e) or "") .. "|r  |cff1eff00" .. e.n .. "|r" ..
                (e.t and (GREY .. "  –  " .. e.t .. "|r") or ""), { spell = e.s, title = e.n, note = e.t })
        end
    end
    local function section(title, current)
        if current then S.line(GREEN .. "> " .. title .. "  " .. T("(ton niveau)") .. "|r", 12)
        else S.line(GOLD .. title .. "|r", 12) end
    end

    section(T("Enchantements pendant la montée"), level < 60)
    enchantRows(P.montee or {})
    section(T("Enchantements au niveau 60"), level >= 60)
    enchantRows(P.max or {})

    S.line(GOLD .. T("Consommables par tranche de niveau") .. "|r", 16)
    local hasMax = false
    for _, b in ipairs(P.compos or {}) do if b[1] == b[2] then hasMax = true end end
    for _, b in ipairs(P.compos or {}) do
        local title = bracketTitle(b[1], b[2])
        if inBracket(level, b[1], b[2], hasMax) then
            S.line("  " .. GREEN .. "> " .. title .. "  " .. T("(ton niveau)") .. "|r", 6)
        else
            S.line("  " .. WHITE .. title .. "|r", 6)
        end
        for i = 3, #b do
            local c = b[i]
            S.iconRow(itemIcon({ id = c.i }), "|cffffffff" .. ns.ItemName(c.i, c.n) .. "|r" ..
                (c.t and (GREY .. "  –  " .. c.t .. "|r") or ""), { item = c.i })
        end
    end
    content:SetHeight(-S.y + 10)
end

local function refreshScrollView(classData, spec)
    for _, r in ipairs(itemRows) do r:Hide() end
    for _, r in ipairs(zoneRows) do r:Hide() end
    if currentTab == "conseils" and conseilsMode() == "zones" then
        refreshZones()
        return
    end
    if currentTab == "conseils" and conseilsMode() == "rotation" then
        refreshRotation(classData, spec)
        return
    end
    if currentTab == "stuff" and subMode("stuff") == "enchants" then
        refreshEnchants(classData, spec)
        return
    end
    local lines = {}
    if currentTab == "stuff" then
        table.insert(lines, GOLD .. T("Priorité des statistiques (%s)", D(spec.nom)) .. "|r")
        if not spec.stats or #spec.stats == 0 then table.insert(lines, GREY .. T("  Pas encore disponible.") .. "|r") end
        for i, s in ipairs(spec.stats or {}) do table.insert(lines, "  " .. i .. ". " .. ns.Texte(s)) end
        table.insert(lines, " ")
        table.insert(lines, GOLD .. T("Meilleur équipement (BiS)") .. "|r")
        if not spec.objets or #spec.objets == 0 then
            table.insert(lines, GREY .. "  " .. T("Wowhead n'a pas encore rempli sa liste BiS pour WoW Forever. " ..
                "Elle apparaîtra ici automatiquement dès qu'elle sera publiée.") .. "|r")
        end
    else
        local liste = (ns.conseils and ns.conseils[classData.token]) or {}
        if ns.GetLang() == "en" and ns.conseilsEN and ns.conseilsEN[classData.token] then
            liste = ns.conseilsEN[classData.token]
        end
        if #liste == 0 then
            table.insert(lines, GREY .. T("Pas encore de conseils écrits pour cette classe. " ..
                "Le lien en bas de la fenêtre ouvre le guide Wowhead de ta spécialisation.") .. "|r")
        end
        local level = UnitLevel("player") or 1
        for i, c in ipairs(liste) do
            local titre = c:match("^##%s*(.+)$")
            if titre then
                -- Titre de catégorie : ligne vide avant (sauf en haut), en doré.
                if i > 1 then table.insert(lines, " ") end
                local a, b = titre:match("(%d+) à (%d+)")
                if not a then a, b = titre:match("(%d+) to (%d+)") end
                a, b = tonumber(a), tonumber(b)
                local shown = (a and b) and T("Niveaux %d à %d", a, b) or D(titre)
                if a and b and level >= a and (level < b or (b == 60 and level == 60)) then
                    table.insert(lines, GREEN .. "> " .. shown .. "  " .. T("(ton niveau)") .. "|r")
                else
                    table.insert(lines, GOLD .. shown .. "|r")
                end
            else
                table.insert(lines, "   • " .. c)
            end
        end
        table.insert(lines, " ")
        table.insert(lines, GREY .. T("Talents, stats et BiS : %s, mis à jour le %s.",
            D(classData.source or "?"), classData.majLe or "?") .. "|r")
        table.insert(lines, GREY .. "AideClasse v" .. ns.version .. "|r")
    end
    text:SetText(table.concat(lines, "\n"))
    local y = -(text:GetStringHeight() + 10)

    if currentTab == "stuff" then
        local currentSlot
        for i, o in ipairs(spec.objets or {}) do
            if o.emplacement ~= currentSlot then
                currentSlot = o.emplacement
                y = y - 8
            end
            local row = getItemRow(i)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
            row.itemID = o.id
            row.spellID, row.tipTitle, row.tipNote = nil, nil, nil
            row:SetHeight(30)
            row.icon:SetTexture(itemIcon(o))
            local status = itemIsEquipped(o.id) and (GREEN .. T("porté") .. "|r") or (ORANGE .. T("à chercher") .. "|r")
            local source = (o.source and o.source ~= "") and (GREY .. "  –  " .. ns.Texte(o.source) .. "|r") or ""
            row.text:SetText(WHITE .. (D(o.emplacement) or "") .. "|r  " .. GREY .. (D(o.rang) or "") .. "|r  " ..
                "|cffa335ee" .. ns.ItemName(o.id, o.nom) .. "|r  [" .. status .. "]" .. source)
            row:Show()
            y = y - 32
        end
    end
    content:SetHeight(-y + 10)
end

-- Fenêtre -------------------------------------------------------------------------

local function createFrame()
    frame = CreateFrame("Frame", "AideClasseFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(W, H)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetScript("OnHide", function() if buildMenu then buildMenu:Hide() end end)
    frame:Hide()
    tinsert(UISpecialFrames, "AideClasseFrame") -- fermeture avec Échap

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -5)

    -- Petit bouton de langue FR / EN, en haut à droite à côté de la croix.
    langButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    langButton:SetSize(30, 18)
    if frame.CloseButton then
        langButton:SetPoint("RIGHT", frame.CloseButton, "LEFT", 0, 0)
    else
        langButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -26, -2)
    end
    langButton:SetNormalFontObject("GameFontNormalSmall")
    langButton:SetHighlightFontObject("GameFontHighlightSmall")
    langButton:SetFrameLevel(frame:GetFrameLevel() + 5)
    langButton:SetScript("OnClick", function(self)
        ns.ToggleLang()
        if self:IsMouseOver() and self:GetScript("OnEnter") then self:GetScript("OnEnter")(self) end
    end)
    langButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
        GameTooltip:SetText(T("Changer de langue"))
        GameTooltip:AddLine(T("Interface en français. Clic : passer en anglais."), 1, 1, 1)
        GameTooltip:Show()
    end)
    langButton:SetScript("OnLeave", function() GameTooltip:Hide() end)

    for i, t in ipairs(TABS) do
        local b = makeButton(frame, t.label, 90)
        b:SetPoint("TOPLEFT", frame, "TOPLEFT", 12 + (i - 1) * 94, -30)
        b:SetScript("OnClick", function() ns.Show(t.key) end)
        tabButtons[t.key] = b
    end

    -- Une case par spécialisation (jusqu'à 4, ex. Druide farouche DPS et Tank).
    for i = 1, 4 do
        local b = CreateFrame("Button", nil, frame)
        b:SetSize(28, 28)
        b.icon = b:CreateTexture(nil, "ARTWORK")
        b.icon:SetAllPoints()
        b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        b.border = b:CreateTexture(nil, "BACKGROUND")
        b.border:SetPoint("TOPLEFT", -2, 2); b.border:SetPoint("BOTTOMRIGHT", 2, -2)
        b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        b:SetScript("OnClick", function(self) ns.SetSpec(self.key); if buildMenu then buildMenu:Hide() end; ns.Refresh() end)
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:SetText(self.nom or "")
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        specButtons[i] = b
    end
    frame.specLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")

    createTalentsView()

    scrollView = CreateFrame("Frame", nil, frame)
    scrollView:SetPoint("TOPLEFT", 14, -64)
    scrollView:SetPoint("BOTTOMRIGHT", -14, 44)
    -- Sous-onglets : Conseils (Classe / Rotation / Zones d'xp) et Stuff (Équipement / Enchants & compos).
    subBar = CreateFrame("Frame", nil, scrollView)
    subBar:SetPoint("TOPLEFT"); subBar:SetPoint("TOPRIGHT"); subBar:SetHeight(24)
    for tab, def in pairs(SUBTABS) do
        subButtons[tab] = {}
        for i, m in ipairs(def.modes) do
            local b = makeButton(subBar, m.label, 130)
            b:SetPoint("TOPLEFT", subBar, "TOPLEFT", (i - 1) * 134, 0)
            b:SetScript("OnClick", function()
                ns.db[def.db] = m.key
                scroll:SetVerticalScroll(0)
                ns.Refresh()
            end)
            b:Hide()
            subButtons[tab][m.key] = b
        end
    end

    scroll = CreateFrame("ScrollFrame", "AideClasseScroll", scrollView, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT")
    scroll:SetPoint("BOTTOMRIGHT", -20, 0)
    content = CreateFrame("Frame", nil, scroll)
    content:SetSize(contentW + 10, 10)
    scroll:SetScrollChild(content)
    text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT")
    text:SetWidth(contentW)
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    text:SetSpacing(3)

    -- Lien Wowhead à copier (Ctrl+C).
    linkLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    linkLabel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 16, 16)
    linkBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    linkBox:SetAutoFocus(false)
    linkBox:SetHeight(20)
    linkBox:SetPoint("LEFT", linkLabel, "RIGHT", 10, 0)
    linkBox:SetPoint("RIGHT", frame, "RIGHT", -30, 0)
    linkBox:SetFontObject("GameFontHighlightSmall")
    linkBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
    linkBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    linkBox:SetScript("OnTextChanged", function(self, userInput)
        if userInput then self:SetText(self.url or ""); self:HighlightText() end
    end)

    -- Redimensionnement : poignée en bas à droite (clic droit = taille par défaut).
    frame:SetResizable(true)
    if frame.SetResizeBounds then
        frame:SetResizeBounds(MIN_W, MIN_H, MAX_W, MAX_H)
    else
        frame:SetMinResize(MIN_W, MIN_H)
        frame:SetMaxResize(MAX_W, MAX_H)
    end
    local grip = CreateFrame("Button", nil, frame)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", -6, 6)
    grip:SetFrameLevel(frame:GetFrameLevel() + 10)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    grip:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            if buildMenu then buildMenu:Hide() end
            frame:StartSizing("BOTTOMRIGHT")
        end
    end)
    grip:SetScript("OnMouseUp", function(_, button)
        frame:StopMovingOrSizing()
        if button == "RightButton" then ns.ResetSize() return end
        if ns.db then ns.db.taille = { math.floor(frame:GetWidth() + 0.5), math.floor(frame:GetHeight() + 0.5) } end
        ns.Refresh()
    end)
    grip:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(T("Redimensionner"))
        GameTooltip:AddLine(T("Glisser : changer la taille de la fenêtre."), 1, 1, 1)
        GameTooltip:AddLine(T("Clic droit : taille par défaut."), 1, 1, 1)
        GameTooltip:Show()
    end)
    grip:SetScript("OnLeave", function() GameTooltip:Hide() end)

    frame:SetScript("OnSizeChanged", function() ns.Layout() end)
    local t = ns.db and ns.db.taille
    if t and t[1] and t[2] then
        frame:SetSize(math.max(MIN_W, math.min(MAX_W, t[1])), math.max(MIN_H, math.min(MAX_H, t[2])))
    end
    ns.Layout()
end

-- Adapte le contenu à la taille actuelle de la fenêtre.
function ns.Layout()
    if not frame then return end
    local fw, fh = frame:GetWidth(), frame:GetHeight()
    -- Talents : on garde la mise en page et on change l'échelle.
    local s = math.min((fw - 28) / TALENTS_W, (fh - 108) / TALENTS_H)
    talentsView.inner:SetScale(math.max(0.5, s))
    -- Stuff / Conseils : le texte suit la largeur.
    contentW = fw - 80
    content:SetWidth(contentW + 10)
    text:SetWidth(contentW)
    for _, r in ipairs(itemRows) do r:SetWidth(contentW) end
    for _, r in ipairs(zoneRows) do r:SetWidth(contentW); r.text:SetWidth(contentW - 90) end
end

function ns.ResetSize()
    if ns.db then ns.db.taille = nil end
    if not frame then return end
    frame:SetSize(W, H)
    ns.Layout()
    ns.Refresh()
end

-- Textes fixes de la fenêtre, à remettre quand la langue change.
local function updateStaticTexts()
    langButton:SetText(ns.GetLang() == "en" and "EN" or "FR")
    for _, t in ipairs(TABS) do tabButtons[t.key]:SetText(T(t.label)) end
    for tab, def in pairs(SUBTABS) do
        for _, m in ipairs(def.modes) do subButtons[tab][m.key]:SetText(T(m.label)) end
    end
    buildLabel:SetText(T("Build :"))
    linkLabel:SetText(T("Lien Wowhead :"))
end

function ns.OnLanguageChanged()
    if buildMenu then buildMenu:Hide() end
    ns.Refresh()
end

function ns.Refresh()
    if not frame or not frame:IsShown() then return end
    updateStaticTexts()
    local classData = ns.GetClassData()
    frame.title:SetText("AideClasse" .. (classData and (" – " .. D(classData.nom)) or ""))
    for key, b in pairs(tabButtons) do
        if key == currentTab then b:Disable() else b:Enable() end
    end

    -- Barre de sous-onglets, dans Conseils et Stuff.
    local mode = conseilsMode()
    scroll:ClearAllPoints()
    scroll:SetPoint("BOTTOMRIGHT", -20, 0)
    if SUBTABS[currentTab] then
        subBar:Show()
        scroll:SetPoint("TOPLEFT", 0, -30)
        local current = subMode(currentTab)
        for tab, buttons in pairs(subButtons) do
            for key, b in pairs(buttons) do
                if tab ~= currentTab then b:Hide()
                else
                    b:Show()
                    if key == current then b:Disable() else b:Enable() end
                end
            end
        end
    else
        subBar:Hide()
        scroll:SetPoint("TOPLEFT", 0, 0)
    end

    -- Les zones ne dépendent pas de la classe.
    if currentTab == "conseils" and mode == "zones" then
        talentsView:Hide(); scrollView:Show()
        for _, b in ipairs(specButtons) do b:Hide() end
        frame.specLabel:SetText("")
        refreshScrollView(classData, nil)
        if not (linkBox.url or ""):match("^/way") then
            linkBox.url = ZONES_URL
            linkBox:SetText(ZONES_URL)
            linkBox:SetCursorPosition(0)
        end
        return
    end

    if not classData then
        talentsView:Hide(); scrollView:Show()
        for _, b in ipairs(specButtons) do b:Hide() end
        text:SetText(T("%s : pas encore de données pour cette classe.\n\nLes données arrivent avec la mise à jour automatique depuis Wowhead.",
            GOLD .. (UnitClass("player") or "?") .. "|r"))
        return
    end

    local spec, specKey = ns.GetSpec(classData)
    local keys = ns.SpecKeys(classData)
    local count = math.min(#keys, #specButtons)
    for i, b in ipairs(specButtons) do
        local key = keys[i]
        local s = key and classData.specs[key]
        if s then
            b:ClearAllPoints()
            b:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -14 - (count - i) * 34, -28)
            if i == 1 then
                frame.specLabel:ClearAllPoints()
                frame.specLabel:SetPoint("RIGHT", b, "LEFT", -10, 0)
            end
            b.key, b.nom = key, D(s.nom)
            b.icon:SetTexture(icon(s.icone))
            b.icon:SetDesaturated(key ~= specKey)
            b.icon:SetAlpha(key == specKey and 1 or 0.6)
            if key == specKey then b.border:SetColorTexture(1, 0.82, 0, 1) else b.border:SetColorTexture(0.2, 0.2, 0.2, 1) end
            b:Show()
        else
            b:Hide()
        end
    end
    frame.specLabel:SetText(D(spec.nom))

    local build, bi, bn = ns.GetBuild(classData)
    if currentTab == "talents" then
        scrollView:Hide(); talentsView:Show()
        refreshTalents(classData, spec, build, bi, bn)
    else
        talentsView:Hide(); scrollView:Show()
        refreshScrollView(classData, spec)
    end

    local url = (currentTab == "talents" and build and build.lien) or spec.guide or ""
    linkBox.url = url
    linkBox:SetText(url)
    linkBox:SetCursorPosition(0)
end

function ns.Show(tab)
    if not frame then createFrame() end
    currentTab = tab or currentTab or (ns.db and ns.db.lastTab) or "talents"
    if ns.db then ns.db.lastTab = currentTab end
    if not frame:IsShown() or not viewLevel then
        viewLevel = math.max(10, math.min(60, UnitLevel("player") or 10))
    end
    frame:Show()
    slider:SetValue(viewLevel)
    scroll:SetVerticalScroll(0)
    ns.Refresh()
end

function ns.Toggle()
    if frame and frame:IsShown() then frame:Hide() else ns.Show() end
end

-- Infobulles : signale les objets BiS --------------------------------------------

local function onItemTooltip(tooltip, itemID)
    if not itemID then return end
    local classData = ns.GetClassData()
    if not classData then return end
    for _, spec in pairs(classData.specs) do
        for _, o in ipairs(spec.objets or {}) do
            if o.id == itemID then
                tooltip:AddLine(T("AideClasse : %s %s (%s)", D(o.rang or "BiS"), D(spec.nom), D(o.emplacement or "")), 0.58, 0.51, 0.79)
            end
        end
    end
end

function ns.HookTooltips()
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            if tooltip == GameTooltip or tooltip == ItemRefTooltip then
                onItemTooltip(tooltip, data and data.id)
            end
        end)
    elseif GameTooltip and GameTooltip.HookScript then
        local function handler(tooltip)
            local _, link = tooltip:GetItem()
            local id = link and tonumber(link:match("item:(%d+)"))
            onItemTooltip(tooltip, id)
        end
        pcall(GameTooltip.HookScript, GameTooltip, "OnTooltipSetItem", handler)
        if ItemRefTooltip then pcall(ItemRefTooltip.HookScript, ItemRefTooltip, "OnTooltipSetItem", handler) end
    end
end
