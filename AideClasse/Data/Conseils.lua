-- Conseils écrits à la main (ce fichier n'est PAS remplacé par la mise à jour automatique).
-- Sources : guides « Leveling Tips » de Wowhead pour WoW Forever (lus le 4 nov. 2026, toutes les spés)
-- et, pour le Démoniste, le guide de montée en niveau de Method.gg (3 nov. 2026).
--
-- Format : une ligne = un conseil. Une ligne qui commence par « ## » est un titre de catégorie.
-- Les titres « ## Niveaux A à B » sont mis en avant quand le personnage est dans cette tranche.
-- Pas de guillemets doubles dans les textes (le simulateur les relit).
local _, ns = ...

ns.conseils = ns.conseils or {}

ns.conseils.WARRIOR = {
    "## Conseils généraux",
    "Classe la plus dure à monter : ton pire ennemi, ce sont les pauses pour manger.",
    "Grouper avec un soigneur change tout : tu peux enchaîner les monstres sans t'arrêter.",
    "Protection est la meilleure spé de montée jusqu'au niveau 35-40, même si tu vises Armes ou Fureur.",
    "Change d'arme dès que possible : c'est la classe qui profite le plus d'une nouvelle arme.",
    "Tue tout ce qui croise ta route, et avance déjà vers la cible suivante pendant le combat.",
    "En danger : Hurlement perçant ou Cri d'intimidation pour fuir. Mourir fait perdre tes buffs.",

    "## Niveaux 1 à 10",
    "Apprends Pourfendre (niv. 4) et garde-le sur chaque cible.",
    "Si ta zone de départ ne donne pas d'arme correcte, achète un Coutelas chez un marchand.",
    "Pierre à aiguiser grossière sur ton arme : gros gain de dégâts au début.",

    "## Niveaux 10 à 20",
    "Fulgurance au niveau 12 : à apprendre absolument.",
    "Niveau 16 : Maîtrise du blocage et Vengeance, le Guerrier devient bien plus fort.",
    "Fais Gouffre de Ragefeu avec toutes ses quêtes : la Hache d'Orgrimmar est devenue un objet bleu.",

    "## Niveaux 20 à 30",
    "Ivresse de la victoire (niv. 20) : un soin à lancer dès que tu passes sous 90 % de vie.",
    "Enchaînement (niv. 20) pour les groupes de monstres.",

    "## Niveaux 30 à 40",
    "Interception (niv. 30) : une deuxième charge, idéale pour enchaîner les cibles.",
    "Pas besoin d'économiser chaque pièce pour la monture du 40 : l'or arrive plus vite ensuite.",

    "## Niveaux 40 à 60",
    "Armes : Frappe mortelle au niveau 40, le plus gros palier de la spé.",
    "Témérité au niveau 50.",
    "Armes à viser : Épée du vainqueur (Souilles de Tranchebauge), puis Lame de rossée (quête de Maraudon).",

    "## Rotation",
    "Armes : Ivresse de la victoire sous 90 % > Pourfendre > Fulgurance > Frappe mortelle > Heurtoir > Frappe héroïque.",
    "Frappe héroïque seulement au-dessus de 40 de rage : elle supprime la rage de ton coup blanc.",
    "Armes en solo : évite Exécution, garde plutôt ta rage pour le monstre suivant.",
    "Armes contre plusieurs : accumule de la rage, Attaques circulaires + Frappe mortelle, puis Tourbillon.",
    "Fureur : Sanguinaire, Pourfendre si le monstre vivra assez, Exécution pour finir, Enchaînement au-dessus de 60 de rage.",
    "Protection : Maîtrise du blocage, Vengeance, Heurtoir de bouclier si tu l'as, Frappe héroïque au-dessus de 30 de rage.",
    "Plusieurs monstres : Cri démoralisant + Coup de tonnerre réduisent leurs dégâts de 30 à 40 %.",
    "Contre les lanceurs de sorts : Coup de bouclier, pour les couper et générer de la rage.",

    "## Talents et sorts à apprendre",
    "Armes : Fulgurance améliorée, Bloodthrill, Heurtoir amélioré, Frappe mortelle et Enrager sont les gros paliers.",
    "Armes : n'utilise pas Heurtoir avant d'avoir Heurtoir amélioré.",
    "Fureur : Gore Drinker et Sanguinaire en premier (ta survie), puis Rafale, puis Déviation chez Armes.",
    "Protection : Spécialisation bouclier, Vengeance améliorée et Maître de la défense en premier.",
    "Sorts à sauter si l'or manque : Coup de tonnerre, Brise-genou, Cri démoralisant, Coup railleur.",

    "## Métiers, camp et consommables",
    "Métiers : Forge + Minage. La Forge a de nouvelles recettes de montée ; tu peux fondre du minerai de 1 à 300.",
    "Camp : Tente (repos), Pierre d'aimant (puissance d'attaque), Meule (Force), Chaise (2 % de critique).",
    "Mange toujours un plat avec buff : +5 % d'expérience sur les monstres tués.",
    "Garde des potions de soins : elles évitent de longs retours depuis le cimetière.",
    "Fais chaque donjon une fois avec toutes ses quêtes : l'expérience est dans les quêtes.",
}

ns.conseils.PALADIN = {
    "## Conseils généraux",
    "Classe très solide : armure lourde et soins sur toi. Elle meurt très rarement.",
    "Soigne-toi au lieu de manger : remonte ta vie avec tes sorts, puis bois pour la mana.",
    "Garde Imposition des mains et Bouclier divin pour les urgences.",
    "Pas de tir à distance ni d'interruption : tu marches jusqu'à chaque cible.",
    "Sacré : spé de groupe et de donjon, lente en solo.",

    "## Niveaux 1 à 10",
    "Sceau de piété dès le niveau 1, Frappe sacrée au niveau 6.",

    "## Niveaux 10 à 20",
    "Bénédiction de sagesse (niv. 14) : le rang 1 suffit.",
    "Premiers talents : Bénédiction (sceaux et jugements moins chers) puis Poursuite de la justice.",

    "## Niveaux 20 à 30",
    "Consécration et Exorcisme arrivent au niveau 20.",
    "Poursuite de la justice 2/2 au niveau 21 : tu cours plus vite.",
    "Vindicte : Sceau d'autorité dès que possible, gros gain de dégâts au début du combat.",

    "## Niveaux 30 à 40",
    "Vindicte : Champion of the Light vers le niveau 35-37.",
    "Protection : tu peux réinitialiser au 30 pour Bouclier sacré si tu tankes beaucoup.",

    "## Niveaux 40 à 60",
    "Ta monture est gratuite (Tome de noblesse) : garde l'or pour tes sorts ou une bonne arme.",
    "Marteau de courroux (44) et Colère divine (50) : à sauter sauf talent ou donjons de morts-vivants.",
    "Retarde Unsealed Wrath : il coûte de la mana pour peu de dégâts.",

    "## Rotation",
    "Avant le pull : Sceau du Croisé puis Jugement sur les cibles qui vont durer, puis Sceau d'autorité.",
    "Vindicte : garde ton sceau, Jugement et Frappe sacrée à chaque recharge.",
    "Marteau de courroux sous 20 % de vie, Exorcisme sur morts-vivants et démons.",
    "Consécration seulement si la mana le permet.",
    "Étourdis (Marteau de la justice ou Repentir) puis Jugement : Sceau d'autorité fait double dégâts.",
    "Avec Twist of Light : alterne Sceau d'autorité et Sceau de piété à chaque coup d'arme.",
    "Protection : Fureur vertueuse et Aura de vindicte avant le combat, Consécration et Bouclier sacré posés d'avance.",
    "Règle des 5 secondes : Jugement est hors temps de recharge global, lance-le avec Frappe sacrée.",

    "## Talents et sorts à apprendre",
    "Vindicte : Bénédiction, Poursuite de la justice, Sceau d'autorité, puis Sanctified Judgement (mana).",
    "Prends une arme à deux mains lente avec Sceau d'autorité.",
    "Sceau de justice et Sceau de fureur sont inutiles en solo Vindicte.",
    "Sorts utilitaires (Bénédiction de protection, Purification…) : le rang 1 suffit.",

    "## Métiers, camp et consommables",
    "Métiers : Forge + Minage, seule source de plaques avec puissance des sorts au début.",
    "Monte aussi Secourisme (potions de soins) et Cuisine (plats avec bonus d'expérience).",
    "Les buffs de camp ne s'ajoutent pas à tes bénédictions : Pierre d'aimant = Puissance, Bocal à poissons = Rois.",
    "Mange toujours un plat avec buff : +5 % d'expérience sur les monstres tués.",
    "Garde des potions de mana : manquer de mana est ton seul vrai point faible.",
    "Fais chaque donjon une fois avec toutes ses quêtes.",
}

ns.conseils.HUNTER = {
    "## Conseils généraux",
    "Probablement la classe la plus facile à monter : ton familier tanke et tu peux kiter.",
    "Tes tirs ne sont pas pénalisés contre les monstres de niveau supérieur.",
    "Bête est la meilleure spé de montée.",
    "Réapprovisionne-toi en flèches ou balles à chaque village.",
    "Garde de la nourriture pour ton familier : s'il meurt, son bonheur et ses dégâts baissent.",
    "Feindre la mort te sort d'un combat raté.",

    "## Niveaux 1 à 10",
    "Morsure de serpent (niv. 4) et Tir des arcanes (niv. 6).",
    "Aspect du faucon au niveau 10.",

    "## Niveaux 10 à 20",
    "Guérison du familier (niv. 12) : protège ton familier, le relever coûte très cher en temps.",
    "Apprends Griffe : capture un Crabe cliquetant, un Crabe de rivage, le Patriarche ours noir ou la Mère de la tanière.",
    "Piège d'immolation au niveau 16.",

    "## Niveaux 20 à 30",
    "Aspect du guépard au niveau 20 : tu te déplaces beaucoup plus vite.",
    "Tir visé au niveau 20.",
    "Cherche un rang supérieur de Griffe et Morsure tous les 10 niveaux environ.",

    "## Niveaux 30 à 40",
    "Aura de précision dès le niveau 30.",
    "Survie : ne la joue pas avant le niveau 32 (Strider Kick et Expose Prey).",

    "## Niveaux 40 à 60",
    "Salve au niveau 40 : ta zone devient bien plus simple.",

    "## Rotation",
    "Marque du chasseur > Morsure de serpent si le combat dure > Tir des arcanes.",
    "Avec Summon Hawk : Tir des arcanes seulement une rotation sur trois.",
    "Kite avec Trait de choc, Coupure d'ailes et Piège givrant.",
    "Zone avant 40 : Piège explosif au corps à corps, puis Flèches multiples.",
    "Zone après 40 : Flèches multiples jusqu'à 4 cibles, sinon Salve sur toute sa durée.",
    "Survie : garde Attaque du raptor en file, Morsure de la mangouste dès qu'elle s'allume.",

    "## Talents et sorts à apprendre",
    "Bête : remplis l'arbre Maîtrise des bêtes de haut en bas, puis Précision.",
    "Pas de Loup solitaire en montée : tu as besoin du familier.",
    "Précision : Sniper Shot coûte trop de mana, attends le niveau max.",
    "Pistage des bêtes et des humanoïdes, Aspect du singe : utiles mais optionnels.",

    "## Métiers, camp et consommables",
    "Métiers : Dépeçage + Travail du cuir. Le Cuir a de nouveaux objets bleus très forts.",
    "Exemples : Bottes en cuir sombre, Ceinture de trappeur.",
    "Garde le tissu pour le Secourisme et fais des bandages en ville.",
    "Mange un plat avec buff : +5 % d'expérience, idéalement avec Agilité ou puissance d'attaque.",
    "Garde des potions de soins de ton niveau.",
}

ns.conseils.ROGUE = {
    "## Conseils généraux",
    "Commence chaque combat avec la barre d'énergie pleine : tes dégâts sont concentrés au début.",
    "Pas de soin : bandages et nourriture obligatoires.",
    "Énergie basse : Suriner, recule, laisse l'énergie remonter et reprends.",
    "Camouflage + Assommer : ramasse les objets de quête sans te battre.",
    "Ajoute Vol à la tire à ta macro d'ouverture pour gagner de l'or en route.",

    "## Niveaux 1 à 10",
    "Attaque pernicieuse et Éviscération dès le niveau 1. Attaque sournoise au niveau 4.",

    "## Niveaux 10 à 20",
    "Premiers talents : Frappes efficaces et Attaques impitoyables (+40 % de critique après une victime).",
    "Finesse : dès Embuscade (niv. 18), réinitialise pour renforcer ton ouverture.",

    "## Niveaux 20 à 30",
    "Fais la quête des poisons (Tour de Klaven / Mission : possible mais pas probable) : elle donne aussi le Thé au chardon.",
    "Combat : au niveau 20, réinitialise pour prendre Riposte.",
    "Disparition au niveau 22 : ta sortie de secours.",

    "## Niveaux 30 à 40",
    "Assassinat : Mutilation au niveau 30, la spé devient enfin intéressante.",
    "Quêtes furtives : Corne de Xelthos (bague) et Œil de Bhossca (Lame ornée de rubis).",

    "## Niveaux 40 à 60",
    "Monture au niveau 40 : prévois l'or avec un métier de récolte ou le Vol à la tire.",

    "## Rotation",
    "Combat : Attaque pernicieuse en boucle, Éviscération pour achever.",
    "Débiter seulement si un autre monstre est à côté.",
    "Finesse : Embuscade, puis Hémorragie (ou Attaque pernicieuse), Éviscération pour achever.",
    "Riposte : hors temps de recharge global, peu chère, désarme 6 s.",

    "## Talents et sorts à apprendre",
    "Combat : Riposte, puis Attaques impitoyables, Réflexes éclair et Déviation.",
    "Assassinat : jusqu'au 30, mêmes talents que Combat, puis Mutilation et talents de poisons.",
    "Finesse : Embuscade améliorée, puis Maître du déguisement et Camouflage.",

    "## Poisons et donjons",
    "Poison instantané pour les dégâts, Poison affaiblissant contre les fuyards.",
    "Poison de distraction mentale contre les lanceurs de sorts.",
    "En donjon : Sprint + Coup de pied sur les lanceurs de sorts à l'arrière.",
    "Suriner et Aiguillon perfide pour couper les sorts. Crochète les coffres pour le groupe.",

    "## Métiers, camp et consommables",
    "Métiers : deux métiers de récolte pour l'or, ou un artisanat pour ton équipement.",
    "Consommables d'Agilité, pierres à aiguiser et poisons sur les armes.",
    "Camp : Chaise (critique), Meule (Force), Pierre d'aimant (puissance d'attaque).",
    "Mange toujours un plat avec buff : +5 % d'expérience sur les monstres tués.",
}

ns.conseils.PRIEST = {
    "## Conseils généraux",
    "Ombre : la plus rapide en solo. Discipline : presque intuable, excellente en donjon. Sacré : réservé aux groupes.",
    "La baguette est ta meilleure arme jusqu'au niveau 40 environ.",
    "Mot de pouvoir : Bouclier avant de tirer : il absorbe les coups et empêche le recul de tes sorts.",
    "Bois tous les 1 à 2 monstres. Garde 3 piles de 20 boissons.",
    "Pas de sort de déplacement avant la monture du 40 : prévois les trajets.",

    "## Niveaux 1 à 10",
    "Châtiment pour commencer, Soins inférieurs entre deux monstres.",
    "Mot de l'ombre : Douleur au niveau 4 : à lancer en premier.",
    "Baguette de novice dès le niveau 1, puis Baguette magique inférieure au niveau 5.",

    "## Niveaux 10 à 20",
    "Spécialisation Baguette 2/2 au niveau 10 : le plus gros gain de dégâts.",
    "Feu intérieur (niv. 12), Baguette magique supérieure (niv. 13).",
    "Guérison des maladies (14) et Dissipation de la magie (18).",

    "## Niveaux 20 à 30",
    "Gros retour chez le maître au niveau 20 : Soins rapides, Flammes sacrées, Fouet mental, Peste dévorante.",
    "Discipline : Méditation vers le niveau 20, la mana remonte même en lançant des sorts.",

    "## Niveaux 30 à 40",
    "Niveau 30 : Esprit divin pour tous, Pénitence pour Discipline.",
    "Mot de l'ombre : Mort au niveau 32 : un bon sort pour achever.",

    "## Niveaux 40 à 60",
    "Ombre : Forme d'ombre au niveau 40, le gros palier. Réinitialise si tu montais en Discipline.",
    "Discipline : vers le niveau 41, les sorts dépassent la baguette (Flammes sacrées, Pénitence, Châtiment).",
    "Sacré : Soins supérieurs au niveau 40, Prière de guérison vers 40-45.",

    "## Rotation",
    "Garde Mot de pouvoir : Robustesse, Feu intérieur et Esprit divin.",
    "Solo : Bouclier, Mot de l'ombre : Douleur ou Attaque mentale, puis baguette.",
    "Discipline : ouvre avec Pénitence si personne d'autre ne vise le monstre.",
    "Ombre : Attaque mentale, Mot de l'ombre : Douleur, Fouet mental si la mana le permet, baguette pour finir.",
    "Ombre contre plusieurs : Mot de l'ombre : Douleur sur chaque cible.",
    "Inutile de remettre un DoT sur un monstre presque mort.",
    "Donjon : Bouclier et Rénovation sur le tank, Soins, Soins rapides en urgence.",
    "Oubli si tu prends l'aggro.",

    "## Talents et sorts à apprendre",
    "Règle des 5 secondes : la mana ne remonte qu'après 5 s sans sort, sauf avec Méditation.",
    "Finir à la baguette ne remet pas ce compteur à zéro.",
    "Discipline : Spécialisation Baguette, Méditation, Feu intérieur amélioré, Pénitence.",
    "Ombre : Châtiment et Flammes sacrées peuvent être sautés.",
    "Reviens chez le maître surtout aux niveaux 20, 26 et 30.",

    "## Métiers, camp et consommables",
    "Métiers : Couture (équipement en tissu) + Enchantement (baguettes).",
    "Monte aussi Secourisme pour les potions de soins.",
    "Équipement : Puissance des sorts, Intelligence, Esprit.",
    "Camp : Puits de mana, Bougie d'encens (Intelligence), Luth enchanté, Tente.",
    "Mange un plat avec buff : +5 % d'expérience sur les monstres tués.",
}

ns.conseils.SHAMAN = {
    "## Conseils généraux",
    "Amélioration est la spé de montée la plus souple : dégâts, soins sur soi et totems.",
    "Restauration et Élémentaire à distance sont lents en solo.",
    "La mana est ton point faible : fais des pulls calmes.",
    "Tes coups blancs font l'essentiel des dégâts : chaque sort de plus, c'est du temps passé à boire.",
    "Prends une arme proche de ton niveau.",

    "## Niveaux 1 à 10",
    "Horion de terre et Totem de force de la terre au niveau 4.",
    "Totem de lien terrestre (niv. 6) et Bouclier de foudre (niv. 8).",

    "## Niveaux 10 à 20",
    "Niveau 10 : Arme Langue de feu (ta meilleure amélioration d'arme), Horion de flammes, Totem incendiaire.",
    "Nova de feu au niveau 12, après la quête de l'Appel du feu.",
    "Totem de séisme au niveau 18.",

    "## Niveaux 20 à 30",
    "Loup fantôme au niveau 20 : indispensable.",
    "Loup fantôme amélioré tôt : instantané et utilisable en intérieur.",
    "Totem de magma au niveau 26.",
    "Élémentaire : Elemental Alacrity vers le niveau 28.",

    "## Niveaux 30 à 40",
    "Rappel astral au niveau 30 : une deuxième pierre de foyer (15 min).",
    "Spellhance : réinitialise vers le 31 pour Frappe-tempête améliorée.",
    "Chaîne d'éclairs et Totem Furie-des-vents au niveau 32.",

    "## Niveaux 40 à 60",
    "Salve de guérison au niveau 40, avec Remous pour Restauration.",
    "Totem de grâce aérienne au niveau 42.",

    "## Rotation",
    "Garde Arme Langue de feu et Bouclier de foudre (ou Bouclier d'eau) entre chaque pull.",
    "Tire avec Éclair ou Horion de flammes, puis garde Horion de flammes sur la cible.",
    "Frappe-tempête si tu l'as, Horion de terre pour achever.",
    "Contre plusieurs : Horion de flammes sur chacun et Nova de feu. Elle génère beaucoup de menace.",
    "Mana basse : arrête les horions et laisse tes coups blancs faire le travail.",
    "Garde le rang 1 d'Horion de terre sur ta barre : une interruption pas chère.",

    "## Talents et totems",
    "Spellhance (équipement de lanceur de sorts + talents Amélioration) : la variante la plus forte.",
    "Spellhance : d'abord Restauration (Esprit éveillé, Bouclier d'eau), puis Amélioration.",
    "Utilise des rangs inférieurs si la mana manque : l'écart entre rangs est faible.",
    "Pose les totems de buff là où tu tueras plusieurs monstres.",
    "Lien terrestre pour fuir, Griffes de pierre pour détourner les coups, Glèbe contre les sorts.",

    "## Métiers, camp et consommables",
    "Métiers : Dépeçage + Travail du cuir (mailles avec puissance des sorts, kits mystiques).",
    "La Couture n'est pas conseillée.",
    "Huiles de sorcier : elles s'ajoutent à tes améliorations d'arme.",
    "Camp : Tente, Chaise (critique), Bougie d'encens (Intelligence), Bocal à poissons.",
    "Mange toujours un plat avec buff : +5 % d'expérience sur les monstres tués.",
}

ns.conseils.MAGE = {
    "## Conseils généraux",
    "Givre : la spé la plus sûre pour débuter. Arcane : bonne gestion de la mana. Feu : grande portée.",
    "Fabrique ou achète une baguette tôt : elle achève sans mana et ne subit pas de recul.",
    "Fais une bonne réserve de nourriture et d'eau en te connectant.",
    "Évocation dès que ta mana est basse, et tes raciaux à chaque recharge.",
    "Un monstre en trop ? Nova de givre + Métamorphose sur l'un, ou fuis.",
    "Envoie tes objets à un autre personnage par la poste pour garder tes sacs libres.",

    "## Niveaux 1 à 10",
    "Jusqu'au niveau 8 : Éclair de givre puis baguette.",
    "Prends 2 points dans Spécialisation Baguette dès le niveau 10.",

    "## Niveaux 10 à 20",
    "Éclair de givre pour ralentir, puis tes sorts de dégâts.",
    "Nova de givre pour reprendre de la distance.",

    "## Niveaux 20 à 30",
    "Achète les Téléportations dès le niveau 20 (la troisième ville au 30).",
    "Arcane : Déflagration des arcanes au 21, Projectiles des arcanes rang 3 au 24, Courroux des arcanes au 26.",
    "Arcane : 2e point de Précision vers le 27 pour toucher à coup sûr.",

    "## Niveaux 30 à 40",
    "Niveau 34 : passe d'Armure de glace à Armure de mage pour boire moins souvent.",

    "## Niveaux 40 à 60",
    "Portails au niveau 40 (50 pour les dernières villes) : ils se revendent aux joueurs.",
    "Arcane : vise Arcane Power, le dernier talent de l'arbre.",

    "## Rotation",
    "Arcane : Déflagration des arcanes 1 ou 2 fois, puis Projectiles des arcanes avec Barrage de projectiles.",
    "Arcane : ne dépasse pas 2 cumuls de Déflagration, sauf contre les élites.",
    "Givre : Éclair de givre pendant l'approche, Javelot de glace sur une cible gelée.",
    "Givre : Trait de feu pour achever, Nova de givre si l'ennemi est trop proche.",
    "Feu : Trait de feu à chaque recharge, Explosion pyrotechnique à 3 cumuls de Réchauffement.",
    "Zone (3 cibles ou plus) : Nova de givre, Choc de flammes, puis Explosion des arcanes en boucle.",
    "Trait de feu quand tu dois bouger, si la mana le permet.",

    "## Talents et sorts à apprendre",
    "Arcane : Spécialisation Baguette, Précision, Canalisation améliorée, puis Barrage de projectiles.",
    "Arcane : Concentration et Méditation des arcanes une fois que tu ne joues plus à la baguette.",
    "Feu : Accelerant d'abord, puis Trait de feu amélioré et Incinération.",
    "Givre : retire Spécialisation Baguette et Morsure du givre plus tard pour Barrière de glace.",

    "## Métiers, camp et consommables",
    "Équipement : Intelligence et Puissance des sorts.",
    "Élixirs et huiles de sorcier : peu chers et très utiles.",
    "Mange un plat avec buff : +5 % d'expérience, idéalement avec Puissance des sorts (Sagerelle fumée).",
    "Camp : Tente (le plus important), Puits de mana, Luth enchanté.",
    "Garde des potions de mana et de soins.",
}

ns.conseils.WARLOCK = {
    "## Conseils généraux",
    "Lance toujours l'attaque du familier avant d'attaquer, pour que les monstres le ciblent.",
    "Utilise la baguette plutôt que Drain de vie, sauf si tu as besoin de te soigner.",
    "Ne reste pas avec toute ta vie et peu de mana : Connexion, puis Drain de vie te soignera.",
    "Garde ton démon en vie : entre deux pulls, un bandage ou une invocation vaut mieux que Captation de vie.",
    "Peur porte à 20 m : fais attention que le monstre ne coure pas vers d'autres groupes.",
    "S'il part du mauvais côté : Malédiction de témérité le fait revenir.",

    "## Niveaux 1 à 10",
    "Vends ton équipement de départ dès la connexion : ça paie Immolation rang 1 (10 pc), très forte au début.",
    "Familier : Diablotin au tout début.",
    "Baguette dès que possible : Baguette magique inférieure au niveau 5.",
    "Corruption (4), Connexion (6), Fléau d'agonie et Peur (8).",

    "## Niveaux 10 à 20",
    "Marcheur du Vide au niveau 10 pour tanker.",
    "Pierre de soins dès le niveau 10 : garde-en toujours une.",
    "Baguette magique supérieure au niveau 13.",

    "## Niveaux 20 à 30",
    "Succube (Sayaad) au niveau 20 : c'est elle qui fait le plus de dégâts.",
    "Démonologie : faible jusqu'au 25-27, puis Demonic Brand rend ton démon très fort.",

    "## Niveaux 30 à 40",
    "À partir du niveau 30, passe au drain-tank (Drain de vie rang 3).",
    "Ton démon ou toi tenez le monstre, et tu te soignes avec les drains.",
    "Flammes infernales au niveau 30 : indispensable en donjon.",
    "Pierre de sort au niveau 36 pour enchanter ton arme.",

    "## Niveaux 40 à 60",
    "Double spécialisation au niveau 40 chez le maître de classe (10 po).",
    "Destrier corrompu (monture) au niveau 40.",
    "Hurlement de terreur (40) pour les pulls ratés, Voile mortel (42) en urgence.",
    "Démonologie : Demonic Pact au niveau 40.",

    "## Rotation",
    "Pose tes DoTs, laisse ton démon tenir le monstre, puis baguette ou Drain de vie.",
    "Affliction, le plus rapide : DoTs + Peur sur un premier monstre, tue le second, remets Peur.",
    "Utilise la focalisation : DoTs et Peur sur ta cible focalisée avec un modificateur.",
    "Ne recommence pas tes DoTs trop tôt, ni sur un monstre presque mort.",
    "Donjon : Flammes infernales sur les groupes, préviens le soigneur avant.",

    "## Fragments d'âme et donjons",
    "Fragments : achève les monstres avec Drain d'âme rang 1.",
    "Les pierres de rencontre n'invoquent plus : garde des fragments pour Rituel d'invocation.",
    "En donjon, mets une Pierre d'âme sur le soigneur.",
    "Malédiction des éléments avec des lanceurs de sorts, Malédiction de témérité avec des mêlées.",

    "## Métiers, camp et consommables",
    "Métiers conseillés : Couture + Enchantement (tu désenchantes ce que tu couds).",
    "Élixirs de puissance des sorts et plats avec buff (+5 % d'expérience).",
    "Garde les potions de mana pour les longs combats et les donjons : Connexion suffit le reste du temps.",
}

ns.conseils.DRUID = {
    "## Conseils généraux",
    "Ta force, c'est la souplesse : dégâts, tank et soins sur toi entre deux pulls.",
    "Pas besoin de boire après chaque combat : la mana remonte en forme.",
    "Sonner et Célérité quand un combat tourne mal, Rôder pour passer sans être vu.",
    "N'oublie jamais Épines : c'est une vraie part de tes dégâts quand on te tape.",
    "Restauration en solo est la voie la plus lente : passe-y seulement près du niveau max.",
    "Attends-toi à tanker en donjon : habitue-toi tôt.",

    "## Niveaux 1 à 10",
    "Équipement avec Puissance des sorts : il compte beaucoup avant les formes.",

    "## Niveaux 10 à 20",
    "Forme d'ours au niveau 10 (quête de classe).",
    "Équilibre : prends Colère améliorée en premier.",
    "Change d'arme tôt : les armes de lanceur de sorts donnent de la puissance dès le 10.",
    "Guérison du poison (14), Forme aquatique (16).",

    "## Niveaux 20 à 30",
    "Forme de félin au niveau 20 (quête de classe).",
    "Prends Célérité féline dès que possible : elle reste utile même avec la monture.",
    "Augure de clarté au niveau 20.",
    "Délivrance de la malédiction (24), Abolir le poison (26).",

    "## Niveaux 30 à 40",
    "Forme de voyage au niveau 30.",
    "Équilibre : Essaim d'insectes et Nature's Splendor vers le 30, tes DoTs durent plus longtemps.",

    "## Niveaux 40 à 60",
    "Forme d'ours redoutable, Primal Bite et Forme de sélénien au niveau 40.",
    "Écorce au niveau 44.",
    "Équilibre : Éclipse, Feu stellaire amélioré et Vengeance tard dans la montée.",

    "## Rotation",
    "Félin : Griffure et Déchirure (5 points) si la cible vit plus de 6 s.",
    "Félin : Lambeau dans le dos, sinon Griffe. Morsure féroce pour achever.",
    "Ours : Rugissement démoralisant, Primal Bite dès qu'elle est prête.",
    "Ours : Balayage sur plusieurs cibles, Mutiler sur une seule.",
    "Félin contre les monstres faibles, ours quand il y en a plusieurs : passe de l'un à l'autre.",
    "Équilibre en groupe : Essaim d'insectes et Éclat lunaire partout, Épines fait le reste.",
    "Équilibre avant 40 : passe en ours (Rugissement + Balayage) le temps que la mana remonte.",
    "Équilibre après 40 : Forme de sélénien, DoTs, puis Ouragan.",
    "Équilibre en cible unique : Colère à portée max, Sarments, puis Colère en boucle.",

    "## Talents et sorts à apprendre",
    "Farouche : Célérité féline tôt, puis les talents de rage et de dégâts de l'ours.",
    "Farouche : finis dans l'arbre Restauration pour soigner sans manquer de mana.",
    "Sorts à sauter : Abolir le poison, Dérobade, Apaiser les animaux, Feu stellaire (en Farouche).",
    "Sarments : le rang 1 suffit en Farouche.",

    "## Métiers, camp et consommables",
    "Métiers : Dépeçage + Travail du cuir (kits d'armure, nouvelles recettes).",
    "La Tente du camp devient très forte après le niveau 30.",
    "Mange toujours un plat avec buff : +5 % d'expérience sur les monstres tués.",
    "Toutes les potions partagent le même temps de recharge : attention aux potions offensives.",
}
