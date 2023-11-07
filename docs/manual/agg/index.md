# agg - asciinema gif generator

__agg__ is a command-line tool for generating animated GIF files from terminal
session recordings. It supports conversion from [asciicast v2](../asciicast/v2/)
files produced by [asciinema recorder](../cli/) (aka "asciinema CLI").

---

Notable features:

- creating GIFs from local `.cast` files as well as from recordings hosted at
  [asciinema.org](https://asciinema.org),
- multiple built-in color themes, ability to use a custom theme,
- font family and font size customization,
- adjustable animation speed,
- emojis (mono).

Example GIF file generated with agg:

![Example GIF file generated with agg](demo.gif)

It uses Kornel Lesiński's excellent
[gifski](https://github.com/ImageOptim/gifski) library to produce optimized,
high quality GIF output with accurate frame timing.

---

agg is a free and open-source software. Source code and license available at
[github.com/asciinema/agg](https://github.com/asciinema/agg).
