# PARAMS SHELL

params_shell.sh allows the management of the parameters / arguments passed in the scripts.

By including this script at the beginning of your it is then possible to define:

 - the type of param (int / float / bool / mail ...),
 - to make a param mandatory,
 - to verify that an argument is not null,
 - and give a default value to a param.

This script also allows to have a more readable syntax for params / arguments

## Use

To pass a parameter to a script it is necessary to use the following syntax: ** - myParam = myArgument **

example:

```Bash
myScript.sh --name="DOE" --mail="j.doe.dom.fr" --password="password" --age=42 --size="1.92" --cash_account="true"
```

## Integration

** 1 - Installation **

** Debian / Ubuntu (.deb) **

In the near future ...

** RedHat / Centos (.rpm) **

In the near future ...

** Installation script **

```Bash
./install
```

** 2 - Construction of params **

example:

```Bash
. params-shell "$@" mandatory=name,email,password type_mail=mail not_null=name,email,password type_bool=account_active type_int=age type_float=size
```

** mandatory **: list of mandatory parameters (name, email, password)

** not_null **: list of params that must not be without argument (name, email, password)

** type_mail **: list of the parameters of type mail (mail)

** type_bool **: list of Boolean type parameters (active_account)

** type_int **: list of parameters of type integer (age)

** type_float **: list of params of type number with comma (size)

** 3 - Using params **

```Bash
echo ${PARAM[name]}
echo ${PARAM[mail]}
echo ...
```

Params no longer need to be passed in a specific order since they are named. This makes it easier to read scripts because we no longer have ** $ 1 $ 2 ... ** but ** ${PARAM[name]} ${PARAM[mail]} ... ** and also makes it easy to update scripts.

## Default values

To give a parameter a default value, just add the parameter with the value before "$@".

example:

```Bash
. params-shell --active_count=false "$@" type_bool=active_account
```

In this example, the "active_account" parameter will be set to "false".

## Add params types

It is possible to add or modify params types in the "params_shell.conf" configuration file placed at the same level as the "params_shell.sh" script.

example:

```
Type_alpha=^[a-zA-Z]*$
```

In this example we create the type of param "alpha" which takes only lowercase / uppercase letters.