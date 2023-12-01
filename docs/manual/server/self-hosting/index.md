# Self-hosting the server

asciinema terminal recorder uses [asciinema.org](https://asciinema.org) as its
default host for the recordings. It's free, public service (all uploaded
recordings are __private by default__ though).

If you're not comfortable with uploading your terminal sessions to
asciinema.org, or your company's policy prevents you from doing that, you can
set up your own instance for private use. See
our [asciinema server install guide](https://github.com/asciinema/asciinema-server/wiki/Installation-guide).

Once you have your instance running, point asciinema recorder to it by setting
API URL in `~/.config/asciinema/config` file as follows:

```ini
[api]
url = https://your.asciinema.host
```

Alternatively, you can set `ASCIINEMA_API_URL` environment variable:

    ASCIINEMA_API_URL=https://your.asciinema.host asciinema rec
