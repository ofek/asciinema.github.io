# Installation

The only officially supported installation procedure of asciinema web app
is [Docker](https://www.docker.com/) based. You must have SSH access to a
64-bit Linux server with Docker support.

If you really, really want to install everything manually then look
at [Dockerfile](https://github.com/asciinema/asciinema-server/blob/main/Dockerfile) and [docker-compose.yml](https://github.com/asciinema/asciinema-server/blob/main/docker-compose.yml)
to see what's required by the app.

However, with the official container image you get the battle tested configuration (similar to what's running
on asciinema.org), in a stable container, along with all required services preconfigured.
It also makes upgrading to new versions much easier.

## Hardware Requirements

- modern single core CPU, dual core recommended
- 1 GB RAM minimum (with swap)
- 64 bit Linux compatible with Docker
- 10 GB disk space minimum

## Service Requirements

asciinema web app requires the following services:

- [Postgres 12.0+](http://www.postgresql.org/download/)
- SMTP server

If you go with the provided [docker-compose.yml](https://github.com/asciinema/asciinema-server/blob/main/docker-compose.yml) file you
don't need to worry about these - they're included and already configured to
work with this app.

## Installation

This guide assumes you already
have [Docker engine](https://docs.docker.com/engine/)
and [docker-compose](https://docs.docker.com/compose/) running on the
installation host.

You don't have to use docker-compose to use asciinema web app Docker image. Feel
free to inspect `docker-compose.yml` file and run required services manually with
`docker run ...`. However, for the sake of simplicity and to minimize
configuration issues the rest of this guide is based on the provided/suggested
docker-compose configuration.

### Clone the repository

    git clone --recursive https://github.com/asciinema/asciinema-server.git
    cd asciinema-server
    git checkout main

It's recommended to create a new branch, to keep any customizations separate
from main branch and make upgrading safer:

    git checkout -b my-company main

### Edit config file

You need to create `.env.production` config file. The easiest is to use
provided [.env.production.sample](https://github.com/asciinema/asciinema-server/blob/main/.env.production.sample) as a template:

    cp .env.production.sample .env.production
    nano .env.production

There are several variables which have to be set, like `URL_HOST` and
`SECRET_KEY_BASE`. The rest is optional, and most likely used when you want to
use your own SMTP or PostgreSQL server.

#### Basic settings

Set `URL_SCHEME`, `URL_HOST` and `URL_PORT` to match the address the users are supposed to reach this instance at. For example:

    URL_SCHEME=http
    URL_HOST=asciinema.example.com
    URL_PORT=80

Ensure you set the nginx port in the docker-compose.yml file equal to what you specified for `URL_PORT`.

Set `SECRET_KEY_BASE` to long random string. Run `docker-compose run --rm
phoenix gen_secret` to obtain one.

#### HTTPS settings

To enable HTTPS (in addition to HTTP), make the following changes.

In the repository root, create a directory named `certs`.
Copy your SSL/TLS certificate and private key into this directory.

In `.env.production`, set

    URL_SCHEME=https
    URL_PORT=443

In `docker-compose.yml`, uncomment these two lines (they are marked in the file):

    - "443:443"
    - ./certs:/app/priv/certs

In `docker/nginx/asciinema.conf`, uncomment this section:

    listen 443 ssl;
    ssl_certificate     /app/priv/certs/<my-cert>.crt;
    ssl_certificate_key /app/priv/certs/<my-cert>.key;

Make sure to substitute the proper filenames for your certificate and private key files.

If you encounter problems, it may be helpful to run `docker exec -it asciinema_phoenix bash`
to enter a shell in the container, and then inspect the web server logs in `/var/log/nginx`.

#### SMTP settings

The app uses linked `namshi/smtp` container, which by default runs in "SMTP
Server" mode. Set `MAILNAME` env var to the outgoing mail hostname. For example, use the
same hostname as in `URL_HOST`.

See [SMTP configuration](https://github.com/asciinema/asciinema-server/wiki/SMTP-configuration)
for all SMTP configuration options.

#### Database settings

`DATABASE_URL` points to the linked `postgres` container
by default. You can set it so it points to your existing PostgreSQL server.
Look at "Service Requirements" above for minimum supported version.

#### Other application settings

There are several other options you can tweak by uncommenting the environment
variables in your `.env.production` file.

For example, public sign-ups are enabled by default. To disable them set:

```bash
SIGN_UP_DISABLED=true
```

See [.env.production.sample](https://github.com/asciinema/asciinema-server/blob/main/.env.production.sample)
for a full list of available config options.

### Specify volume mappings

The container has two volumes, for user uploads and for application logs. The
default `docker-compose.yml` maps them to the repository's `uploads` and `cache`
directories, you may wish to put them somewhere else.

Likewise, the PostgreSQL container has data volume that you may wish to
map somewhere where you know how to find it and back it up. By default
it's mapped inside repository's `volumes` directory.

### Pull latest Docker image

There's official stable [asciinema-server container
image](https://github.com/asciinema/asciinema-server/pkgs/container/asciinema-server)
which is regularly updated. Let's pull it now:

    docker pull ghcr.io/asciinema/asciinema-server:latest

If you skip this step, the `docker-compose` invocation in following section will
automatically build the image locally from scratch. Pulling it now will save you
time and trouble though.

### Create the database container

You have the config file ready and the data volumes mapped. It's time to set up
the database.

> Skip this step if you're using existing PostgreSQL server.

Start PostgreSQL container with:

    docker-compose up -d postgres

We do this separately from the following step to ensure PostgreSQL finishes its
initialization (usually takes couple of seconds) before the application can
connect to it.

### Create application and helper containers

The final step is to create the containers:

    docker-compose up -d

Check the status of newly created containers:

    docker ps -f 'name=asciinema_'

You should see `asciinema_phoenix`, `asciinema_postgres` and a few others listed.

Point your browser to `URL_HOST:URL_PORT` and enjoy your own asciinema hosting site!

## Using asciinema recorder with your instance

Once you have your instance running, point asciinema recorder to it by setting
API URL in `~/.config/asciinema/config` file as follows:

```ini
[api]
url = https://your.asciinema.host
```

Alternatively, you can set `ASCIINEMA_API_URL` environment variable:

    ASCIINEMA_API_URL=https://your.asciinema.host asciinema rec
