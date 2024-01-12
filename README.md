# quarto-letter

This is [quarto](https://quarto.org) extension to create a letter. The output format is PDF.

## Installation

`quarto use template produnis/quarto-letter`


## Usage

- Fill out your data (sender / recipient) in the YAML-Header.
- if you have your signature as a png file, set parameter `signature: my-signature.png`. If you don't want a graphical signature, set parameter  `signature: ""`.
- THe default language is german. If you want to switch to english, set YAML-parameter:

```
---
english: true
lang: en      
---
```

## Screenshots

![](https://www.produnis.de/blog/posts/2022-09-12-quarto-briefvorlage/Testbrief.png)