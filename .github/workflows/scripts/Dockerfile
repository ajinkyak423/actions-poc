ARG RUNNER_VERSION
FROM ghcr.io/actions/actions-runner:${RUNNER_VERSION}
USER root

RUN apt install -y --no-install-recommends sudo make 

USER runner
