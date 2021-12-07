include				synapse.mk
include				host.mk
SYNAPSE_DATA		= synapse-data
SYNAPSE_IMAGE		= matrixdotorg/synapse
SYNAPSE_PORT		= 8008

CONTAINER_NAME		= synapse
CERTS_NETWORK		= certs

RM					= rm -f

all:
	docker run --detach --name $(CONTAINER_NAME) --volume $(SYNAPSE_DATA):/data -p $(SYNAPSE_PORT):$(SYNAPSE_PORT) --expose $(SYNAPSE_PORT) --network $(CERTS_NETWORK) --env "VIRTUAL_HOST=$(VIRTUAL_HOST)" --env "VIRTUAL_PORT=$(VIRTUAL_PORT)" --env "LETSENCRYPT_HOST=$(LETSENCRYPT_HOST)" $(SYNAPSE_IMAGE)

gen:
	docker run -it --rm --volume $(SYNAPSE_DATA):/data -e SYNAPSE_SERVER_NAME=$(SYNAPSE_SERVER_NAME) -e SYNAPSE_REPORT_STATS=$(SYNAPSE_REPORT_STATS) $(SYNAPSE_IMAGE) generate

user:
	docker exec -it $(CONTAINER_NAME) register_new_matrix_user http://localhost:$(SYNAPSE_PORT) -c /data/homeserver.yaml

synapse.mk:
	@echo "Generating a sample `$@` file. Please edit variables inside."
	@echo -n > $@
	@echo "# This file was automatically generated." >> $@
	@echo >> $@
	@echo "SYNAPSE_SERVER_NAME		= " >> $@
	@echo "SYNAPSE_REPORT_STATS	= no" >> $@
	@exit 1

host.mk:
	@echo "Generating a sample `$@` file. Please edit variables inside."
	@echo -n > $@
	@echo "# This file was automatically generated." >> $@
	@echo >> $@
	@echo "VIRTUAL_HOST		= " >> $@
	@echo "VIRTUAL_PORT		= 8008" >> $@
	@echo "LETSENCRYPT_HOST	= " >> $@
	@exit 1

clean:
	$(RM) synapse.mk host.mk

.PHONY: all gen clean
