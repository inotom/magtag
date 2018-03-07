magtag
=======

Insert img tag with width and height property.

Installation
=======
Put this plugin files into $HOME/.vim directory.
This plugin is required ImageMagick.

Options
=======
```vim
g:magtag_insert_pos
```
Insert img tag position. 0: after cursor (default), 1: before cursor

```vim
g:magtag_use_xml
```
Use xml tag (adding close slash). 0: not using, 1: using (default)

```vim
g:magtag_eruby_helper_tag
```
To change eruby image_tag helper function string.

```vim
g:magtag_php_function_name
```
To change php `the_img` function name.

Usage
=======
```vim
:MagTag hoge.jpg
```
