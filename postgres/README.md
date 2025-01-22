# bastille-postgresql
[Bastille](https://github.com/bastillebsd/bastille) template for running PostgreSQL server in a FreeBSD jail

By default, it installs the recent version of PostgreSQL (15) avilable in ports. You can use `ARG` option to choose a
different version while applying the template (see usage).

## Bootstrap

```shell
bastille bootstrap https://github.com/yaazkal/bst
```

## Usage

Install latest version of postgresql-server

```shell
bastille template TARGET yaazkal/bst/postgres
```

Install a specific version (i.e 14) of postgresql-server

```shell
bastille template TARGET yaazkal/bst/postgres --arg version=14
```
## Arguments

This template receive these arguments:

| Argument    | Default | Description                                    |
|-------------|---------|------------------------------------------------|
| `version`   | 15      | PostgreSQL database server version to install  |

