# Upgrading

To upgrade your instance of asciinema server to the latest version:

- check the [releases](https://github.com/asciinema/asciinema-server/releases)
  for the latest version number
- read the release notes carefully, and follow the upgrade instructions
- update the `asciinema` container image tag to the latest number
- recreate the stack by running `docker compose up -d`

Release notes for each version include detailed information on the steps needed
for a successful upgrade. Backward compatibility is always a high priority when
cutting a new release, thus, breaking changes are more the exception than the
rule.

Usually, it's a matter of updating the container image tag:

```diff title="docker-compose.yml"
 services:
   asciinema:
-    image: ghcr.io/asciinema/asciinema-server:20240203
+    image: ghcr.io/asciinema/asciinema-server:20240324
     # ...
```

Then executing `docker compose up -d`.
