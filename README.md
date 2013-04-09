magtag
=======

Vim script to insert &lt;img&gt; tag after cursor position with image width and height property.

Installation
=======
Put this file into $HOME/.vim/ftplugin/html directory.
This vim script is required ImageMagick.

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


Usage
=======
```vim
:MagTag hoge.jpg
```
