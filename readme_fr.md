# PARAMS SHELL

params_shell.sh permet la gestion des paramètres / arguments passés dans les scripts.

En incluant ce script au début du votre il est alors possible de définir :

 - le type de param (int/float/bool/mail ...),
 - de rendre obligation un param,
 - de vérifier qu'un argument est non null,
 - et de donner une valeur par défaut à un param.

Ce script permet aussi d'avoir une syntaxe plus lisible pour les params / arguments

## Utilisation

Pour passer un paramètre à un script il faut utiliser la syntaxe suivante : **--monParam=monArgument**

exemple :

```bash
monScript.sh --nom="DOE" --mail="j.doe.dom.fr" --mot_de_passe="password" --age=42 --taille="1.92" --compte_actif="true"
```

## Intégration

** 1 - Installation **

** Debian / Ubuntu (.deb) **

Bientôt ...

** RedHat / Centos (.rpm) **

Bientôt ...

** Script d'installation **

```Bash
./install
```

** 2 - Construction des params **

exemple :

```bash
. params-shell "$@" mandatory=nom,mail,mot_de_passe type_mail=mail not_null=nom,mail,mot_de_passe type_bool=compte_actif type_int=age type_float=taille
```

**mandatory** : liste des params obligatoire (nom,mail,mot_de_passe)

**not_null** : liste de params qui ne doivent pas être sans argument (nom,mail,mot_de_passe)

**type_mail** : liste des params de type mail (mail)

**type_bool** : liste des params de type booléen (compte_actif)

**type_int** : liste des params de type entier (age)

**type_float** : liste des params de type nombre avec virgule (taille)

** 3 - Utilisation des params **

```bash
echo ${PARAM[nom]}
echo ${PARAM[mail]}
echo ...
```

Les params n'ont plus besoin d'être passés dans un ordre précis puisqu'il sont nommés. Cela facilite la lecture des scripts car nous n'avons plus **$1 $2 ...** mais  **${PARAM[nom]} ${PARAM[mail]} ...** et facilite aussi la mise à jour des scripts.

## Valeurs par défaut

Pour donner une valeur par défaut à un paramètre il suffit d'ajouter avant "$@" le paramètre avec la valeur.

exemple :

```bash
. params-shell --compte_actif=false "$@"  type_bool=compte_actif
```

Dans cette exemple le param "compte_actif" aura pour valeur "false".

## Ajouter des types de params

Il est possible d'ajouter ou de modifier des types de params dans le fichier de configuration "params_shell.conf" placé au même niveau que le script "params_shell.sh".

exemple :

```
Type_alpha=^[a-zA-Z]*$
```

Dans cette exemple nous créons le type de param "alpha" qui ne prend que des lettre minuscules/majuscules.


