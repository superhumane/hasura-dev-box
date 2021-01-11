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
RUN apt-get clean

# Install Haskell - https://www.haskell.org/ghcup/
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Add ghcup and cabal to path
RUN echo "[ -f \"${HOME}/.ghcup/env\" ] && source \"${HOME}/.ghcup/env\" # ghcup-env" >> "${HOME}/.bashrc"

