IMAGE_NAME ?= anisette-v3-server
REGISTRY ?= heifeng

TIMESTAMP := $(shell date +'%Y%m%d-%H%M%S')

.PHONY: builder build

builder:
	@echo "INFO: Building image $(IMAGE_NAME)-builder with tags: latest, $(TIMESTAMP)"
	docker buildx build \
		-f Dockerfile_builder \
		--platform linux/amd64 \
		-t $(REGISTRY)/$(IMAGE_NAME)-builder:latest \
		-t $(REGISTRY)/$(IMAGE_NAME)-builder:$(TIMESTAMP) \
		--load \
		.
	@echo "SUCCESS: Images: $(REGISTRY)/$(IMAGE_NAME)-builder available locally."
	@docker images $(REGISTRY)/$(IMAGE_NAME)-builder

build:
	@echo "INFO: Building and pushing image $(IMAGE_NAME) with tags: latest, $(TIMESTAMP)"
	docker buildx build \
		-f Dockerfile_builder \
		--platform linux/amd64 \
		-t $(REGISTRY)/$(IMAGE_NAME):latest \
		-t $(REGISTRY)/$(IMAGE_NAME):$(TIMESTAMP) \
		--push \
		.
	@echo "SUCCESS: Images: 	@docker images $(REGISTRY)/$(IMAGE_NAME) available locally."
	@docker images $(REGISTRY)/$(IMAGE_NAME)-builder

