# Makefile to build OpenSUSE Leap 15.6 images with Packer + QEMU

IMAGE_NAME=opensuse-15.6
CONTAINER_NAME=packer-qemu
PACKER_TEMPLATE=packer/

# Build the container image with Packer and QEMU
docker-build:
	docker build -t $(CONTAINER_NAME) .

# Run Packer inside the container to generate the OpenSUSE image
image-build: docker-build
	docker run --rm -it --privileged --network=host -v $(PWD):/workspace $(CONTAINER_NAME) /bin/bash -c "packer build $(PACKER_TEMPLATE)"

# Clean local artifacts
clean-artifacts:
	rm -rf artifacts/*

# Show the list of supported qemu-kvm machines (useful for packer configuration)
qemu-kvm-machines: docker-build
	docker run --rm -it --entrypoint /usr/bin/qemu-system-x86_64 $(CONTAINER_NAME) -machine help

# Check if the VM can reach the host filesystem or HTTP server (useful for debugging AutoYaST downloads)
check-filesystem-reachability:
	docker run --rm -it -v $(PWD):/workspace $(CONTAINER_NAME) /bin/bash -c "ls /workspace/packer/http/"
