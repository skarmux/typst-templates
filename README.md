[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)

Quickly generate documents with a unified design with a simple command from any
machine. Contents and typeface are stored separately and styling is readonly.

<div align="center">
  <img src="docs/curriculum_vitae.png" alt="CV" />
</div>

## Usage

```sh
nix run github:skarmux/typst-templates
```

You will be prompted for any missing configuration,
but you can set up environmant variables to skip those steps:
- `ASSETS_PATH` (Required) Path to your own `assets/` folder.
- `LANGUAGE` Which translations to use for templates that have any.
  - `"en"` and `"de"`
- `TEMPLATE` What template to use (if you already know)
  - `"curriculum_vitae"`
  - `"application_letter"`
  - `"motivational_letter"`
  - `"meeting_protocol"`
- `THEME` which of the catppuccin color schemes to use
  - `"latte"` The only light theme available
  - `"frappe"` dark
  - `"macchiato"` darker
  - `"mocha"` darkest

Your configured `$EDITOR` (and optionally a live preview) will open with a
TOML file where you can fill your data in. The `data.toml` will reside in
a temporary location under `/tmp` until you close the editor. A backup copy
`<template>.toml` will be stored at your current location.

If you start of with such a `<template>.toml` already present, it will be
used as data source for your template generation. (It will be copied to `/tmp`
for pdf generation and edition still.)

## TODO's

- [ ] Make the script run without nix commands by pulling the script out of the nix flake.
- [ ] Copy placeolder assets directory to current location for easier replacement of contents.
- [ ] Allow renaming of generated PDF and data TOML.
- [ ] Automatically fill the date in meeting protocols.
- [ ] AI checking of written text.
- [ ] Digital signing of meeting protocols. (Each participant can sign with a FIDO key.)
- [ ] Coloring of graphics (svg, png, etc) in THEME color.
- [ ] Allow changing of primary and complementary colors.
