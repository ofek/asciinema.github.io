# Configuration

## General

### Base URL

The base URL of the server is configured with the following environment
variables:

- `URL_HOST` - the hostname (domain) of the server, defaults to `localhost`
- `URL_PORT` - the port it's accessible at, defaults to `4000`
- `URL_SCHEME` - the URL scheme, defaults to `http`

=== "HTTP"

    In HTTP-only configuration it may look like this:

    ```yaml title="docker-compose.yml"
    services:
      asciinema:
        # ...
        ports:
          - '80:4000'
        environment:
          - URL_HOST=asciinema.example.com
          - URL_PORT=80
          # ...
    ```

    The IP address of the server may also be used as the hostname:

    ```yaml title="docker-compose.yml"
    services:
      asciinema:
        # ...
        ports:
          - '80:4000'
        environment:
          - URL_HOST=192.168.10.20
          - URL_PORT=80
          # ...
    ```

=== "HTTPS"

    In HTTPS configuration it may look like this:

    ```yaml title="docker-compose.yml"
    services:
      asciinema:
        # ...
        environment:
          - URL_HOST=asciinema.example.com
          - URL_SCHEME=https
          # ...
    ```

    Setting `URL_SCHEME=https` automatically sets the port to 443. This can be
    overriden by setting`URL_PORT` explicitly.

    For a complete HTTPS setup see [HTTPS](#https).

To verify the URL configuration, start the server, open the logs, and search for
a line that looks like this:

```
Access AsciinemaWeb.Endpoint at http://asciinema.example.com
```

It should reflect the `URL_*` settings.

### Secret key base

The `SECRET_KEY_BASE` environment variable is used for cryptographic operations,
such as signing and verification of session cookies. It must be set to a string
of 64 (or more) random characters.

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      - SECRET_KEY_BASE=...
      # ...
```

One way to generate it is to use the following shell command:

```sh
tr -dc A-Za-z0-9 </dev/urandom | head -c 64; echo
```

!!! info

    While the server will start without the `SECRET_KEY_BASE` variable set (as
    we've seen in [getting started
    guide](../../../getting-started.md#self-hosting-the-server)), the login
    sessions won't survive the `asciinema` container restart without it.

### Signup

By default anyone can sign up for a user account on asciinema server. Setting
`SIGN_UP_DISABLED=true` disables public signups, allowing login for existing
users only.

A typical use-case for disabling signup is a personal server. After creating a
user account for yourself, you can lock the server down, effectively making it a
single-user asciinema server.

### Admin contact email

When setting up a public instance of asciinema server, it's advised to set
`CONTACT_EMAIL_ADDRESS` to the email address of the person who manages the
server, i.e. you.

The contact email address is displayed on server's `/about` page, which is
linked from the footer. Having it lets users of your asciinema server to reach
you when facing issues.

[Here](https://asciinema.org/about) is one on asciinema.org.

## Database

asciinema server utilizes a PostgreSQL database for storing recording metadata
and user account information, among other data.

The `DATABASE_URL` environment variable configures the database connection. It
use the standard format of
`postgresql://username:password@hostname:port/dbname`. Port number can be
ommited when connecting to the standard PostgreSQL port 5432.

### PostgreSQL container

If you don't have an existing PostgreSQL server, the easiest way to get one
running is to use the official PostgreSQL OCI image. Here's an example:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    depends_on:
      postgres:
        condition: service_healthy

  postgres:
    image: docker.io/library/postgres:14
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U postgres']
      interval: 2s
      timeout: 5s
      retries: 10

volumes:
  postgres_data:
```

asciinema server container image uses a default value
`postgresql://postgres@postgres/postgres` for `DATABASE_URL`, enabling it to
connect to the `postgres` container automatically.

The `postgres` container runs PostgreSQL server with the authentication method
set to `trust`, effectively disabling authentication. Generally, this approach
is not recommended.  However, in our setup, this configuration is acceptable,
because the database is only accessible internally by the `asciinema` container
(we don't expose the `postgres` port on the host machine).

By using `depends_on` with `service_healthy` condition we ensure the `asciinema`
container is started only after database health-checks pass. This is to prevent
asciinema server's boot procedure crashing while the database is still
initializing.

We used volume mapping for PostgreSQL's data directory, but you can also
bind-mount it to a directory on the host system like this:

```yaml title="docker-compose.yml"
services:
  # ...

  postgres:
    image: docker.io/library/postgres:14
    volumes:
      - /path/to/postgres/data:/var/lib/postgresql/data
```

!!! tip

    Don't forget to set up an automated backup of this directory!

### External PostgreSQL server

If you have an existing PostgreSQL server (14 or higher), set the `DATABASE_URL`
environment variable accordingly:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      - DATABASE_URL=postgresql://username:password@hostname/dbname
```

The connection URL supports the following extra parameters after `?` at the end
of the connection string:

- `ssl=true` - enable connection encryption, defaults to `false`
- `pool_size=N` - set the size of the connection pool, defaults to 10

For example, to connect to the server at 10.9.8.7 as user `asciinema` using
encrypted connection, setting the connection pool size to 2, use the following
URL:

```
DATABASE_URL=postgresql://asciinema:xxx@10.9.8.7/asciinema?ssl=true&pool_size=2
```

The database user (`asciinema`) must have full write permissions to this
database (`asciinema`), including the ability to make any schema changes, such
as `CREATE/ALTER/DROP TABLE/COLUMN`.

## File store

asciinema server stores uploaded [asciicast](../../asciicast/v2.md) files in a
configured file store. By default it utilizes the local filesystem, but one can
use any S3-compatible object store, such as [AWS
S3](https://aws.amazon.com/s3/), [Cloudflare
R2](https://www.cloudflare.com/developer-platform/r2/), or a self-hosted
[MinIO](https://min.io) server.

### Local filesystem

With the local filesystem used as the file store, the files are saved in
`/var/opt/asciinema`. Mapping this directory to a volume is necessary for data
persistence:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    volumes:
      - asciinema_data:/var/opt/asciinema

volumes:
  asciinema_data:
```

Alternatively, you can bind-mount it to a directory on the host system like this:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    volumes:
      - /path/to/asciinema/data:/var/opt/asciinema
```

!!! tip

    Similarly to the database data directory, it's advised to set up automated
    backup for this one too.

### AWS S3

To use AWS S3 for file storage, set the following environment variables for the
`asciinema` container, adjusted accordingly:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      - S3_BUCKET=your-asciinema-bucket
      - S3_ACCESS_KEY_ID=your-aws-access-key-id
      - S3_SECRET_ACCESS_KEY=your-aws-secret-access-key
      - S3_REGION=us-east-1
```

### Cloudflare R2

[R2](https://www.cloudflare.com/developer-platform/r2/) is an S3-compatible
object store offered by Cloudflare. To use R2 for file storage set the following
environment variables for the `asciinema` container:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      - S3_BUCKET=your-asciinema-bucket
      - S3_ENDPOINT=https://<ACCOUNT_ID>.r2.cloudflarestorage.com
      - S3_ACCESS_KEY_ID=your-r2-access-key-id
      - S3_SECRET_ACCESS_KEY=your-r2-secret-access-key
      - S3_REGION=auto
```

Refer to the [R2 documentation](https://developers.cloudflare.com/r2) for
information on obtaining the account ID and the access key.

## Email

asciinema server needs an SMTP server to deliver emails containing short-lived
login links.

When no SMTP server is configured (default), no mail is sent. However, you can
obtain a login link from the server container logs after entering your email
address on the login page. Search for a line containing `Asciinema.Emails.Job`,
and open the URL found on that line in the browser. This is fine for testing, or
a single-user server, but for a multi-user setup SMTP is necessary.

SMTP settings are configured with `SMTP_*` set of environment variables. The
main ones are `SMTP_HOST`, `SMTP_USERNAME` and `SMTP_PASSWORD`.

For example:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      # ...
      - SMTP_HOST=smtp.example.com
      - SMTP_USERNAME=foobar
      - SMTP_PASSWORD=hunter2
```

Here's a complete list of available SMTP settings:

- `SMTP_HOST` - required
- `SMTP_PORT` - defaults to 587
- `SMTP_USERNAME` - usually required by the SMTP server
- `SMTP_PASSWORD` - usually required by the SMTP server
- `SMTP_FROM_ADDRESS` - address for the `From` header, defaults to `hello@$URL_HOST`
- `SMTP_REPLY_TO_ADDRESS` - address for the `Reply-To` header, defaults to `admin@$URL_HOST`
- `SMTP_TLS` - set to `always`, `never` or `if_available`, defaults to `if_available`
- `SMTP_ALLOWED_TLS_VERSIONS` - set allowed TLS versions, defaults to `tlsv1,tlsv1.1,tlsv1.2`
- `SMTP_AUTH` - set to `always` or `if_available`, defaults to `if_available`
- `SMTP_NO_MX_LOOKUPS` - set to `true` to disable MX lookups and connect directly to the server of receipient's domain

Below you'll find example SMTP configurations for selected providers.

You can test SMTP configuration by sending a test email using the following
command:

```sh
docker compose exec asciinema send-test-email your@email.example.com
```

### Fastmail

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      # ...
      - SMTP_HOST=smtp.fastmail.com
      - SMTP_USERNAME=your-username@fastmail.com
      - SMTP_PASSWORD=your-fastmail-app-password
```

You need to use an "app password" instead of your regular Fastmail account
password. You can generate one on Fastmail's settings page, in the Privacy &
Security -> Integrations section. Check [Fastmail SMTP
docs](https://www.fastmail.help/hc/en-us/articles/1500000279921-IMAP-POP-and-SMTP)
for further information.

### Gmail

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      # ...
      - SMTP_HOST=smtp.gmail.com
      - SMTP_USERNAME=your-username@gmail.com
      - SMTP_PASSWORD=your-gmail-app-password
```

You need to use an "app password" instead of your regular Google account
password. Check [Google app passwords
docs](https://support.google.com/mail/answer/185833?hl=en) for further
information.

### Mailgun

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      # ...
      - SMTP_HOST=smtp.mailgun.org
      - SMTP_USERNAME=postmaster@mg.your.domain
      - SMTP_PASSWORD=your-mailgun-password
```

Check [Mailgun SMTP
docs](https://documentation.mailgun.com/en/latest/quickstart-sending.html#send-via-smtp)
for instructions on how to obtain SMTP credentials.

### AWS SES

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      # ...
      - SMTP_HOST=email-smtp.eu-west-1.amazonaws.com
      - SMTP_USERNAME=your-ses-smtp-username
      - SMTP_PASSWORD=your-ses-smtp-password
```

Check [AWS SES SMTP
docs](https://docs.aws.amazon.com/ses/latest/dg/send-email-smtp.html) for
instructions on how to obtain SMTP credentials.

## HTTPS

Implementing HTTPS for asciinema server is typically done by putting a reverse
proxy, a web server, or a cloud provider's load balancer in front of it. A web
server, such as Nginx or Apache, combined with [Let's
Encrypt](https://letsencrypt.org/) can be used for that.

Regardless of the solution, asciinema server needs to know that you're using
HTTPS, which is done by setting the `URL_SCHEME=https` environment variable.

### Caddy

The easiest solution is to use [Caddy web server](https://caddyserver.com/) in
reverse proxy mode. For example:

```yaml title="docker-compose.yml"
services:
  asciinema:
    # ...
    environment:
      # ...
      - URL_HOST=asciinema.example.com
      - URL_SCHEME=https

  caddy:
    image: caddy:2
    command: caddy reverse-proxy --from https://asciinema.example.com --to http://asciinema:4000
    ports:
      - '80:80'
      - '443:443'
      - '443:443/udp'
    volumes:
      - caddy_data:/data
      - caddy_config:/config

volumes:
  # ...
  caddy_data:
  caddy_config:
```

The command `caddy reverse-proxy --from https://asciinema.example.com --to
http://asciinema:4000` tells Caddy to obtain and automatically renew a TLS
certificate for the `asciinema.example.com` domain, terminate the TLS
connections on port 443, and forward the requests to the `asciinema` container
on port `4000`.

The DNS record for your server must match the `URL_HOST`, and the Caddy `--from`
argument must use the same domain too.

!!! warning

    Before starting Caddy ensure ports 80 and 443 are open to the internet, and
    that a DNS record already points to your server's IP. Otherwise Caddy won't
    be able to perform the HTTP challenge when requesting a certificate from
    Let's Encrypt, which could risk a temporary ban for this IP.

### Other reverse proxy

If you prefer to use something else for TLS termination then you need to forward
the HTTP requests to port `4000` of the `asciinema` container. This requires
mapping the port `4000` on the host machine:

```yaml title="docker-compose.yml" hl_lines="4-5"
services:
  asciinema:
    # ...
    ports:
      - '4000:4000'
    environment:
      # ...
      - URL_HOST=asciinema.example.com
      - URL_SCHEME=https
```

With `URL_SCHEME=https`, a default HTTPS port 443 is assumed. If you need to use
another port, use `URL_PORT` variable, e.g `URL_PORT=8443`.

## Advanced configuration

Usually the environment variables described earlier are sufficient to configure
asciinema server to suit your needs.

In special cases you may want to hook into [Phoenix
framework](https://www.phoenixframework.org/) runtime configuration in order to
override certain settings found in the [server's config
directory](https://github.com/asciinema/asciinema-server/tree/main/config).

To do that, create `custom.exs` file containing configuration overrides, then
bind-mount the file at `/opt/app/etc/custom.exs` in the container:

```elixir title="custom.exs"
import Config

config :asciinema,
  foo: 123,
  bar: "baz"
```

```yaml title="docker-compose.yml" hl_lines="6"
services:
  asciinema:
    # ...
    volumes:
      - asciinema_data:/var/opt/asciinema
      - ./custom.exs:/opt/app/etc/custom.exs
    # ...
```

If the changes you'd like to make are not possible through the configuration,
check [how to customize](customization.md) the server by changing its source
code and building a custom container image. This may require a bit of
Elixir/Phoenix knowledge though.

For non-trivial customizations you may want to consider using [asciinema
consulting services](../../../consulting.md).
