# Docker Synapse [Matrix] server

A Synapse container for [Matrix] messaging.

> This Docker service is intended to run with my [NGINX proxy entrypoint](https://github.com/valfur03/nginx-proxy-entrypoint) repo.

## Configuration

### Postgres password

You need to write the postgres user's password in `psql_password.txt`.

### Sample files

After you've cloned the repo, remove the `.sample` extension from files, and fill in the parameters.

#### host.env

```
VIRTUAL_HOST		= <domain of the synapse server> (e.g. synapse.example.com)
LETSENCRYPT_HOST	= <the same as VIRTUAL_HOST>
```

> When using a subdomain for the `SYNAPSE_SERVER_NAME`, user IDs, room aliases, etc will look like `*:synapse.example.com`.
> If you still want to use your base domain as the server name, read about [delegation](https://matrix-org.github.io/synapse/latest/delegate.html).

### Generate configuration file

```sh
docker run -it --rm \
	--volume synapse-data:/data
    -e SYNAPSE_SERVER_NAME=<your server name (e.g. example.com)> \
    -e SYNAPSE_REPORT_STATS=no \
    matrixdotorg/synapse:latest generate
```

This docker command will create the `homeserver.yaml` file.

This file will be the base configuration file of your Synapse server, and will reside, by default, in a volume called `synapse-data`.

On your local machine, it should be in `/var/lib/docker/volumes/<synapse-data volume>/_data/homeserver.yaml` (need root privileges).

### The database

The base Synapse Docker image does not allow us to automate the configuration, so you'll have to dive in yourself. Don't worry though, it is not that complicated.

Edit the `homeserver.yaml` file, and replace the following lines...

```yaml
database:
	name: sqlite3
	args:
		database: /data/homeserver.yaml
```

with...

```yaml
database:
  name: psycopg2
  txn_limit: 10000
  args:
    user: synapse
    password: <the password you set in the `psql_password.txt` file>
    database: synapse
    host: database
    cp_min: 5
    cp_max: 10
```

## Usage

### Launch the server

To launch your server, run `docker-compose up` (with `-d` to daemonize).

### Adding users

To add users, run `docker exec -it <synapse container name/ID> register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml`
