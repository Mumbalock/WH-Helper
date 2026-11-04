-- WH Helper : bouton autour de la minimap (clic = ouvrir, glisser = déplacer)
local _, ns = ...

local button
local RADIUS = 80

local function updatePosition()
    local angle = math.rad(ns.db.minimap.angle or 225)
    button:ClearAllPoints()
    button:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * RADIUS, math.sin(angle) * RADIUS)
end

local function onDragUpdate()
    local mx, my = Minimap:GetCenter()
    local cx, cy = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    cx, cy = cx / scale, cy / scale
    ns.db.minimap.angle = math.deg(math.atan2(cy - my, cx - mx)) % 360
    updatePosition()
end

function ns.CreateMinimapButton()
    if button or not Minimap then return end

    button = CreateFrame("Button", "WHHelperMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:RegisterForDrag("LeftButton")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    bg:SetSize(20, 20)
    bg:SetPoint("TOPLEFT", 7, -5)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    icon:SetSize(17, 17)
    icon:SetPoint("TOPLEFT", 7, -6)
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(53, 53)
    border:SetPoint("TOPLEFT")

    button:SetScript("OnClick", function(_, mouseButton)
        if mouseButton == "RightButton" then
            ns.Show("stuff")
        else
            ns.Toggle()
        end
    end)
    button:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", onDragUpdate)
    end)
    button:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("WH Helper")
        GameTooltip:AddLine(ns.T("Clic gauche : ouvrir / fermer"), 1, 1, 1)
        GameTooltip:AddLine(ns.T("Clic droit : onglet Stuff"), 1, 1, 1)
        GameTooltip:AddLine(ns.T("Glisser : déplacer l'icône"), 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)

    ns.UpdateMinimapButton()
end

function ns.UpdateMinimapButton()
    if not button then return end
    updatePosition()
    if ns.db.minimap.hide then button:Hide() else button:Show() end
end
