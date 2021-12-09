#!/bin/sh

cat $POSTGRES_PASSWORD_FILE $POSTGRES_PASSWORD_FILE | createuser --pwprompt synapse

createdb --encoding=UTF8 --locale=C --template=template0 --owner=synapse synapse
