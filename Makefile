IMAGE := metacoma/mindwm-event-bar-eww
TAG := latest
IMAGE_HOME := /root/
DISPLAY := ${DISPLAY}
NATS_SERVER ?= "nats://root:r00tpass@ubuntu-dev:4222"
SUBJECT ?= "user-bebebeka.alice-host-broker-kne-trigger._knative"
CONTAINER_NAME := mindwm-event-bar
CONTAINER_SHELL := /bin/sh
.PHONY = build
build:
	docker build -t $(IMAGE):$(TAG) .

.PHONY = run
run: build
	xhost +local: && \
	docker run --name mindwm-event-bar --rm -it --entrypoint $(CONTAINER_SHELL) \
		--network=host \
		--device /dev/dri \
		-v `pwd`/eww_cache:$(IMAGE_HOME)/.cache \
		-v `pwd`:$(IMAGE_HOME)/.config/eww \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-w $(IMAGE_HOME)/.config/eww \
		-e KITTY_DISABLE_WAYLAND=1 \
		-e DISPLAY=$(DISPLAY) \
		-e NATS_SERVER=$(NATS_SERVER) \
		-e SUBJECT=$(SUBJECT) \
		$(IMAGE):$(TAG) \
		-c 'eww daemon; eww open mindwm-bar; python3 ./mindwm-bar.py'

		#-c /bin/sh
		

		#-c 'eww daemon; eww open mindwm-bar; python3 ./mindwm-bar.py'
.PHONY = exec
exec:
		docker exec -ti $(CONTAINER_NAME) $(CONTAINER_SHELL)
