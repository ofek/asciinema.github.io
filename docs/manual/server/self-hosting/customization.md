# Customization

If the variables in `.env.production` file are not enough for your needs then
you can easily edit source code and rebuild the image.

Let's take max upload size as an example. We'll change it to 32MB. We need to
edit 2 files.

Switch to a new branch (or the one you created in "Clone the repository" step
earlier):

    git checkout -b my-company

First, edit `docker/nginx/asciinema.conf` file, applying this change:

```diff
-client_max_body_size 16m
+client_max_body_size 32m
```

Then, edit `lib/asciinema_web/endpoint.ex` file, applying this change:

```diff
-plug Plug.Parsers,
-    parsers: [:urlencoded, :multipart, :json],
-    pass: ["*/*"],
-    json_decoder: Phoenix.json_library()
+plug Plug.Parsers,
+    parsers: [:urlencoded, :multipart, :json],
+    pass: ["*/*"],
+    json_decoder: Phoenix.json_library(),
+    length: 32_000_000
```

Now, stop `phoenix` container:

    docker-compose stop phoenix

Rebuild the image:

    docker build -t ghcr.io/asciinema/asciinema-server .

Start new `phoenix` container:

    docker-compose up -d phoenix

If all is good then commit your customization (so you can fetch and merge latest
version in the future):

    git add -A .
    git commit -m "Increased upload size limit to 32MB"
