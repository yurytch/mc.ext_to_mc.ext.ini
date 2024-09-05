# mc.ext_to_mc.ext.ini
Simple converter of Midnight Commander's extension file version 3 (mc.ext) to version 4 (mc.ext.ini), as introduced in 4.8.29.

There seems to be no 'official' conversion routine, and existing `mc.ext` is just ignored and generic `mc.ext.ini` is just slapped into your config directory, so this might be useful if you have had your `mc.ext` heavily customised and don't want to loose your settings.

**Caution:** The script needs to be run with `GNU awk` or, possibly, its close equivalent. Other `awk` variants are untested.

Ubuntu 24 specifically needs `gawk` installed, and otherwise (i.e. with the default Ubuntu 24's `awk`) the script produces "syntax error on line 16".

**Caution:** I didn't test how `Directory/` directives convert, as I never used those in mine config. Might be okay, might be not. 
Considering MC's processing of extension file breaks in all sections following the section in which an error's generated (say, by faulty regex), you might want to extra check.

Use it as follows:
1) Be in your $HOME/.config/mc or equivalent. Run this:

  `cat mc.ext | awk -f do.awk > mc.ext.ini`
  
2) In MC menus select 'Command' -> 'Edit extension file' and just save and exit the editor to notify MC of your changes. (Or just exit all instances of MC and re-start.)
