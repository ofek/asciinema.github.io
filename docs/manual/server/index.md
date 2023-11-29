# asciinema server

__asciinema server__ is a server-side component of the asciinema ecosystem.

It implements a hosting platform for terminal session recordings. This includes
an API endpoint for uploading recordings, which is used by the [asciinema
CLI](../cli/index.md), and offers a familiar web interface for viewing,
browsing, sharing and managing recordings. It's privacy friendly, serving no ads
and performing no tracking.

The server is built with [Elixir language](https://elixir-lang.org/) and
[Phoenix framework](https://www.phoenixframework.org/), and embeds asciinema's
virtual terminal, [avt](https://github.com/asciinema/avt), to perform tasks such
as preview generation and recording analysis.

[asciinema.org](https://asciinema.org) is a public asciinema server instance
managed by the asciinema team, offering free hosting for terminal recordings,
available to everyone. Read [About asciinema.org](dot-org.md) to learn more
about this instance.

asciinema server is self-hosting friendly, and can be deployed in any
containerized environment, both for public or internal/private use. If you're
not comfortable with uploading your terminal sessions to asciinema.org, or your
company's policy prevents you from doing that, you can set up your own instance.
Read the [self-hosting quick start guide](self-hosting/quick-start.md) for
deployment overview.

---

Notable features:

- hosting of terminal session recordings in [asciicast](../asciicast/v2.md)
  format,
- perfectly integrated [asciinema player](../player/index.md) for best viewing
  experience,
- editable recording metadata like title or long description (Markdown),
- configurable terminal themes and font families,
- easy [sharing](sharing.md) of recordings via secret links,
- easy [embedding](embedding.md) of the player, or linking via preview images
  (SVG),
- ability to download pure text version (`.txt`) of a recording,
- visibility control for recordings: unlisted (secret) or public.

---

asciinema server is free and open-source software (FOSS). Source code and
license available at
[github.com/asciinema/asciinema-server](https://github.com/asciinema/asciinema-server).
