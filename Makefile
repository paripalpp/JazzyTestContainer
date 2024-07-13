RUNNER=podman
CONTAINER_NAME=JazzyTest
IMAGE_NAME=jazzy_test
IMAGE_TAG=least
WS_CONTAINER=/ros_ws
MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
build:
	$(RUNNER) build -t $(IMAGE_NAME):$(IMAGE_TAG) . --net=host
clean:
	rm -rf (WS_CONTAINER)/build/ (WS_CONTAINER)/install/ (WS_CONTAINER)/log/
run: build
	$(RUNNER) run \
	-it -d --rm --net=host --ipc=host --privileged --group-add keep-groups \
	--env="DISPLAY" \
	--env="PS1=""\[\e[1;36m\][\u@\h \W]\\$ \[\e[m\]""" \
	--volume="/dev:/dev:rw" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="$(MAKEFILE_DIR)$(WS_CONTAINER):$(WS_CONTAINER)" \
	--workdir="$(WS_CONTAINER)" \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME):$(IMAGE_TAG)
start:
	$(RUNNER) start $(CONTAINER_NAME)
stop:
	$(RUNNER) stop $(CONTAINER_NAME)
bash: 
	$(RUNNER) exec -it $(CONTAINER_NAME) bash \
	-c ". /opt/ros/jazzy/setup.bash && . $(WS_CONTAINER)/install/setup.bash && bash"
build_ws:
	$(RUNNER) exec -it $(CONTAINER_NAME) bash \
	-c ". /opt/ros/jazzy/setup.bash && colcon build"
code-server:
	$(RUNNER) exec -it $(CONTAINER_NAME) code-server --port=8080
