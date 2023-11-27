# History

asciinema project was started by [Marcin Kulik](https://hachyderm.io/@ku1ik) in
2011.

While Marcin was playing with the idea of sharing terminal session recordings on
the web since 2010, the working prototype of what eventually became asciinema
came to life a bit later.

Initially, all components of asciinema - the recorder (aka CLI), the player, the
server - were developed as parts of a single [Ruby on
Rails](https://rubyonrails.org/) codebase. The recorder was a simple, single
file Python program. The player was a single JavaScript file, with an ad-hoc,
incomplete parser for ANSI escape sequences, using jQuery for juggling the lines
of a fake terminal view in a web browser. It was rough but worked well enough to
deserve continued development.

The project was initially named "ascii.io". In March 2012 ascii.io site was
launched, providing free hosting for terminal session recordings made with
`asciiio` script (tripple "i", omg!). The project was renamed to "asciinema" in
September 2013 and published as a Python package to PyPI around the same time.

In late 2014 the recorder was rewritten in Go, preserving the functionality of
the previous versions while improving in some areas. The first release of the
new codebase was 0.9.9, published in December 2014.

The same year version 1.0 of the player came out, quickly followed by version
1.0 of the recorder, which came out in March 2015. Those releases stabilized the
first version of asciinema's recording file format, [asciicast
v1](../manual/asciicast/v1/).

Version 1.2 of the recorder was the final version implemented in Go. For
[several
reasons](https://blog.asciinema.org/post/and-now-for-something-completely-different/)
it was reverted to the previous Python implementation. The new-old recorder was
released in July 2016 as version 1.3, with all new features backported from the
Go codebase.

The lack of proper ANSI parser in the early versions of the asciinema player was
an obstacle for timely bugfixes and more comprehensive terminal emulation,
therefore in 2015 the work started to implement new version of the player with
proper ANSI-compatible terminal parser embedded. The result was asciinema player
2.0, rewritten from scratch in ClojureScript, and released in January 2016.

Around 2017 asciinema server was made way more self-hosting friendly, with
updated installation docs and simplified setup in containerized environments.

February 2018 marked the release of asciinema recorder 2.0, which introduced
improved recording file format, [asciicast v2](../manual/asciicast/v2/), among
many new features.

Another milestone was achieved in May 2022 with the release of asciinema player
3.0, in which the terminal emulation part was implemented in Rust (as
[avt](https://github.com/asciinema/avt) library), and compiled to WebAssembly,
resulting in [4x smaller, 50x
faster](https://blog.asciinema.org/post/smaller-faster/) player.

Outside of asciinema's core components, a new, ultra-fast asciinema GIF
generator, [agg](../manual/agg/), was released in August 2022.  Creation of agg
was, to a degree, sparked by avt. In fact, avt has also been integrated into
asciinema server, where it's used for thumbnail generation and recording
analysis since 2020.

The latest version of asciinema recorder, 2.4, was released in October 2023.
