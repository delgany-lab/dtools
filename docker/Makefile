.PHONY: esp32 lab run-esp run-lab

esp32:
	DOCKER_BUILDKIT=1 docker build \
		--build-arg="USER=${USER}" \
		--build-arg="UID=$(shell id -u ${USER})" \
		--build-arg="GID=$(shell id -g ${USER})" \
		--target esp32 -t esp32:latest .

run-esp32:
	docker run --rm -it -v ${HOME}:${HOME} -v ${PWD}:/project -w /project --name esp32 --device=/dev/ttyUSB0 esp32:latest /bin/bash -c "source ~/.bashrc && tmux"

lab:
	DOCKER_BUILDKIT=1 docker build \
		--build-arg="USER=${USER}" \
		--build-arg="UID=$(shell id -u ${USER})" \
		--build-arg="GID=$(shell id -g ${USER})" \
		--target lab -t lab:latest .

run-lab:
	docker run --rm -it -v ${HOME}:${HOME} -w ~/Repo -p 1313:1313 lab:latest /bin/bash -c "source ~/.bashrc && tmux"
