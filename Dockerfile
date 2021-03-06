# My devbox Docker image.
#
# VERSION 0.0.1

from ubuntu:latest

env DEBIAN_FRONTEND noninteractive

# Install Ansible
run apt-get update && \
    apt-get install -y openssh-client ansible && \
    apt-get clean

# Add playbooks to the Docker image
copy provisioning /provisioning
workdir /provisioning

# Run Ansible to configure the Docker image
run ansible-playbook headless.yml -i inventory/docker

# Setup shared volume
volume /var/shared

# Setup working directory
workdir /home/dev

# Run everything below as the dev user
user dev

# Setup dev user environment
env HOME /home/dev
env PATH $HOME/bin:$PATH

entrypoint ["/usr/bin/ssh-agent", "/bin/zsh"]
