# magtag

Insert img tag with width and height property.

## Installation

Put this plugin files into $HOME/.vim directory.
This plugin is required ImageMagick.

## Options

```vim
g:magtag_insert_pos
```
Insert img tag position. 0: after cursor (default), 1: before cursor

```vim
g:magtag_html_template
```
Template for html image tag

```vim
g:magtag_php_template
```
Template for php image tag

```vim
g:magtag_slim_template
```
Template for slim image tag

```vim
g:magtag_eruby_template
```
Template for eruby image tag

### Sample configs

```vim
let g:magtag_html_template = '<img src="%s" width="%d" height="%d" alt="">'
let g:magtag_php_template = '<img src="<?php the_img( ''%s'' ); ?>" width="%d" height="%d" alt="">'
let g:magtag_slim_template = '= image_tag "%s", width: %d, height: %d, alt: ""'
let g:magtag_eruby_template = '<%%= image_tag "%s", width: %d, height: %d, alt: "" %%>'
```


## Usage

```vim
:MagTag hoge.jpg
```
