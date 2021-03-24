# Rust Plugin

The rust plugin provides some extra niceties for using micro with
the Rust programming language. The main thing this plugin does is
run `rustfmt` and `rustimports` for you automatically. If you would also
like automatically error linting, check out the `linter` plugin.
The plugin also provides `rustrename` functionality.

You can run

```
> rustfmt
```

or

To automatically run these when you save the file, use the following
options:

* `rustfmt`: run rustfmt on file saved. Default value: `on`
