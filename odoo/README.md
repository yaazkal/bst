# Bastille Odoo template
[Bastille](https://github.com/bastillebsd/bastille) template for running Odoo as an app in FreeBSD.
Note that it does not come with a database server or reverse proxy by default. Check the "Arguments" section.
Uses latest Python 3.11 from ports.

## Bootstrap

```shell
bastille bootstrap https://github.com/yaazkal/bst
```

## Usage

```shell
bastille template TARGET yaazkal/bst/odoo
```

## Arguments

This template receive these arguments:

| Argument        | Default   | Description                  |
|-----------------|-----------|------------------------------|
| `version`       | 18.0      | Odoo version to install      |
| `edition`       | community | Odoo edition to install      |
| `db_host`       | False     | odoo.conf database host      |
| `db_port`       | 5432      | odoo.conf database port      |
| `db_user`       | odoo      | odoo.conf database user      |
| `db_password`   | False     | odoo.conf database password  |

Example:

```shell
bastille template TARGET yaazkal/bst/odoo --arg version=15.0
```
