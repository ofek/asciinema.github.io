---
hide:
  - toc
---

# asciinema CLI

__asciinema__ (aka asciinema CLI or asciinema recorder) is a command-line tool
for recording terminal sessions.

Unlike typical _screen_ recording software, which records visual output of a
screen into a heavyweight video files (`.mp4`, `.mov`), asciinema recorder runs
_inside a terminal_, capturing terminal session output into a lightweight
recording files in the [asciicast](../asciicast/v2/) format (`.cast`).

The recordings can be replayed in a terminal, embedded on a web page with the
[asciinema player](../player/), or published to an [asciinema
server](../server/), such as [asciinema.org](https://asciinema.org), for further
sharing.

<div class="player" id="player-manual-cli-intro"></div>

Recording is as easy as running this command in your shell:

```sh
asciinema rec demo.cast
```

Check out the [quick start guide](quick-start/) for installation and usage
overview.

---

Notable features:

* [recording](usage/#rec-filename) and [replaying](usage/#play-filename) of
  sessions inside a terminal,
* [light-weight recording format](../asciicast/v2/), which is highly
  compressible (down to 15% of the original size e.g. with `zstd` or `gzip`),
* integration with [asciinema server](../server/), e.g.
  [asciinema.org](https://asciinema.org), for easy recording hosting.

---

asciinema CLI is free and open-source software (FOSS). Source code and license
available at
[github.com/asciinema/asciinema](https://github.com/asciinema/asciinema).
