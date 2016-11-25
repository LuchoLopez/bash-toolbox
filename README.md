# bash-toolbox
A set of functions to help devoloping bash scripts

## Use:
To use this functions just add a line like this in your script:
```
source /full/path/to/bash-toolbox/basic.sh
source /full/path/to/bash-toolbox/ssh.sh
```
Finally just use the functions (read help of any function)

Example:
```
source /full/path/to/bash-toolbox/basic.bash
printListItem 1 && showinscreen 'First level item' 'INF' \
   && printListItem 2 && showinscreen 'Second level item' 'INF' \
   && printListItem 3 && showinscreen 'Third level item' 'INF' \
   && printListItem 2 && showinscreen 'Another second level item' 'INF'
```


## Colaborators:
  * Bruno Almada (test and debug)

---

This is a md file. (MarkDown):
https://guides.github.com/features/mastering-markdown/
