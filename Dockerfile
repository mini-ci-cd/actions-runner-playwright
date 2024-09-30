FROM ghcr.io/actions/actions-runner:latest

USER root
RUN  apt update -q && apt install -qqy git uidmap jq sqlite3 lsof zstd curl wget  
USER runner
RUN  wget -q https://install.determinate.systems/nix/nix-installer-x86_64-linux && chmod +x nix-installer-x86_64-linux && \
  ./nix-installer-x86_64-linux install linux --no-start-daemon --no-confirm && sudo chown -R runner /nix  && rm nix-installer-x86_64-linux

ENV FORCE=1 
ENV DEVBOX_USE_VERSION=0.13.1 
RUN curl -fsSL https://get.jetify.com/devbox | bash
RUN mkdir /tmp/devbox && cd /tmp/devbox && devbox init && devbox add nodejs && \
  devbox run npx --yes playwright@1.47.2  install --with-deps chromium && \
  sudo rm -rf /nix  && sudo rm -rf /tmp/devbox