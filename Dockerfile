# from https://hub.docker.com/_/ubuntu/tags?page=1&name=22.04
FROM ubuntu:22.04@sha256:149d67e29f765f4db62aa52161009e99e389544e25a8f43c8c89d4a445a7ca37

ENV ENV_GITHUB_RUNNER_VERSION="2.311.0"
ENV ENV_GITHUB_RUNNER_VERSION_SHA=29fc8cf2dab4c195bb147384e7e2c94cfd4d4022c793b346a6175435265aa278
ENV ENV_YQ_VERSION="v4.30.6"

WORKDIR /

COPY dockerfile-setup.sh dockerfile-setup.sh
RUN bash dockerfile-setup.sh

COPY github-runner-entrypoint.sh /github-runner-entrypoint.sh
RUN chmod +x /github-runner-entrypoint.sh

# changed user to avoid root user
USER github

RUN whoami && \
  aws --version && \
  kubectl --help && \
  helm --help && \
  yq --version

ENTRYPOINT ["/github-runner-entrypoint.sh"]
