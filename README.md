[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)

Quickly generate documents with a unified design with a simple command from any
machine.

## Usage

```sh
# Create a new template and start editing right away
nix run github:skarmux/typst-templates

# or continue editing a templae you already have
nix run github:skarmux/typst-templates -- [FILE]
```

Your configured `$EDITOR` (and optionally a live preview) will open with your own
or a newly created TOML file where you can fill your data in.

Currently hardcoded to only convert `cv` templates.

Attention! Changes won't be written to your file until the editor is closed. Yes,
it sucks. I need to figure that one out...

## Showcase

### Curriculum Vitae

<p align="center">
  <img src="docs/cv-0.png" alt="CV page 1" width="250" />
  <img src="docs/cv-1.png" alt="CV page 2" width="250" />
  <img src="docs/cv-2.png" alt="CV page 3" width="250" />
</p>


### Application Letter

<div align="center">
  <img src="docs/application.png" alt="preview of application letter" width="250" />
</div>

### Motivational Letter

<div align="center">
  <img src="docs/motivation.png" alt="preview of motivational letter" width="250" />
</div>

### Meeting Protocol

<div align="center">
  <img src="docs/meeting.png" alt="preview of meeting protocol" width="250" />
</div>

## TODO's

- [x] ~~Make the script run without nix commands by pulling the script out of the nix flake.~~
  - No safe way to make sure the correct packages are installed. That's why I chose to use Nix after all.
- [ ] Copy placeholder assets directory to current location for easier replacement of contents.
- [x] Allow renaming of generated PDF and data TOML.
- [x] ~~Automatically fill the date in meeting protocols.~~
  - Not working in nix session. Unless it actualle is 01.01.1980
- [ ] AI checking of written text.
- [ ] Digital signing of meeting protocols. (Each participant can sign with a FIDO key.)
- [x] Coloring of graphics (svg, png, etc) in THEME color.
  - New `colorize` function in `model/components.typ`
- [x] Allow changing of primary and complementary colors.
  - Can be changed with `typst compile --inputs flavor=frappe --inputs accent=blue`.
  - The values are still very much hardcoded in the Nix Shell Script command.

## Acknowledgements

- Typst
- Nix
- [© 2021 Catppuccin](https://github.com/catppuccin/catppuccin). Licensed under the MIT License. See `licenses/CATPPUCCIN_LICENSE` for details.
  - Colorscheme
  - [Cat Footer Graphic](https://github.com/catppuccin/catppuccin/blob/main/assets/footers/gray0_ctp_on_line.svg)
