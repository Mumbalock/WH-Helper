-- WH Helper : traduction anglaise des textes de Data\Zones.lua (écrite à la main).
-- Clé = texte français exact de Zones.lua (nom de zone, nom de camp ou texte d'accès).
-- Si tu modifies un texte dans Zones.lua, mets aussi à jour sa clé ici, sinon il restera en français.
local _, ns = ...

ns.zonesEN = {
    -- Zones
    ["Forêt d'Elwynn"] = "Elwynn Forest",
    ["Dun Morogh"] = "Dun Morogh",
    ["Teldrassil"] = "Teldrassil",
    ["Durotar"] = "Durotar",
    ["Mulgore"] = "Mulgore",
    ["Clairières de Tirisfal"] = "Tirisfal Glades",
    ["Île de Zephras"] = "Isle of Zephras",
    ["Marche de l'Ouest"] = "Westfall",
    ["Loch Modan"] = "Loch Modan",
    ["Sombrivage"] = "Darkshore",
    ["Les Tarides"] = "The Barrens",
    ["Forêt des Pins-Argentés"] = "Silverpine Forest",
    ["Les Carmines"] = "Redridge Mountains",
    ["Les Serres-Rocheuses"] = "Stonetalon Mountains",
    ["Bois de la Pénombre"] = "Duskwood",
    ["Les Paluns"] = "Wetlands",
    ["Orneval"] = "Ashenvale",
    ["Contreforts de Hautebrande"] = "Hillsbrad Foothills",
    ["Mille pointes"] = "Thousand Needles",
    ["Montagnes d'Alterac"] = "Alterac Mountains",
    ["Hautes-terres d'Arathi"] = "Arathi Highlands",
    ["Désolace"] = "Desolace",
    ["Vallée de Strangleronce"] = "Stranglethorn Vale",
    ["Marécage d'Âprefange"] = "Dustwallow Marsh",
    ["Rives claires (Riverglades)"] = "Riverglades",
    ["Terres ingrates"] = "Badlands",
    ["Marais des Chagrins"] = "Swamp of Sorrows",
    ["Tanaris"] = "Tanaris",
    ["Féralas"] = "Feralas",
    ["Les Hinterlands"] = "The Hinterlands",
    ["Azshara"] = "Azshara",
    ["Gorge des Vents brûlants"] = "Searing Gorge",
    ["Gangrebois"] = "Felwood",
    ["Maleterres de l'Ouest"] = "Western Plaguelands",
    ["Cratère d'Un'Goro"] = "Un'Goro Crater",
    ["Terres foudroyées"] = "Blasted Lands",
    ["Steppes ardentes"] = "Burning Steppes",
    ["Maleterres de l'Est"] = "Eastern Plaguelands",
    ["Berceau-de-l'Hiver"] = "Winterspring",
    ["Silithus"] = "Silithus",

    -- Camps et lieux de quêtes
    ["Comté-de-l'Or"] = "Goldshire",
    ["Kharanos"] = "Kharanos",
    ["Dolanaar"] = "Dolanaar",
    ["Tranchecolline"] = "Razor Hill",
    ["Village de Sabot-de-Sang"] = "Bloodhoof Village",
    ["Brill"] = "Brill",
    ["Colline des Sentinelles"] = "Sentinel Hill",
    ["Thelsamar"] = "Thelsamar",
    ["Auberdine"] = "Auberdine",
    ["La Croisée"] = "The Crossroads",
    ["Le Sépulcre"] = "The Sepulcher",
    ["Comté-du-Lac"] = "Lakeshire",
    ["Pic des Serres-Rocheuses"] = "Stonetalon Peak",
    ["Retraite de Roche-Soleil"] = "Sun Rock Retreat",
    ["Sombre-Comté"] = "Darkshire",
    ["Port de Menethil"] = "Menethil Harbor",
    ["Astranaar"] = "Astranaar",
    ["Poste de Bois-Brisé"] = "Splintertree Post",
    ["Austrivage"] = "Southshore",
    ["Moulin-de-Tarren"] = "Tarren Mill",
    ["Poste de Librevent"] = "Freewind Post",
    ["Course de Mirage (neutre)"] = "Mirage Raceway (neutral)",
    ["Refuge de l'Ornière"] = "Refuge Pointe",
    ["Trépas-d'Orgrim"] = "Hammerfall",
    ["Pic de Nijel"] = "Nijel's Point",
    ["Village de Proie-de-l'Ombre"] = "Shadowprey Village",
    ["Camp rebelle"] = "Rebel Camp",
    ["Campement Grom'gol"] = "Grom'gol Base Camp",
    ["Baie-du-Butin (neutre)"] = "Booty Bay (neutral)",
    ["Theramore"] = "Theramore",
    ["Village de Mur-de-Fougères"] = "Brackenwall Village",
    ["Kargath"] = "Kargath",
    ["Pierrêche"] = "Stonard",
    ["Gadgetzan (neutre)"] = "Gadgetzan (neutral)",
    ["Bastion de Plumelune"] = "Feathermoon Stronghold",
    ["Camp Mojache"] = "Camp Mojache",
    ["Nid-de-l'Aigle"] = "Aerie Peak",
    ["Village de Revantusk"] = "Revantusk Village",
    ["Pointe de Talrendis"] = "Talrendis Point",
    ["Valormok"] = "Valormok",
    ["Halte du Thorium (neutre)"] = "Thorium Point (neutral)",
    ["Clairière de Griffebranche"] = "Talonbranch Glade",
    ["Poste de Vengebroc"] = "Bloodvenom Post",
    ["Camp du Noroît"] = "Chillwind Camp",
    ["Le Rempart (dans Tirisfal)"] = "The Bulwark (in Tirisfal)",
    ["Refuge des Marshal (neutre)"] = "Marshal's Refuge (neutral)",
    ["Rempart-du-Néant"] = "Nethergarde Keep",
    ["Veille de Morgan"] = "Morgan's Vigil",
    ["Crête des flammes"] = "Flame Crest",
    ["Chapelle de l'Espoir de Lumière"] = "Light's Hope Chapel",
    ["Long-Guet (neutre)"] = "Everlook (neutral)",
    ["Fort Cénarien (neutre)"] = "Cenarion Hold (neutral)",

    -- Accès
    ["Zone de départ des humains, juste au sud de Hurlevent."] =
        "Human starting zone, just south of Stormwind.",
    ["Zone de départ des nains et gnomes. Depuis Hurlevent : Tram des profondeurs vers Forgefer."] =
        "Dwarf and gnome starting zone. From Stormwind: Deeprun Tram to Ironforge.",
    ["Zone de départ des elfes de la nuit. Bateau d'Auberdine (Sombrivage) vers Rut'theran."] =
        "Night elf starting zone. Boat from Auberdine (Darkshore) to Rut'theran.",
    ["Zone de départ des orcs et trolls, juste au sud d'Orgrimmar."] =
        "Orc and troll starting zone, just south of Orgrimmar.",
    ["Zone de départ des taurens. Depuis Orgrimmar : traverse les Tarides vers le sud-ouest."] =
        "Tauren starting zone. From Orgrimmar: cross the Barrens to the southwest.",
    ["Zone de départ des Réprouvés. Depuis Orgrimmar : zeppelin vers Fossoyeuse (tour à l'ouest de la ville)."] =
        "Forsaken starting zone. From Orgrimmar: zeppelin to Undercity (tower west of the city).",
    ["Zone de départ des Skyborne (édition avec le pack). Pour en partir : bateau du quai de Valanaar vers Dalaran, puis portail vers Hurlevent (Alliance) ou Orgrimmar (Horde)."] =
        "Skyborne starting zone (edition with the pack). To leave: boat from Valanaar dock to Dalaran, then portal to Stormwind (Alliance) or Orgrimmar (Horde).",
    ["À l'ouest d'Elwynn : suis la route depuis Comté-de-l'Or vers l'ouest."] =
        "West of Elwynn: follow the road west from Goldshire.",
    ["À l'est de Dun Morogh : prends le tunnel au nord-est de Dun Morogh."] =
        "East of Dun Morogh: take the tunnel in the northeast of Dun Morogh.",
    ["Depuis Teldrassil : bateau de Rut'theran. Depuis les Royaumes de l'Est : bateau de Menethil (Les Paluns)."] =
        "From Teldrassil: boat from Rut'theran. From the Eastern Kingdoms: boat from Menethil (Wetlands).",
    ["À l'ouest de Durotar : sors d'Orgrimmar vers l'ouest, La Croisée est au centre."] =
        "West of Durotar: leave Orgrimmar to the west, the Crossroads are in the middle.",
    ["Au sud de Tirisfal : suis la route vers le sud depuis Brill."] =
        "South of Tirisfal: follow the road south from Brill.",
    ["À l'est d'Elwynn : suis la route vers l'est depuis Comté-de-l'Or."] =
        "East of Elwynn: follow the road east from Goldshire.",
    ["Zone surtout Alliance : peu de quêtes pour la Horde."] =
        "Mostly an Alliance zone: few quests for the Horde.",
    ["Depuis Sombrivage, descends vers le sud par Orneval ; le camp Alliance est tout au nord de la zone."] =
        "From Darkshore, head south through Ashenvale; the Alliance camp is at the far north of the zone.",
    ["Depuis les Tarides : route vers l'ouest au nord de La Croisée."] =
        "From the Barrens: road west, north of the Crossroads.",
    ["Au sud d'Elwynn : route vers le sud depuis Comté-de-l'Or, puis vers l'est."] =
        "South of Elwynn: road south from Goldshire, then east.",
    ["Au nord du Loch Modan par la route (attention aux élites de Dun Algaz), ou bateau d'Auberdine."] =
        "North of Loch Modan by road (watch out for the elites in Dun Algaz), or boat from Auberdine.",
    ["Au sud de Sombrivage par la route."] =
        "South of Darkshore by road.",
    ["Au nord des Tarides : route vers le nord depuis La Croisée."] =
        "North of the Barrens: road north from the Crossroads.",
    ["Au nord des Paluns par le pont de Thandol."] =
        "North of the Wetlands via Thandol Span.",
    ["Au sud-est des Pins-Argentés par la route."] =
        "Southeast of Silverpine by road.",
    ["Au sud des Tarides ; pas de base Alliance, les gobelins de la Course de Mirage sont neutres."] =
        "South of the Barrens; no Alliance base, the goblins at Mirage Raceway are neutral.",
    ["Au sud des Tarides : descends la Grande Élévation."] =
        "South of the Barrens: go down the Great Lift.",
    ["Au nord de Hautebrande, au-dessus d'Austrivage."] =
        "North of Hillsbrad, above Southshore.",
    ["Au nord de Hautebrande, au-dessus du Moulin-de-Tarren."] =
        "North of Hillsbrad, above Tarren Mill.",
    ["Au nord des Paluns, ou à l'est de Hautebrande."] =
        "North of the Wetlands, or east of Hillsbrad.",
    ["À l'est de Hautebrande par la route."] =
        "East of Hillsbrad by road.",
    ["Au sud des Serres-Rocheuses ; le camp Alliance est au nord."] =
        "South of Stonetalon; the Alliance camp is in the north.",
    ["Au sud des Serres-Rocheuses ; le camp Horde est au sud-ouest."] =
        "South of Stonetalon; the Horde camp is in the southwest.",
    ["Au sud du Bois de la Pénombre par la route."] =
        "South of Duskwood by road.",
    ["Zeppelin depuis la tour à l'extérieur d'Orgrimmar (ou de Fossoyeuse) vers Grom'gol."] =
        "Zeppelin from the tower outside Orgrimmar (or Undercity) to Grom'gol.",
    ["Bateau de Menethil (Les Paluns) vers Theramore."] =
        "Boat from Menethil (Wetlands) to Theramore.",
    ["À l'est des Tarides, au sud de La Croisée."] =
        "East of the Barrens, south of the Crossroads.",
    ["Par la route : remonte Les Carmines vers le nord et prends à droite avant les Steppes ardentes."] =
        "By road: go north through Redridge and turn right before the Burning Steppes.",
    ["Bateau de Tanaris vers Port-Poudrefuse, puis vol depuis Rog'mar les fois suivantes."] =
        "Boat from Tanaris to Port-Poudrefuse, then fly from Rog'mar on later trips.",
    ["Au sud du Loch Modan ; pas de base Alliance."] =
        "South of Loch Modan; no Alliance base.",
    ["Kargath est à l'ouest de la zone (vol, ou à pied depuis le Loch Modan)."] =
        "Kargath is in the west of the zone (flight, or on foot from Loch Modan).",
    ["À l'est du Bois de la Pénombre par le Défilé de Deuillevent ; pas de base Alliance."] =
        "East of Duskwood through Deadwind Pass; no Alliance base.",
    ["Depuis Grom'gol, remonte vers le nord-est par le Défilé de Deuillevent."] =
        "From Grom'gol, head northeast through Deadwind Pass.",
    ["Au sud de Mille pointes. Gadgetzan est une ville gobeline neutre au nord."] =
        "South of Thousand Needles. Gadgetzan is a neutral goblin town in the north.",
    ["Au sud de Désolace ; le bastion est sur une île, bateau depuis la côte ouest."] =
        "South of Desolace; the stronghold is on an island, boat from the west coast.",
    ["Au sud de Désolace ou à l'ouest de Mille pointes ; le camp est à l'est."] =
        "South of Desolace or west of Thousand Needles; the camp is in the east.",
    ["Au nord-est de Hautebrande ; Nid-de-l'Aigle est à l'ouest."] =
        "Northeast of Hillsbrad; Aerie Peak is in the west.",
    ["Au nord-est de Hautebrande ; Revantusk est au sud-est."] =
        "Northeast of Hillsbrad; Revantusk is in the southeast.",
    ["À l'est d'Orneval, par la route."] =
        "East of Ashenvale, by road.",
    ["Entre les Terres ingrates et les Steppes ardentes ; on y entre par le Mont Rochenoire."] =
        "Between the Badlands and the Burning Steppes; you enter through Blackrock Mountain.",
    ["Au nord d'Orneval, par la route."] =
        "North of Ashenvale, by road.",
    ["Au nord de Hautebrande ; le camp est au sud de la zone."] =
        "North of Hillsbrad; the camp is in the south of the zone.",
    ["Le Rempart est à l'est des Clairières de Tirisfal, à la frontière."] =
        "The Bulwark is in the east of Tirisfal Glades, on the border.",
    ["Au sud-ouest de Tanaris, par la rampe à l'ouest de la zone."] =
        "Southwest of Tanaris, via the ramp in the west of the zone.",
    ["Au sud du Marais des Chagrins."] =
        "South of the Swamp of Sorrows.",
    ["Au nord des Carmines ; la Veille de Morgan est au sud-est."] =
        "North of Redridge; Morgan's Vigil is in the southeast.",
    ["Par le Mont Rochenoire depuis la Gorge des Vents brûlants."] =
        "Through Blackrock Mountain from Searing Gorge.",
    ["À l'est des Maleterres de l'Ouest ; la chapelle (neutre) est à l'est."] =
        "East of the Western Plaguelands; the chapel (neutral) is in the east.",
    ["Au nord-est de Gangrebois, par la route de la Passe de Grumegueule."] =
        "Northeast of Felwood, via the road through Timbermaw Hold.",
    ["Au sud-ouest d'Un'Goro."] =
        "Southwest of Un'Goro.",
}

-- Texte de Zones.lua dans la langue choisie (français tel quel, sinon la traduction si elle existe).
function ns.ZT(s)
    if not s or not ns.GetLang or ns.GetLang() ~= "en" then return s end
    return ns.zonesEN[s] or s
end
