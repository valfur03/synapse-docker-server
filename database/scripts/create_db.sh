#!/bin/sh

cat /run/secrets/psql_password /run/secrets/psql_password | createuser --pwprompt synapse

createdb --encoding=UTF8 --locale=C --template=template0 --owner=synapse synapse
