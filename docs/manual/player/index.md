# asciinema player

__asciinema player__ is a web player for terminal session recordings.

Unlike typical web _video_ players, which play heavy-weight video files (`.mp4`,
`.webm`), asciinema player plays light-weight terminal session recordings in
text-based [asciicast](../asciicast/v2/) format (`.cast`).

<div class="player" id="player-manual-player-1"></div>

The player is built from the ground up with JavaScript and Rust (WASM), and is
available as [npm package](https://www.npmjs.com/package/asciinema-player) and a
[standalone JS
bundle](https://github.com/asciinema/asciinema-player/releases/latest).

You can use it on any HTML page - in a project documentation, on a blog, or in a
conference talk presentation.

It's as easy as adding a single line of Javascript code to your web page:

```javascript
AsciinemaPlayer.create('demo.cast', document.getElementById('demo'));
```

Check out [quick start guide](quick-start/) for basic setup overview.

---

Notable features:

* ability to copy-paste terminal content - it's just text after all!
* smooth, timing-accurate playback,
* [idle time optimization](options/#idletimelimit) to skip periods of
  inactivity,
* [posters](options/#poster),
* [markers](markers/) for navigation or auto-pause,
* configurable [font families](options/#terminalfontfamily) and [line
  height](options/#terminallineheight),
* [automatic terminal scaling](options/#fit) to fit into container element in
  most efficient way,
* full-screen mode,
* [multiple color themes for standard 16 colors](options/#theme) + support for
  256 color palette and 24-bit true color (ISO-8613-3),
* [adjustable playback speed](options/#speed),
* [looped playback](options/#loop), infinite or finite,
* [starting playback at specific time](options/#startat),
* [API for programmatic control](api/),
* [keyboard shortcuts](shortcuts/),
* [support for other recording
  formats](loading/#playing-other-recording-formats) like ttyrec, typescript.

---

asciinema player is a free and open-source software. Source code and license
available at
[github.com/asciinema/asciinema-player](https://github.com/asciinema/asciinema-player).
