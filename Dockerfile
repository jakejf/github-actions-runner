FROM ubuntu:20.04

ARG RUNNER_VERSION="2.316.1"
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETPLATFORM

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=linux-x64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=linux-arm64;

RUN apt update -y && apt upgrade -y && useradd -m docker
RUN apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${ARCHITECTURE}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-${ARCHITECTURE}-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]