#!/usr/bin/env bash

echo "✅ Start apt get install base packages"

apt-get update \
    && apt-get -y install curl git vim \
    && apt-get -y install zip unzip \
    && apt-get -y install ca-certificates curl wget apt-transport-https lsb-release gnupg \
    && apt-get -y install jq \
    && apt-get satisfy "python3-pip  (<= 22.1)" -y
    # install jq from https://stedolan.github.io/jq/download/

# Test whoami
whoami

echo "✅ whoami > run as expected"

#
# Github Action runner
#
mkdir -p actions-runner
cd actions-runner || exit

# from https://github.com/actions/runner/releases
GITHUB_RUNNER_VERSION="${ENV_GITHUB_RUNNER_VERSION:-2.305.0}"
GITHUB_RUNNER_VERSION_SHA="${ENV_GITHUB_RUNNER_VERSION_SHA:-737bdcef6287a11672d6a5a752d70a7c96b4934de512b7eb283be6f51a563f2f}"
curl -o actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz
echo "${GITHUB_RUNNER_VERSION_SHA}  actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz" | sha256sum -c
tar xzf ./actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz
rm actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz

bash bin/installdependencies.sh
echo "✅ Installed > github action runner"

#
# AWS CLI
#
cd /tmp || exit
echo -n > awscli-pgp "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\
\n\
mQINBF2Cr7UBEADJZHcgusOJl7ENSyumXh85z0TRV0xJorM2B/JL0kHOyigQluUG\n\
ZMLhENaG0bYatdrKP+3H91lvK050pXwnO/R7fB/FSTouki4ciIx5OuLlnJZIxSzx\n\
PqGl0mkxImLNbGWoi6Lto0LYxqHN2iQtzlwTVmq9733zd3XfcXrZ3+LblHAgEt5G\n\
TfNxEKJ8soPLyWmwDH6HWCnjZ/aIQRBTIQ05uVeEoYxSh6wOai7ss/KveoSNBbYz\n\
gbdzoqI2Y8cgH2nbfgp3DSasaLZEdCSsIsK1u05CinE7k2qZ7KgKAUIcT/cR/grk\n\
C6VwsnDU0OUCideXcQ8WeHutqvgZH1JgKDbznoIzeQHJD238GEu+eKhRHcz8/jeG\n\
94zkcgJOz3KbZGYMiTh277Fvj9zzvZsbMBCedV1BTg3TqgvdX4bdkhf5cH+7NtWO\n\
lrFj6UwAsGukBTAOxC0l/dnSmZhJ7Z1KmEWilro/gOrjtOxqRQutlIqG22TaqoPG\n\
fYVN+en3Zwbt97kcgZDwqbuykNt64oZWc4XKCa3mprEGC3IbJTBFqglXmZ7l9ywG\n\
EEUJYOlb2XrSuPWml39beWdKM8kzr1OjnlOm6+lpTRCBfo0wa9F8YZRhHPAkwKkX\n\
XDeOGpWRj4ohOx0d2GWkyV5xyN14p2tQOCdOODmz80yUTgRpPVQUtOEhXQARAQAB\n\
tCFBV1MgQ0xJIFRlYW0gPGF3cy1jbGlAYW1hem9uLmNvbT6JAlQEEwEIAD4WIQT7\n\
Xbd/1cEYuAURraimMQrMRnJHXAUCXYKvtQIbAwUJB4TOAAULCQgHAgYVCgkICwIE\n\
FgIDAQIeAQIXgAAKCRCmMQrMRnJHXJIXEAChLUIkg80uPUkGjE3jejvQSA1aWuAM\n\
yzy6fdpdlRUz6M6nmsUhOExjVIvibEJpzK5mhuSZ4lb0vJ2ZUPgCv4zs2nBd7BGJ\n\
MxKiWgBReGvTdqZ0SzyYH4PYCJSE732x/Fw9hfnh1dMTXNcrQXzwOmmFNNegG0Ox\n\
au+VnpcR5Kz3smiTrIwZbRudo1ijhCYPQ7t5CMp9kjC6bObvy1hSIg2xNbMAN/Do\n\
ikebAl36uA6Y/Uczjj3GxZW4ZWeFirMidKbtqvUz2y0UFszobjiBSqZZHCreC34B\n\
hw9bFNpuWC/0SrXgohdsc6vK50pDGdV5kM2qo9tMQ/izsAwTh/d/GzZv8H4lV9eO\n\
tEis+EpR497PaxKKh9tJf0N6Q1YLRHof5xePZtOIlS3gfvsH5hXA3HJ9yIxb8T0H\n\
QYmVr3aIUes20i6meI3fuV36VFupwfrTKaL7VXnsrK2fq5cRvyJLNzXucg0WAjPF\n\
RrAGLzY7nP1xeg1a0aeP+pdsqjqlPJom8OCWc1+6DWbg0jsC74WoesAqgBItODMB\n\
rsal1y/q+bPzpsnWjzHV8+1/EtZmSc8ZUGSJOPkfC7hObnfkl18h+1QtKTjZme4d\n\
H17gsBJr+opwJw/Zio2LMjQBOqlm3K1A4zFTh7wBC7He6KPQea1p2XAMgtvATtNe\n\
YLZATHZKTJyiqA==\n\
=vYOk\n\
-----END PGP PUBLIC KEY BLOCK-----"
gpg --import awscli-pgp
curl -o awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
curl -o awscliv2.sig "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig"
gpg --verify awscliv2.sig awscliv2.zip
unzip -q awscliv2.zip && ./aws/install
rm -fr "aws*"

## Test awscli
aws --version || exit
echo "✅ Installed > awscli"

#
# KUBERNETES DEPENDENCIES
#
# install kubectl from https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

# install helm from https://helm.sh/docs/intro/install/#from-apt-debianubuntu
curl https://baltocdn.com/helm/signing.asc | apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list

apt-get update
echo "✅ Configure kubernetes & Helm for installation"

apt-get satisfy -y "kubectl"
## Test kubectl
kubectl version --short || exit
echo "✅ Installed kubernetes"

apt-get satisfy "helm" -y
## Test helm
helm --help
echo "✅ Installed kubernetes"

# install yq from https://github.com/mikefarah/yq#install
YQ_VERSION="${ENV_YQ_VERSION:-v4.30.6}"
YQ_BINARY="yq_linux_amd64"
wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}.tar.gz -O - | tar xz && mv ${YQ_BINARY} /usr/bin/yq
echo "✅ Installed YQ"

## Test YQ
yq --version

#
# USER CONFIGURATIONS
#
useradd github
mkdir -p /home/github
chown -R github:github /home/github
chown -R github:github /actions-runner
