FROM haskell:8.10.2-buster

# for apt and haskell to be noninteractive
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true

# Set UTC timezone
RUN echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections;

# Install required packages
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    openssl \
    libssl-dev \
    gcc \
    gsutil \
    nodejs \
    curl \
    git \
    postgresql \
    postgresql-contrib \
    postgresql-client \
    libkrb5-dev \
    libpq-dev

# Install latest version of npm
RUN curl https://www.npmjs.com/install.sh | sh

# Add gsutil - https://cloud.google.com/sdk/docs/install
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install -y apt-transport-https ca-certificates gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install -y google-cloud-sdk

RUN apt-get clean

