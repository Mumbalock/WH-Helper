"""Mise à jour automatique d'AideClasse depuis les guides Wowhead (WoW Forever).

Ce que fait le programme :
  1. lit les guides Wowhead de chaque spécialisation (talents, BiS, stats) ;
  2. génère AideClasse/Data/<Classe>.lua ;
  3. copie l'addon complet dans le dossier AddOns du jeu.

Avant de tout télécharger, il vérifie s'il y a du nouveau chez Wowhead
(10 pages seulement) : la date de build de la base de données Wowhead
(paramètre db= des données de talents, reconstruite chaque jour) et la date
de dernière modification de chaque guide de classe. Si rien n'a changé depuis
la dernière mise à jour réussie, il s'arrête là. Utilise seulement la
bibliothèque standard de Python.

Lancé chaque jour par une tâche planifiée Windows (voir installer_auto.bat).

Options :
  --force          met à jour même si Wowhead n'a rien changé
  --sans-copie     ne copie pas l'addon dans le jeu
  --jeu CHEMIN     dossier AddOns du jeu (sinon détection automatique ou config.txt)
"""
import datetime
import hashlib
import json
import os
import re
import shutil
import sys
import time
import urllib.request
import winreg

ICI = os.path.dirname(os.path.abspath(__file__))
RACINE = os.path.dirname(ICI)
ADDON_SRC = os.path.join(RACINE, "AideClasse")
ETAT = os.path.join(ICI, "etat.json")
DERNIERS = os.path.join(ICI, "derniers_guides.json")   # dernières données lues, par classe et par spé
CONFIG = os.path.join(ICI, "config.txt")
JOURNAL = os.path.join(ICI, "journal.txt")

BASE = "https://www.wowhead.com/forever"
UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AideClasse-MiseAJour/0.2"
PAUSE = 1.5          # secondes entre deux pages

def _classe(slug, nom, arbres):
    """arbres : 3 tuples (nom de l'arbre chez Wowhead, nom français, slug de la spé dans les guides, icône),
    dans l'ordre des onglets de talents du jeu (c'est aussi l'ordre des liens du calculateur Wowhead)."""
    return {"slug": slug, "nom": nom, "arbres": [(a[0], a[1]) for a in arbres],
            "spec_arbre": {a[2]: i for i, a in enumerate(arbres)}, "noms_specs": {a[2]: a[1] for a in arbres},
            "icones": [a[3] for a in arbres]}


CLASSES = {
    "WARRIOR": _classe("warrior", "Guerrier", [
        ("WarriorArms", "Armes", "arms", "ability_rogue_eviscerate"),
        ("WarriorFury", "Fureur", "fury", "ability_warrior_innerrage"),
        ("WarriorProtection", "Protection", "protection", "ability_warrior_defensivestance")]),
    "PALADIN": _classe("paladin", "Paladin", [
        ("PaladinHoly", "Sacré", "holy", "spell_holy_holybolt"),
        ("PaladinProtection", "Protection", "protection", "spell_holy_devotionaura"),
        ("PaladinCombat", "Vindicte", "retribution", "spell_holy_auraoflight")]),
    "HUNTER": _classe("hunter", "Chasseur", [
        ("HunterBeastMastery", "Maîtrise des bêtes", "beast-mastery", "ability_hunter_beasttaming"),
        ("HunterMarksmanship", "Précision", "marksmanship", "ability_marksmanship"),
        ("HunterSurvival", "Survie", "survival", "ability_hunter_swiftstrike")]),
    "ROGUE": _classe("rogue", "Voleur", [
        ("RogueAssassination", "Assassinat", "assassination", "ability_rogue_eviscerate"),
        ("RogueCombat", "Combat", "combat", "ability_backstab"),
        ("RogueSubtlety", "Finesse", "subtlety", "ability_stealth")]),
    "PRIEST": _classe("priest", "Prêtre", [
        ("PriestDiscipline", "Discipline", "discipline", "spell_holy_wordfortitude"),
        ("PriestHoly", "Sacré", "holy", "spell_holy_holybolt"),
        ("PriestShadow", "Ombre", "shadow", "spell_shadow_shadowwordpain")]),
    "SHAMAN": _classe("shaman", "Chaman", [
        ("ShamanElementalCombat", "Élémentaire", "elemental", "spell_nature_lightning"),
        ("ShamanEnhancement", "Amélioration", "enhancement", "spell_nature_lightningshield"),
        ("ShamanRestoration", "Restauration", "restoration", "spell_nature_magicimmunity")]),
    "MAGE": _classe("mage", "Mage", [
        ("MageArcane", "Arcanes", "arcane", "spell_holy_magicalsentry"),
        ("MageFire", "Feu", "fire", "spell_fire_firebolt02"),
        ("MageFrost", "Givre", "frost", "spell_frost_frostbolt02")]),
    "WARLOCK": _classe("warlock", "Démoniste", [
        ("WarlockCurses", "Affliction", "affliction", "spell_shadow_deathcoil"),
        ("WarlockSummoning", "Démonologie", "demonology", "spell_shadow_metamorphosis"),
        ("WarlockDestruction", "Destruction", "destruction", "spell_shadow_rainoffire")]),
    "DRUID": _classe("druid", "Druide", [
        ("DruidBalance", "Équilibre", "balance", "spell_nature_starfall"),
        ("DruidFeralCombat", "Combat farouche", "feral", "ability_racial_bearform"),
        ("DruidRestoration", "Restauration", "restoration", "spell_nature_healingtouch")]),
}
ROLES_FR = {"dps": "DPS", "tank": "Tank", "healer": "Soins"}

EMPLACEMENTS = {
    "Head": "Tête", "Neck": "Cou", "Shoulders": "Épaules", "Shoulder": "Épaules", "Back": "Dos",
    "Chest": "Torse", "Wrists": "Poignets", "Wrist": "Poignets", "Hands": "Mains", "Waist": "Taille",
    "Legs": "Jambes", "Feet": "Pieds", "Rings": "Anneaux", "Ring": "Anneaux", "Finger": "Anneaux",
    "Trinkets": "Bijoux", "Trinket": "Bijoux", "Main Hand": "Main droite", "Weapon": "Arme",
    "Weapons": "Armes", "Two-Hand": "Deux mains", "Off Hand": "Main gauche", "Off-Hand": "Main gauche",
    "Wand": "Baguette", "Ranged": "Baguette", "Relic": "Relique",
}
RANGS = {"BiS": "BiS", "Great": "Très bon", "Good": "Bon", "Option": "Option", "Alt": "Option"}

MIN_CHARS = "abcdefghjkmnpqrstvwzxyilou468-~!"
MAX_CHARS = "ABCDEFGHJKMNPQRSTVWZXYILOU579_^."
TYPES_WH = {"npc": 1, "object": 2, "item": 3, "quest": 5, "spell": 6, "zone": 7, "faction": 8}


def log(msg):
    ligne = f"{datetime.datetime.now():%Y-%m-%d %H:%M:%S}  {msg}"
    try:
        print(ligne)   # pas de console avec pythonw : on ignore
    except Exception:
        pass
    try:
        with open(JOURNAL, "a", encoding="utf-8") as f:
            f.write(ligne + "\n")
    except OSError:
        pass


_derniere_requete = [0.0]
_pages_lues = {}     # une page n'est téléchargée qu'une fois par lancement


def telecharger(url):
    if url in _pages_lues:
        return _pages_lues[url]
    attente = PAUSE - (time.time() - _derniere_requete[0])
    if attente > 0:
        time.sleep(attente)
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept-Language": "en-US,en;q=0.8"})
    with urllib.request.urlopen(req, timeout=40) as r:
        data = r.read().decode("utf-8", errors="replace")
    _derniere_requete[0] = time.time()
    _pages_lues[url] = data
    return data


def signature_wowhead():
    """Résumé de l'état actuel des données Wowhead, pour savoir s'il y a du nouveau.
    Renvoie {"db": horodatage du build de la base, "guides": empreinte des dates de modification
    des guides, "dernier_edit": modification de guide la plus récente}."""
    page = telecharger(f"{BASE}/talent-calc/warlock")
    m = re.search(r"talents-classic\?[^\"'\s]*?db=(\d+)", page)
    if not m:
        raise ValueError("version de la base Wowhead introuvable (la page a peut-être changé)")
    edits = []
    for classe in CLASSES.values():
        html = telecharger(f"{BASE}/guides/classes/{classe['slug']}")
        edits += re.findall(r'"lastEdit"\s*:\s*"([^"]+)"', html)
    if not edits:
        raise ValueError("dates de modification des guides introuvables (la page a peut-être changé)")
    return {"db": int(m.group(1)),
            "guides": hashlib.sha1("\n".join(sorted(edits)).encode("utf-8")).hexdigest(),
            "dernier_edit": max(edits)}


def date_db(db):
    return f"{datetime.datetime.fromtimestamp(db):%Y-%m-%d %H:%M}"


# --- Lecture des pages Wowhead -------------------------------------------------

def lire_guide(html):
    """Renvoie (markup du guide, dictionnaire des noms {(type, id): nom}).
    Les icônes des objets sont rangées dans ICONES_OBJETS."""
    m = re.search(r'WH\.markup\.printHtml\(\s*("(?:[^"\\]|\\.)*")\s*,\s*"guide-body"', html, re.S)
    if not m:
        raise ValueError("contenu du guide introuvable (la page a peut-être changé)")
    markup = json.loads(m.group(1))
    noms = {}
    dec = json.JSONDecoder()
    for g in re.finditer(r"WH\.Gatherer\.addData\(\s*(\d+)\s*,\s*\d+\s*,\s*", html):
        try:
            obj, _ = dec.raw_decode(html, g.end())
        except ValueError:
            continue
        for k, v in obj.items():
            if isinstance(v, dict) and v.get("name_enus"):
                noms[(int(g.group(1)), int(k))] = v["name_enus"]
                if int(g.group(1)) == 3 and v.get("icon"):
                    ICONES_OBJETS[int(k)] = v["icon"]
    return markup, noms


ICONES_OBJETS = {}


def markup_en_texte(s, noms):
    """Convertit le markup Wowhead en texte. Sorts et objets deviennent {s:ID:Nom} / {i:ID:Nom}
    pour que l'addon affiche leur nom traduit dans le jeu."""
    def remplace(m):
        typ, ident = m.group(1), int(m.group(2))
        nom = noms.get((TYPES_WH.get(typ, 0), ident), "")
        if typ == "spell":
            return "{s:%d:%s}" % (ident, nom)
        if typ == "item":
            return "{i:%d:%s}" % (ident, nom)
        return nom
    s = re.sub(r"\[(spell|item|npc|zone|object|quest|faction)=(\d+)[^\]]*\]", remplace, s)
    s = re.sub(r"\[url=[^\]]*\](.*?)\[/url\]", r"\1", s, flags=re.S)
    s = re.sub(r"\[/?[a-z0-9\-]+(?:[= ][^\]]*)?\]", "", s)
    s = re.sub(r"[ \t]+", " ", s.replace("\r", ""))
    return s.strip()


def sections(markup, niveau):
    """Découpe le markup en [(titre, contenu)] sur les titres [hN]."""
    morceaux = re.split(r"\[h%d([^\]]*)\](.*?)\[/h%d\]" % (niveau, niveau), markup, flags=re.S)
    res = []
    for i in range(1, len(morceaux) - 2, 3):
        attrs, titre, contenu = morceaux[i], morceaux[i + 1], morceaux[i + 2]
        toc = re.search(r'toc="([^"]*)"', attrs)
        res.append((toc.group(1) if toc else titre.strip(), titre.strip(), contenu))
    return res


# --- Talents --------------------------------------------------------------------

def charger_talents():
    page = telecharger(f"{BASE}/talent-calc/warlock")
    m = re.search(r'(https://nether\.wowhead\.com/forever/data/talents-classic\?[^"\']+)', page)
    if not m:
        raise ValueError("lien des données de talents introuvable")
    src = telecharger(m.group(1).replace("&amp;", "&"))
    m2 = re.search(r'WH\.setPageData\("wow\.talentCalcClassic\.[a-z]+\.data",', src)
    data, _ = json.JSONDecoder().raw_decode(src, m2.end())
    return data


def decoder_build(lien, classe, tdata):
    """lien = 'warlock/v2...-...-.._t0/ordre'. Renvoie un dict build ou None."""
    morceaux = lien.split("/")
    points_hash = morceaux[1] if len(morceaux) > 1 else ""
    ordre = morceaux[2] if len(morceaux) > 2 else ""
    points = points_hash.split("_")[0]

    noms_arbres = {v["description"]: k for k, v in tdata["trees"].items()}
    arbres = [(noms_arbres[desc], fr) for desc, fr in classe["arbres"]]

    # hashLayouts ne contient que les anciennes versions du format des liens. Les liens au format
    # actuel commencent par hashVersion : leurs talents suivent les arbres actuels, triés par ligne
    # puis colonne (comme dans le calculateur Wowhead).
    dispositions = dict(tdata["hashLayouts"])
    version = tdata.get("hashVersion")
    if version:
        dispositions[version] = [{
            arbre_id: [[t["row"], t["col"], len(t["ranks"]), t["ranks"][0], t["name"]]
                       for t in sorted(tdata["talents"].get(arbre_id, {}).values(), key=lambda t: (t["row"], t["col"]))]
            for arbre_id, _ in arbres}]

    prefixe = next((p for p in sorted(dispositions, key=len, reverse=True)
                    if points.startswith(p) and (points[len(p):] == "" or points[len(p)] in "0123456789_-")), None)
    if prefixe is None:
        return None
    rangs = points[len(prefixe):].split("-")
    variantes = list(range(len(dispositions[prefixe])))
    prefere = tdata.get("hashLayoutHints", {}).get(f"{classe['slug']}/{points}")
    if prefere is not None and prefere in variantes:
        variantes.remove(prefere)
        variantes.insert(0, prefere)

    # Arbres actuels du jeu : le lien peut avoir été écrit avec une ancienne version des arbres
    # (talent renommé, déplacé ou supprimé). Comme le calculateur Wowhead, on retraduit chaque
    # talent vers l'arbre actuel par son nom, sinon par sa position ; les talents disparus sont ignorés.
    par_nom, par_pos = {}, {}
    for i, (arbre_id, arbre_fr) in enumerate(arbres):
        for t in tdata["talents"].get(arbre_id, {}).values():
            actuel = {"sort": t["ranks"][0], "nom": t["name"], "arbre": arbre_fr, "rangMax": len(t["ranks"])}
            par_nom[t["name"]] = actuel
            par_pos[(i, t["row"], t["col"])] = actuel

    def traduire(i, t):
        a = par_nom.get(t[4])
        if a is None:
            p = par_pos.get((i, t[0], t[1]))
            if p and p["sort"] == t[3]:
                a = p
        return a

    for v in variantes:
        disposition = dispositions[prefixe][v]
        ok = True
        final_brut = []
        for i, (arbre_id, arbre_fr) in enumerate(arbres):
            liste = disposition.get(arbre_id, [])
            chiffres = rangs[i] if i < len(rangs) else ""
            if len(chiffres) > len(liste) or not chiffres.isdigit() and chiffres:
                ok = False
                break
            for j, c in enumerate(chiffres):
                if int(c) > liste[j][2]:
                    ok = False
                if int(c) > 0:
                    final_brut.append((i, liste[j], int(c)))
        if not ok:
            continue

        # Répartition finale, traduite vers les arbres actuels.
        final, cible = [], {}
        for i, t, n in final_brut:
            a = traduire(i, t)
            if a is None:
                continue
            n = min(n, a["rangMax"])
            if a["sort"] in cible:
                cible[a["sort"]]["points"] = max(cible[a["sort"]]["points"], n)
            else:
                cible[a["sort"]] = dict(a, points=n)
                final.append(cible[a["sort"]])

        # Ordre des points, limité à la répartition finale de chaque talent.
        etapes, pris = [], {}
        arbre_courant = None
        for ch in ordre:
            if ch.isdigit() and int(ch) < len(arbres):
                arbre_courant = int(ch)
                continue
            if arbre_courant is None:
                continue
            liste = disposition.get(arbres[arbre_courant][0], [])
            if ch in MIN_CHARS:
                idx, n = MIN_CHARS.index(ch), 1
            elif ch in MAX_CHARS:
                idx = MAX_CHARS.index(ch)
                n = liste[idx][2] if idx < len(liste) else 1
            else:
                continue
            if idx >= len(liste):
                continue
            a = traduire(arbre_courant, liste[idx])
            if a is None or a["sort"] not in cible:
                continue
            n = min(n, cible[a["sort"]]["points"] - pris.get(a["sort"], 0))
            if n <= 0:
                continue
            pris[a["sort"]] = pris.get(a["sort"], 0) + n
            # Fusionne avec l'étape précédente si c'est le même talent.
            if etapes and etapes[-1]["sort"] == a["sort"]:
                etapes[-1]["points"] += n
            else:
                etapes.append({"sort": a["sort"], "nom": a["nom"], "arbre": a["arbre"], "points": n})
        return {"final": final, "etapes": etapes, "lien": f"{BASE}/talent-calc/{lien}"}
    return None


TITRES_BUILDS = {"raid": "Raid", "dungeon": "Donjon", "pvp": "PvP", "leveling": "Montée en niveau"}


def titre_court(attrs, titre):
    toc = re.search(r'toc="([^"]*)"', attrs)
    texte = (toc.group(1) if toc else titre).strip()
    for mot, fr in TITRES_BUILDS.items():
        if mot in texte.lower():
            return fr
    return texte


def builds_de_page(markup, classe, tdata, noms, titre_defaut):
    builds = []
    titre, onglet = titre_defaut, None
    motif = r'\[h2([^\]]*)\](.*?)\[/h2\]|\[tab name="([^"]*)"|\[/tabs\]|\[talent=([^\] ]+)'
    for m in re.finditer(motif, markup, re.S):
        if m.group(2) is not None:
            titre, onglet = titre_court(m.group(1), markup_en_texte(m.group(2), noms)), None
        elif m.group(3) is not None:
            onglet = m.group(3)
        elif m.group(4) is not None:
            b = decoder_build(m.group(4), classe, tdata)
            if b:
                b["nom"] = f"{titre} – {onglet}" if onglet else titre
                builds.append(b)
        else:
            onglet = None
    # Numérote les doublons éventuels.
    vus = {}
    for b in builds:
        vus[b["nom"]] = vus.get(b["nom"], 0) + 1
        if vus[b["nom"]] > 1:
            b["nom"] += f" ({vus[b['nom']]})"
    return builds


# --- Stuff et stats -------------------------------------------------------------

def lire_bis(markup, noms):
    objets = []
    for toc, titre, contenu in sections(markup, 3):
        emplacement = EMPLACEMENTS.get(toc, toc)
        for ligne in re.findall(r"\[tr\](.*?)\[/tr\]", contenu, re.S):
            cases = re.findall(r"\[td[^\]]*\](.*?)\[/td\]", ligne, re.S)
            if len(cases) < 2:
                continue
            items = re.findall(r"\[item=(\d+)", cases[1])
            if not items:
                continue
            rang = markup_en_texte(cases[0], noms)
            source = markup_en_texte(cases[2], noms) if len(cases) > 2 else ""
            for ident in items:
                ident = int(ident)
                objets.append({"id": ident, "nom": noms.get((3, ident), ""), "icone": ICONES_OBJETS.get(ident, ""),
                               "emplacement": emplacement, "source": source,
                               "rang": next((v for k, v in RANGS.items() if k.lower() == rang.lower()), rang)})
    return objets


def lire_stats(markup, noms):
    m = re.search(r"\[ol\](.*?)\[/ol\]", markup, re.S)
    if not m:
        return []
    return [markup_en_texte(li, noms) for li in re.findall(r"\[li\](.*?)\[/li\]", m.group(1), re.S)]


# --- Génération du fichier Lua --------------------------------------------------

def lua(v, ind=0):
    pad = "    " * ind
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return str(v)
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'
    if isinstance(v, list):
        if not v:
            return "{}"
        return "{\n" + "".join(f"{pad}    {lua(x, ind + 1)},\n" for x in v) + pad + "}"
    if isinstance(v, dict):
        if not v:
            return "{}"
        def cle(k):
            return k if re.match(r"^[A-Za-z_][A-Za-z0-9_]*$", k) else "[" + lua(k) + "]"
        if all(isinstance(x, (str, int, float, bool)) for x in v.values()):
            return "{ " + ", ".join(f"{cle(k)} = {lua(x)}" for k, x in v.items()) + " }"
        champs = [f"{pad}    {cle(k)} = {lua(x, ind + 1)},\n" for k, x in v.items()]
        return "{\n" + "".join(champs) + pad + "}"
    raise TypeError(type(v))


def construire_arbres(classe, tdata):
    """Disposition des 3 arbres (position, icône, prérequis) pour dessiner les talents."""
    noms_arbres = {v["description"]: k for k, v in tdata["trees"].items()}
    arbres = []
    for i, (desc, nom_fr) in enumerate(classe["arbres"]):
        brut = tdata["talents"].get(noms_arbres.get(desc, ""), {})
        par_id = {int(k): t for k, t in brut.items()}
        talents = []
        for t in sorted(brut.values(), key=lambda t: (t["row"], t["col"])):
            req = 0
            if t.get("requires"):
                parent = par_id.get(int(t["requires"][0]["id"]))
                if parent and parent.get("ranks"):
                    req = parent["ranks"][0]
            talents.append({"sort": t["ranks"][0], "nom": t["name"], "icone": t.get("icon", ""),
                            "ligne": t["row"], "col": t["col"], "rangMax": len(t["ranks"]), "requiert": req})
        arbres.append({"nom": nom_fr, "fond": desc, "icone": classe["icones"][i], "talents": talents})
    return arbres


TYPES_PAGES = {  # type de page -> début du nom de la page chez Wowhead
    "montee": ("leveling-tips",), "builds": ("talent-builds",), "bis": ("bis-gear",),
    "stats": ("stat-priority",), "guide": ("overview",),
}


def decouvrir_specs(classe):
    """Lit la page des guides de la classe et renvoie
    [(clé, nom affiché, index de l'arbre, {type de page: nom de page})]. Une spé qui a des guides
    pour plusieurs rôles (ex. Druide farouche DPS/Tank) donne une entrée par rôle."""
    html = telecharger(f"{BASE}/guides/classes/{classe['slug']}").replace("\\/", "/")
    pages = {}
    for spec, page in re.findall(rf"forever/guide/classes/{classe['slug']}/([a-z0-9\-]+)/([a-z0-9\-]+)", html, re.I):
        pages.setdefault(spec.lower(), set()).add(page.lower())
    res = []
    for slug in classe["spec_arbre"]:        # ordre des arbres du jeu
        liste = pages.get(slug)
        if not liste:
            log(f"  {classe['slug']}/{slug} : aucun guide trouvé")
            continue
        roles = sorted({m for p in liste for m in re.findall(r"(?:^|-)(dps|tank|healer)(?:-|$)", p)})
        for role in (roles if len(roles) > 1 else [None]):
            choix = {}
            for typ, debuts in TYPES_PAGES.items():
                candidates = sorted(p for p in liste if any(d in p for d in debuts))
                if role:
                    avec_role = [p for p in candidates if re.search(rf"(?:^|-){role}(?:-|$)", p)]
                    candidates = avec_role or [p for p in candidates if not re.search(r"(?:^|-)(dps|tank|healer)(?:-|$)", p)]
                if candidates:
                    choix[typ] = candidates[0]
            nom = classe["noms_specs"][slug] + (f" ({ROLES_FR.get(role, role)})" if role else "")
            cle = slug.replace("-", "_") + (f"_{role}" if role else "")
            res.append((cle, slug, nom, classe["spec_arbre"][slug], choix))
    return res


PARTIES = (("builds", "build(s)"), ("objets", "objet(s)"), ("stats", "stat(s)"))


def generer_classe(token, classe, tdata, anciennes=None):
    """anciennes : specs de la mise à jour précédente ({clé: spec}). Une partie d'une spé
    (builds, objets, stats) qui était remplie et revient vide (guide en cours de modification,
    format pas encore compris…) reprend son ancien contenu. Renvoie aussi le nombre de reprises."""
    anciennes = anciennes or {}
    specs = {}
    ordre = []
    reprises = 0
    for cle, slug, nom_fr, arbre, pages in decouvrir_specs(classe):
        url_base = f"{BASE}/guide/classes/{classe['slug']}/{slug}"
        spec = {"nom": nom_fr, "icone": classe["icones"][arbre],
                "guide": url_base + "/" + pages.get("guide", ""), "builds": [], "objets": [], "stats": []}

        def lire(typ):
            if typ not in pages:
                return None
            try:
                return lire_guide(telecharger(url_base + "/" + pages[typ]))
            except Exception as e:
                log(f"  {cle} / {typ} : {e}")
                return None

        r = lire("montee")
        if r:
            for b in builds_de_page(r[0], classe, tdata, r[1], "Montée en niveau"):
                b["nom"] = "Montée en niveau"
                spec["builds"].append(b)
                break
        r = lire("builds")
        if r:
            spec["builds"] += builds_de_page(r[0], classe, tdata, r[1], "Build")
        r = lire("bis")
        if r:
            spec["objets"] = lire_bis(r[0], r[1])
        r = lire("stats")
        if r:
            spec["stats"] = lire_stats(r[0], r[1])

        log(f"  {cle} : {len(spec['builds'])} build(s), {len(spec['objets'])} objet(s), {len(spec['stats'])} stat(s)")
        ancienne = anciennes.get(cle, {})
        for partie, libelle in PARTIES:
            if not spec[partie] and ancienne.get(partie):
                spec[partie] = ancienne[partie]
                reprises += 1
                log(f"  {cle} : rien lu pour « {partie} », on garde les {len(spec[partie])} {libelle} précédents")
        specs[cle] = spec
        ordre.append(cle)

    total_builds = sum(len(s["builds"]) for s in specs.values())
    if total_builds == 0:
        raise ValueError("aucun build de talents lu : fichier existant conservé")

    donnees = {
        "token": token,
        "nom": classe["nom"],
        "majLe": f"{datetime.datetime.now():%Y-%m-%d %H:%M}",
        "source": "Wowhead – guides WoW Forever",
        "defaultSpec": ordre[0],
        "ordreSpecs": ordre,
        "arbres": construire_arbres(classe, tdata),
        "specs": specs,
    }
    entete = ("-- FICHIER GÉNÉRÉ AUTOMATIQUEMENT par MiseAJour/aideclasse_maj.py\n"
              "-- Ne pas modifier à la main : il est remplacé à chaque mise à jour.\n"
              "local _, ns = ...\n\n")
    return entete + f"ns.data.{token} = " + lua(donnees) + "\n", donnees, reprises


ICONES_EXEMPLE = ["inv_helmet_06", "inv_chest_cloth_21", "inv_wand_01", "inv_misc_questionmark"]


def icones_simulateur(toutes):
    """Télécharge (une seule fois, avec cache local) les icônes utilisées et les renvoie en data URI,
    car la page du simulateur ne peut pas charger d'images depuis un autre site."""
    import base64
    cache = os.path.join(RACINE, "Simulateur", "icones")
    os.makedirs(cache, exist_ok=True)
    noms = set(ICONES_EXEMPLE)
    for donnees in toutes.values():
        for a in donnees.get("arbres", []):
            noms.add(a["icone"])
            noms.update(t["icone"] for t in a["talents"] if t["icone"])
        for s in donnees["specs"].values():
            noms.add(s.get("icone", ""))
            noms.update(o["icone"] for o in s.get("objets", []) if o.get("icone"))
    res = {}
    for nom in sorted(n for n in noms if n and re.match(r"^[a-z0-9_\-]+$", n)):
        chemin = os.path.join(cache, nom + ".jpg")
        if not os.path.isfile(chemin):
            try:
                req = urllib.request.Request(f"https://wow.zamimg.com/images/wow/icons/large/{nom}.jpg", headers={"User-Agent": UA})
                with urllib.request.urlopen(req, timeout=30) as r:
                    octets = r.read()
                with open(chemin, "wb") as f:
                    f.write(octets)
                time.sleep(0.2)
            except Exception as e:
                log(f"  icône {nom} indisponible : {e}")
                continue
        with open(chemin, "rb") as f:
            res[nom] = "data:image/jpeg;base64," + base64.b64encode(f.read()).decode("ascii")
    return res


def generer_simulateur(toutes):
    """Met à jour Simulateur/simulateur.html avec les mêmes données que l'addon (toutes les classes)."""
    modele = os.path.join(RACINE, "Simulateur", "simulateur_modele.html")
    if not os.path.isfile(modele) or not toutes:
        return
    conseils = {}
    chemin_conseils = os.path.join(ADDON_SRC, "Data", "Conseils.lua")
    if os.path.isfile(chemin_conseils):
        with open(chemin_conseils, encoding="utf-8") as f:
            source = f.read()
        for token in toutes:
            bloc = re.search(r"ns\.conseils\.%s\s*=\s*\{(.*?)\n\}" % token, source, re.S)
            if bloc:
                conseils[token] = [json.loads('"' + s + '"') for s in re.findall(r'"((?:[^"\\]|\\.)*)"', bloc.group(1))]
    js = json.dumps({"classes": toutes, "conseils": conseils, "icones": icones_simulateur(toutes)},
                    ensure_ascii=False).replace("</", "<\\/")
    with open(modele, encoding="utf-8") as f:
        page = f.read().replace("__DONNEES__", js)
    sortie = os.path.join(RACINE, "Simulateur", "simulateur.html")
    with open(sortie, "w", encoding="utf-8", newline="\n") as f:
        f.write(page)
    log(f"{sortie} mis à jour")


# --- Dossier du jeu -------------------------------------------------------------

def dossiers_wow():
    candidats = []
    for cle in (r"SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft",
                r"SOFTWARE\Blizzard Entertainment\World of Warcraft"):
        try:
            with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, cle) as k:
                chemin = winreg.QueryValueEx(k, "InstallPath")[0]
                candidats.append(os.path.dirname(os.path.normpath(chemin)))
        except OSError:
            pass
    for base in (r"C:\Program Files (x86)", r"C:\Program Files", "D:\\", r"D:\Program Files (x86)", r"D:\Jeux", r"C:\Jeux"):
        candidats.append(os.path.join(base, "World of Warcraft"))
    vus = []
    for c in candidats:
        c = os.path.normpath(c)
        if os.path.isdir(c) and c not in vus:
            vus.append(c)
    return vus


def trouver_addons(arg):
    if arg:
        return arg
    if os.path.isfile(CONFIG):
        with open(CONFIG, encoding="utf-8") as f:
            for ligne in f:
                ligne = ligne.strip()
                if ligne and not ligne.startswith("#"):
                    return ligne
    connus = {"_retail_", "_classic_", "_classic_era_", "_ptr_", "_xptr_", "_beta_", "_classic_ptr_",
              "_classic_era_ptr_", "_classic_beta_", "_anniversary_"}
    trouves, autres = [], []
    for wow in dossiers_wow():
        for nom in os.listdir(wow):
            chemin = os.path.join(wow, nom)
            if not (nom.startswith("_") and nom.endswith("_") and os.path.isdir(chemin)):
                continue
            addons = os.path.join(chemin, "Interface", "AddOns")
            if os.path.isfile(os.path.join(addons, "AideClasse", "AideClasse.toc")):
                trouves.append(addons)
            elif nom.lower() not in connus or "forever" in nom.lower():
                autres.append(addons)
    if len(trouves) == 1:
        return trouves[0]
    if not trouves and len(autres) == 1:
        return autres[0]
    if trouves or autres:
        log("Plusieurs dossiers de jeu possibles : " + " | ".join(trouves + autres))
        log("Écris le bon chemin (…\\Interface\\AddOns) dans " + CONFIG)
    else:
        log("Dossier de WoW Forever introuvable. Écris le chemin (…\\Interface\\AddOns) dans " + CONFIG)
    return None


def copier_addon(addons):
    dest = os.path.join(addons, "AideClasse")
    os.makedirs(addons, exist_ok=True)
    tmp = dest + ".maj"
    if os.path.isdir(tmp):
        shutil.rmtree(tmp)
    shutil.copytree(ADDON_SRC, tmp)
    if os.path.isdir(dest):
        shutil.rmtree(dest)
    os.replace(tmp, dest)
    log(f"Addon copié dans {dest}")


# --- Programme principal --------------------------------------------------------

def main():
    args = sys.argv[1:]
    force = "--force" in args
    sans_copie = "--sans-copie" in args
    jeu = args[args.index("--jeu") + 1] if "--jeu" in args and args.index("--jeu") + 1 < len(args) else None

    etat = {}
    if os.path.isfile(ETAT):
        try:
            with open(ETAT, encoding="utf-8") as f:
                etat = json.load(f)
        except (OSError, ValueError):
            etat = {}

    a_faire, signature = True, None
    try:
        signature = signature_wowhead()
        texte = f"base Wowhead du {date_db(signature['db'])}, dernier guide modifié le {signature['dernier_edit'][:16].replace('T', ' ')}"
        if signature == etat.get("signature"):
            if force:
                log(f"Rien de nouveau chez Wowhead ({texte}), mise à jour forcée.")
            else:
                a_faire = False
                log(f"Rien de nouveau chez Wowhead ({texte}) : pas de téléchargement.")
        else:
            log(f"Nouveautés chez Wowhead ({texte}).")
    except Exception as e:
        log(f"Vérification des nouveautés impossible ({e}) : mise à jour complète.")

    if a_faire:
        log("Mise à jour depuis Wowhead…")
        try:
            tdata = charger_talents()
            derniers = {}
            if os.path.isfile(DERNIERS):
                try:
                    with open(DERNIERS, encoding="utf-8") as f:
                        derniers = json.load(f)
                except (OSError, ValueError):
                    derniers = {}
            toutes, echecs, reprises = {}, 0, 0
            for token, classe in CLASSES.items():
                log(f"{classe['nom']}…")
                try:
                    contenu, donnees, r = generer_classe(token, classe, tdata, derniers.get(token))
                    reprises += r
                except Exception as e:
                    echecs += 1
                    log(f"  ÉCHEC pour {classe['nom']}, anciennes données conservées : {e}")
                    continue
                chemin = os.path.join(ADDON_SRC, "Data", classe["slug"].capitalize() + ".lua")
                with open(chemin + ".tmp", "w", encoding="utf-8", newline="\n") as f:
                    f.write(contenu)
                os.replace(chemin + ".tmp", chemin)
                toutes[token] = donnees
                derniers[token] = donnees["specs"]
            with open(DERNIERS + ".tmp", "w", encoding="utf-8") as f:
                json.dump(derniers, f, ensure_ascii=False)
            os.replace(DERNIERS + ".tmp", DERNIERS)
            log(f"{len(toutes)} classe(s) mise(s) à jour, {echecs} échec(s)"
                + (f", {reprises} partie(s) reprise(s) de la mise à jour précédente" if reprises else ""))
            try:
                generer_simulateur(toutes)
            except Exception as e:
                log(f"Simulateur non mis à jour : {e}")
            etat["derniere_maj"] = time.time()
            # Signature enregistrée seulement si tout a réussi : sinon on réessaie au prochain lancement.
            if echecs == 0 and reprises == 0 and signature:
                etat["signature"] = signature
            with open(ETAT, "w", encoding="utf-8") as f:
                json.dump(etat, f)
        except Exception as e:
            log(f"ÉCHEC de la mise à jour, anciennes données conservées : {e}")

    if not sans_copie:
        addons = trouver_addons(jeu)
        if addons:
            try:
                copier_addon(addons)
            except OSError as e:
                log(f"Copie impossible (jeu ouvert ?) : {e}")


if __name__ == "__main__":
    main()
