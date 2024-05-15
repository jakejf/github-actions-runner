FROM ubuntu:20.04

ARG RUNNER_VERSION="2.316.1"
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETOS TARGETARCH

RUN apt update -y && apt upgrade -y && useradd -m docker

RUN apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${TARGETOS}-${TARGETARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-${TARGETOS}-${TARGETARCH}-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]