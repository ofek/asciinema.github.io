# Getting started

This guide serves as your introduction to asciinema, starting with the basics of
recording a terminal with [the asciinema CLI](../manual/cli/). We'll cover how
to share recordings via [asciinema.org](https://asciinema.org), embed [the
player](../manual/player/) on a website, and conclude with instructions for
self-hosting [the server](../manual/server).

## Recording

Install the asciinema CLI first. There are several installation options to
choose from:

=== "pipx"

    ``` bash
    pipx install asciinema
    ```

=== "apt (Debian, Ubuntu)"

    ``` bash
    sudo apt install asciinema
    ```

=== "pacman (Arch, Manjaro)"

    ``` bash
    sudo pacman -S asciinema
    ```

=== "homebrew (macOS)"

    ``` bash
    brew install asciinema
    ```

=== "Other"

    Check the [Installation](../manual/cli/installation/) section for all installation options.

Now record your terminal with:

```sh
asciinema rec first.cast
```

This starts a new recording session, where everything printed to a terminal gets
captured and saved to the `first.cast` file in
[asciicast](../manual/asciicast/v2/) format.

To end the recording session simply exit the shell. This can be done by pressing
<kbd>ctrl-d</kbd> or entering <code>exit</code>.

Replay your recording with:

```sh
asciinema play first.cast
```

You can pause/resume by pressing <kbd>space</kbd>, or end the playback early by
pressing <kbd>ctrl+c</kbd>.

See [asciinema CLI quick-start guide](../manual/cli/quick-start/) for more
examples.

## Sharing

Replaying a recording in your terminal is handy but not as useful as sharing it
with the wider audience on the internet.

You can host your recordings at [asciinema.org](https://asciinema.org), which is
a hosting platform for terminal recordings powered by [asciinema
server](../manual/server/). _Hosting your recordings on asciinema.org is
completely optional_ but has many benefits, e.g. easy sharing and embedding.

Upload your recording to asciinema.org with:

```sh
asciinema upload first.cast
```

The command prints a secret link to the recording page, where you can view it.
Feel free to share the link with anyone.

The player component on the recording page is not a typical video player. It's
[asciinema player](../manual/player/), built from the ground up to play terminal
sessions. It lets you copy the contents of its terminal view, just like in a
regular terminal. Try it: pause the playback, select some lines, copy, paste
elsewhere. It's just text after all!

If you'd like to manage your recordings on asciinema.org (set a title, change
terminal color theme) you need to link your uploads to your asciinema.org user
account. To do do it run:

```sh
asciinema auth
```

This command displays a URL, which, when opened in a web browser, authenticates
the CLI with your asciinema.org account, ensuring you access to your uploads.

You can skip this step now, and do it later. However, all recordings not
assigned to an account are automatically deleted after 7 days. See docs for
[asciinema upload](../manual/cli/usage/#asciinema-upload-filename) and
[asciinema auth](../manual/cli/usage/#asciinema-auth) commands for detailed
information.

## Embedding

[asciinema player](../manual/player/) can be embedded on any website by using
HTML `<script>` tag. Embedded player is commonly used on blogs, in project
documentation, and in conference talk slides.

All recordings uploaded to asciinema.org can be embedded on a website by using a
script snippet provided on the recording's page. It looks like this:

```html
<script async id="asciicast-569727" src="https://asciinema.org/a/569727.js"></script>
```

To get it go to a recording page, click on the "Share" button and copy the
script from the "Embed the player" section.

The above `<script>` tag is included right below this very paragraph, resulting
in the following player:

<script async id="asciicast-569727" src="https://asciinema.org/a/569727.js"></script>

If you prefer not to rely on asciinema.org for your embedded demos then you can
use the standalone player on your website like this:

```html
<!DOCTYPE html>
<html>
<head>
  ...
  <link rel="stylesheet" type="text/css" href="/asciinema-player.css" />
  ...
</head>
<body>
  ...
  <div id="demo"></div>
  ...
  <script src="/asciinema-player.min.js"></script>
  <script>
    AsciinemaPlayer.create('/demo.cast', document.getElementById('demo'));
  </script>
</body>
</html>
```

See [asciinema player quick-start guide](../manual/player/quick-start/) for full
setup details.

## Self-hosting the server

While [asciinema.org](https://asciinema.org) is a default [asciinema
server](../manual/server) instance used by the CLI for uploads, you can
self-host your own instance if you need full ownership and control over the
recordings.

asciinema server is packaged as OCI container image and is available at
[ghcr.io/asciinema/asciinema-server](https://github.com/asciinema/asciinema-server/pkgs/container/asciinema-server).

Here's a minimal docker-compose example:

```yaml title="docker-compose.yml"
version: '2'

services:
  asciinema-server:
      image: ghcr.io/asciinema/asciinema-server:latest
    # links:
    #   - postgres
    volumes:
      - ./volumes/asciinema/uploads:/opt/app/uploads

  postgres:
    image: postgres:14
    volumes:
      - ./volumes/postgres:/var/lib/postgresql/data
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
```

Start it with:

```sh
docker compose up
```

Then point asciinema CLI to it by setting `ASCIINEMA_API_URL` environment
variable:

```sh
export ASCIINEMA_API_URL=http://localhost:4000

asciinema rec private.cast
asciinema upload private.cast
```

Note that the above configuration should be used only for testing the server
locally.  See full [server self-hosting guide](../manual/server/self-hosting/)
to learn how to set it up properly in a full-featured and secure way.

## Generating a GIF

On websites where `<script>` tags are not allowed but `<img>` tags are, you can
use animated GIF files for embedding your demos.

Use [agg](../manual/agg/) to create a GIF file from your recording:

```sh
agg first.cast first.gif
```

See [agg usage manual](../manual/agg/usage/) for GIF generation details.

Using asciinema player to present a recording is usually a better choice than a
GIF file if you have the option of using `<script>` tags. Contrary to GIF, the
player provides the ability to pause, rewind, copy text, and it always renders
the terminal content as sharp as any other text displayed in a web browser.

## Next steps

Thank you for taking the first steps with asciinema through this introductory
guide. Our goal was to provide you with a clear, high-level overview of the
asciinema tools and their usage.

For additional insights and answers, feel free to explore our [FAQ](../faq/)
section and join the conversation in the `#asciinema` room on the Matrix
network, `#asciinema:matrix.org` ([web
client](https://matrix.to/#/#asciinema:matrix.org)), or `#asciinema` IRC channel
on [Libera.Chat](https://libera.chat/) ([web
client](https://web.libera.chat/#asciinema)).

To stay updated on latest developments and get useful tips, follow
[@asciinema@fosstodon.org](https://fosstodon.org/@asciinema) on Mastodon.

Happy recording!
