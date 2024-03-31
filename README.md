# Proposition

## Données
Le dataset vise à identifier les corrélations qui existent entre la musique et la santé mentale autodéclarée d'un individu, que ce soit à travers l'écoute de styles particuliers, par la pratique d'un instrument ou encore par la composition.

La collecte des données a été gérée via un formulaire Google. Les répondants n'étaient pas limités par l'âge ou le lieu.

Le formulaire a été publié sur divers forums Reddit, serveurs Discord et plateformes de médias sociaux. Des affiches ont également été utilisées pour annoncer le formulaire dans les bibliothèques, les parcs et autres lieux publics.

Le formulaire était relativement bref afin que les répondants soient plus susceptibles de terminer le sondage. Les questions « plus difficiles » (telles que le BPM) sont restées facultatives pour la même raison.

Ainsi, nous avons un total de 736 observations pour 33 features.

5 d'entre-elles sont de type booléen :
* While working (écoute de la musique en travaillant / étudiant)
* Instrumentalist (régulièrement)
* Composer
* Exploratory (explore régulièrement de nouveaux artistes / styles de musique)
* Foreign languages (écoute régulièrement de la musique en langue étrangère)

6 sont de type entier :
* Age
* BPM (nombre de battements par minute du style de musique favori)
* Anxiety (échelle de 0 à 10)
* Depression (de même)
* Insomnia (de même)
* OCD (de même)

1 de type flottant :
* Hours per day (de 0 à 24)

1 de type date :
* Timestamp (date de soumission de la réponse au formulaire)

et les 20 restantes sont de type string et sont ordonnables :
* Primary streaming (plateforme d'écoute principale)
* Fav genre
* Music effect (choix entre improve, no effect et worsen)
* Frequency (Classical) (choix entre never, rarely, sometimes et very frequently)
* Frequency (Country)
* Frequency (EDM)
* Frequency (Folk)
* Frequency (Gospel)
* Frequency (Hip hop)
* Frequency (Jazz)
* Frequency (K pop)
* Frequency (Latin)
* Frequency (Lofi)
* Frequency (Metal)
* Frequency (Pop)
* Frequency (R&B)
* Frequency (Rap)
* Frequency (Rock)
* Frequency (Video game)
* Permission (autorisation de rendre public la réponse, ainsi il n'y a qu'une seule valeur : i understand)

On retrouve réellement deux sous-groupes de features : les fréquences d'écoutes et les troubles mentaux.

## Plan d'analyse
Il y a une grande question que l'on se pose qui est "La Musique en générale est-elle corrélée à la santé mentale ?", que se soit en écoutant, jouant ou composant. Cette question en implique d'autres plus spécifiques. La plus évidente sûrement est de se demander si il y a corrélation entre le nombre d'heures d'écoute et la santé mentale. Logiquement, on s'attend à ce que la réponse soit positive, mais qu'au bout d'un certain nombre d'heures il n'y ait plus vraiment d'impact.

Également, on peut se demander si des styles de musiques aident plus que d'autres, ou si le BPM a un impact (bien que dans les deux cas, on se doute qu'on ne trouvera pas de corrélation). En fait on peut se poser la question de l'impact sur la plupart des features du dataset (jouer, composer, en travaillant, en langue étrangère, la curiosité). Aussi on peut regarder si certains problèmes mentaux sont plus corrélés à la musique que d'autres.

Cependant, ce qui risque de poser problème est l'interprétation des données, car nous pouvons très bien nous retrouver dans une situation intriqué : écouter de la musique peut peut-être aider à aller mieux, mais peut-être qu'également aller moins bien nous fait davantage écouter de la musique, et donc il deviendrait compliqué d'interpréter quelqconque resultat.
