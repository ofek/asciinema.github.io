# Customization

In cases where the regular [configuration](configuration.md) is not enough, you
can build a custom asciinema server image. The server is built with [Elixir
language](https://elixir-lang.org/) and [Phoenix
framework](https://www.phoenixframework.org/). While not mainstream, this stack
is easy to work with.

Let's take max upload size as an example. We'll change it from the default 8MB
to more generous 32MB.

## Clone the repository

```sh
git clone https://github.com/asciinema/asciinema-server.git
```

## Create a new branch

```sh
git checkout main
git switch -c custom
```

## Make the changes

Edit `lib/asciinema_web/endpoint.ex` file, applying this change:

```diff hl_lines="9"
plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
-   json_decoder: Phoenix.json_library()
+   json_decoder: Phoenix.json_library(),
+   length: 32_000_000
```

Then, commit the changes.

## Rebuild the image

```sh
docker build -t ghcr.io/asciinema/asciinema-server:custom .
```

## Update the image tag

Update the `asciinema` container image tag to `custom`:

```diff title="docker-compose.yml"
services:
  asciinema:
-   image: ghcr.io/asciinema/asciinema-server:20231217
+   image: ghcr.io/asciinema/asciinema-server:custom
```

## Launch the new version

Finally, recreate the stack by running:

```sh
docker compose up -d
```
