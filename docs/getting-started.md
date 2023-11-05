# Getting started

## 1. Install the recorder

<%= render "quick_install.html", conn: @conn %>

## 2. Record

To start recording run the following command:

```
asciinema rec
```

This spawns a new shell instance and records all terminal output.
When you're ready to finish simply exit the shell either by typing <code>exit</code> or
hitting <kbd>Ctrl-D</kdb>.

See <a href="<%= Routes.doc_path(@conn, :show, :usage) %>">usage instructions</a> to learn about all commands and options.

## 3. Manage your recordings (optional)

If you want to manage your recordings on asciinema.org (set title/description,
delete etc) you need to authenticate. Run the following command and open
displayed URL in your web browser:


```
asciinema auth
```

If you skip this step now, you can run the above command later and all
previously recorded asciicasts will automatically get assigned to your
profile.

## installing the CLI
## recording your first session
## publishing to asciinema.org
## self-hosting the recording
## converting to gif
