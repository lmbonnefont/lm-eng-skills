# Catalogue de Patterns UX

Patterns UX éprouvés dans le codebase alan-apps. Référencé par `/lm-ux-delight` pour
générer des recommandations contextuelles.

Chaque pattern suit le format : Name, When, What, Evidence, Effort, Key detail.

---

## 1. Suggestions anticipées

**Quand** : Dropdown ou autocomplete avec un petit dataset (<20 items).
**Quoi** : Montrer les N premières options au focus, avant que l'utilisateur ne tape quoi que
ce soit. Pour les petites listes, l'utilisateur peut choisir visuellement sans avoir à se souvenir
de la valeur exacte.
**Evidence** : PR #87355 — Dropdown NIC des établissements DSN. Montre 5 suggestions par défaut
au focus. Implémentation : suppression du guard `!searchInput` dans useMemo, ajout de
`slice(0, MAX_DEFAULT_NIC_SUGGESTIONS)` pour l'état par défaut.
**Effort** : Trivial
**Détail clé** : Utiliser un blur delay de 200ms pour laisser le temps au clic sur une suggestion
de s'enregistrer avant la fermeture du dropdown.

---

## 2. Liens directs vers le résultat

**Quand** : Toute action qui crée, déclenche ou modifie une ressource que l'utilisateur voudra
voir immédiatement (créer une entité, envoyer un message, déclencher un export, etc.).
**Quoi** : Après le succès de l'action, fournir un lien direct vers le résultat au lieu de laisser
l'utilisateur le chercher manuellement. Remplacer les toasts "Succès !" par
"Succès ! [Voir la conversation →]".
**Evidence** : Pattern PR #87071 — Création de conversation Intercom pour les changements membre.
Le backend retourne l'URL de la conversation pour que le frontend puisse linker directement
au lieu de demander à l'admin d'ouvrir Intercom et chercher.
**Effort** : Moyen (nécessite que le backend retourne l'identifiant/URL de la ressource créée)
**Détail clé** : Le lien doit être l'action primaire du feedback de succès, pas un élément
secondaire caché dans un toast qui disparaît.

---

## 3. Comportements input intelligents

**Quand** : Formulaires avec des champs texte, en particulier quand il y a un champ d'action
principal.
**Quoi** : Auto-focus sur le premier input significatif au mount. Auto-select du contenu texte
quand l'utilisateur focus un champ pré-rempli (pour pouvoir écraser sans triple-clic).
Blur delays sur les dropdowns pour éviter les fermetures accidentelles.
**Evidence** : Divers formulaires du dashboard admin.
**Effort** : Trivial
**Détail clé** : Ne pas auto-focus si la page a un scroll — l'auto-focus qui déclenche un scroll
vers le bas est désorientant pour l'utilisateur.

---

## 4. Masquer les sections vides

**Quand** : Composant qui affiche N sections groupées (DrawerCollection, liste tabulée, accordéon) où certaines sections peuvent être vides selon le contexte.
**Quoi** : Conditionner le render de chaque section sur `items.length > 0`. Ne jamais afficher un titre de groupe sans contenu en dessous.
**Evidence** : OHSET-521 — modal latérale pluriel avec DrawerCollection Médecins / Infirmières. Si tous les sans-réponse sont du même type, la section vide donne l'impression d'un bug.
**Effort** : Trivial
**Détail clé** : Vérifier aussi le cas où TOUTES les sections seraient vides — ajouter un empty state global dans ce cas plutôt que de ne rien afficher du tout.

---

## 5. Empty states distincts : données vides vs résultat filtré

**Quand** : Liste ou table filtrable où l'utilisateur peut atteindre zéro résultat soit parce qu'il n'y a aucune donnée, soit parce que ses filtres ne matchent rien.
**Quoi** : Afficher deux empty states distincts. Données vides → message neutre ("Aucun X pour le moment"). Résultat filtré vide → message + lien "Réinitialiser les filtres".
**Evidence** : OHSET-586 — table read-only des actions en milieu de travail (dashboard Occupational Health employeur).
**Effort** : Trivial
**Détail clé** : Distinguer les deux cas évite que l'utilisateur croie qu'il n'a aucune donnée alors que c'est juste son filtre. Le lien reset doit vider tous les filtres en un clic (utile avec des filtres multi-dimensions).

---

_Ce catalogue grandit avec le temps. Après chaque `/lm-ux-delight`, les nouveaux patterns
découverts et adoptés sont ajoutés ici._
