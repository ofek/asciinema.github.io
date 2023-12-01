# Upgrading

Pull latest Docker image:

    docker pull ghcr.io/asciinema/asciinema-server:latest

Pull latest configs from upstream and merge it into your branch:

    git fetch origin
    git merge origin/main

Upgrade the containers:

    docker compose up -d
