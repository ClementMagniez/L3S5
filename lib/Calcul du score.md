Gains généraux de points :

	=> Couvrir une case de gazon : 1 points
	=> Placer une tente : 5 points
	=> Retirer une tente : -10 points
_____
Bonus multiplicateur dû à la difficulté :

	=> Facile : x1.0
	=> Moyen : x1.5
	=> Difficile : x3.0
____
Calcul dépendant du mode de jeu :
	
	=> Aventure : gains généraux et bonus multiplicateur (aides impossibles)
	
	=> Exploration : calcul du mode aventure + malus infligés au bout de quelques aides
		-> Activation des malus en fonction de la taille de la grille
			--> Tailles 6 à 8	=> une aide gratuite
			--> Tailles 9 à 12	=> deux aides gratuites
			--> Tailles 13 à 16	=> trois aides gratuites
		-> Malus s'accumulant pour chaque grille
			--> Facile : -3%
			--> Moyen : -5%
			--> Difficile : -10%
	
	=> Contre-la-montre : calcul du mode exploration multiplié par le temps de jeu restant (total en secondes divisé par 100).
	
	=> Tutoriel : fenêtre d'explications, pas de score à afficher
____
Mise en place du système de calcul :

	=> Ajout d'une variable score et d'un compteur d'aides utilisées sur l'interface (fait)
	=> Modifier les fichiers "Case" pour intégrer les gains (fait)
	=> Trouver un moyen efficace d'envoyer les gains d'une case au score général (fait)
	
	=> Implémenter les conditions nécessaires au gain des malus dans les modes de jeu (à faire)
	=> Régler le souci de la conversion du temps restant (mode chrono) en entier (à faire)
	
