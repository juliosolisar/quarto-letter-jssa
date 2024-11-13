# quarto-letter

This is a [quarto](https://quarto.org) extension to create a letter. The output format is PDF.

## Installation

`quarto use template produnis/quarto-letter`


## Typst
This extension now supports typst format, which is shipped with `quarto > 1.4`.

```
---
format:
  quarto-letter-typst
---
```

LaTeX still works, though.

```
---
format:
  quarto-letter-pdf
---
```

## Usage

- Fill out your data (sender / recipient) in the YAML-Header.
- if you have your signature as a png file, set parameter `signature: my-signature.png`. If you don't want a graphical signature, set parameter  `signature: ""`.
- see `_extension.yml` for all parameters

## Logo

You can add a logo banner to the top of the pages. Set the path to your logo in YAML:

```
---
logo: /path/to/logobanner.png
logowidth: 12cm
---
```

## Screenshots

![](https://i.imgur.com/ubANbwb.png)


## License
This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

