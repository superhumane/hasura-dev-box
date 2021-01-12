FROM ubuntu:20.04

# for apt and haskell to be noninteractive
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
ARG BOOTSTRAP_HASKELL_NONINTERACTIVE=1

# Set UTC timezone
RUN echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections;

# Install required packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends build-essential libffi-dev libffi7 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5
RUN apt-get install -y --no-install-recommends libpq-dev libkrb5-dev python3 python3-pip python3-venv openssl libssl-dev gcc nodejs npm gsutil curl
RUN apt-get install -y libwww-perl git zlib1g-dev

# Add gsutil - https://cloud.google.com/sdk/docs/install
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install -y apt-transport-https ca-certificates gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install -y google-cloud-sdk

# RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && apt-get update -y && apt-get install google-cloud-sdk -y
      

RUN apt-get clean

# Install Haskell - https://www.haskell.org/ghcup/
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Fix for unfulfilled base, ci-info errors - https://github.com/hasura/graphql-engine/issues/4871#issuecomment-746858056
RUN /root/.ghcup/bin/ghcup rm ghc 8.8.4
RUN /root/.ghcup/bin/ghcup install ghc 8.10.2
RUN ln -s ~/.ghcup/bin/ghc-8.10 ~/.ghcup/bin/ghc

# Add ghcup and cabal to path
RUN echo "[ -f \"${HOME}/.ghcup/env\" ] && source \"${HOME}/.ghcup/env\" # ghcup-env" >> "${HOME}/.bashrc"