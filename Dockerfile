# Use Ubuntu 20.04 as the base image.
FROM ubuntu:20.04

# Set environment variable to prevent some prompts during package installation.
ENV DEBIAN_FRONTEND=non-interactive

# Update the package list and install necessary utilities, Git, Ansible, Python3, and pip3.
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    ansible \
    python3 \
    python3-pip

# Install networking tools
RUN apt-get update && apt-get install -y iputils-ping netcat traceroute

# Add HashiCorp's GPG key, install necessary utilities, add their repository, and then install Terraform.
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - >/dev/null \
    && apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install -y terraform

# Install Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && apt-get install azure-cli

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io

# Install code-server (VSCode server version).
RUN curl -fsSL https://code-server.dev/install.sh | sh
