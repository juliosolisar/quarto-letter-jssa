# quarto-letter

This is a [quarto](https://quarto.org) extension to create a letter. The output format is PDF.

## Installation

`quarto use template produnis/quarto-letter`


## Usage

- Fill out your data (sender / recipient) in the YAML-Header.
- if you have your signature as a png file, set parameter `signature: my-signature.png`. If you don't want a graphical signature, set parameter  `signature: ""`.
- The default language is german. If you want to switch to english, set YAML-parameter:

```
---
lang: en      
---
```

## Logo

You can add a logo banner to the top of the pages. Set the path to your logo in YAML:

```
---
logo: /path/to/logobanner.png
logowidth: 12cm
---
```

## Screenshots

![](https://www.produnis.de/blog/posts/2022-09-12-quarto-briefvorlage/Testbrief.png)


## Typst
This extension now supports typst format.
