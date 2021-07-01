# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.183.0/containers/go/.devcontainer/base.Dockerfile

# [Choice] Go version: 1, 1.16, 1.15
ARG VARIANT="1.16"
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT} as base-builder

# [Option] Install Node.js
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Install additional OS packages.
RUN set -x \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends gnupg software-properties-common curl \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
    && sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends terraform

# Install additional Go packages.
RUN set -x \
    && go get -v golang.org/x/tools/gopls 2>&1 \
    && go get -v github.com/uudashr/gopkgs/v2/cmd/gopkgs 2>&1 \
    && go get -v github.com/cweill/gotests/gotests 2>&1 \
    && go get -v github.com/josharian/impl 2>&1 \
    && go get -v honnef.co/go/tools/cmd/staticcheck 2>&1 \
    && go get -v gotest.tools/gotestsum 2>&1 \
    && rm -rf $GOPATH/pkg/* $GOPATH/src/* $HOME/.cache/go-build 


# shellspec, kcov and gh
FROM shellspec/shellspec-debian:kcov as shellspec-kov

# dev-container
FROM base-builder
COPY --from=shellspec-kov   /opt/shellspec              /opt/shellspec
COPY --from=shellspec-kov   /usr/local/bin/kcov*        /usr/local/bin/
COPY --from=shellspec-kov   /usr/local/share/doc/kcov   /usr/local/share/doc/kcov

# goss - Quick and Easy server validation
RUN set -ex \
    && curl -fsSL https://goss.rocks/install | sh

# taskctl
ENV TASKCTL_URL=https://raw.githubusercontent.com/taskctl/taskctl/master/install.sh
RUN set -x \
    && mkdir /tools \
    && curl -fsSL $TASKCTL_URL  | sh -s -- -b /tools
    
ENV PATH="/opt/shellspec:/tools:$PATH"
