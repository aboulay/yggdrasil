# yggdrasil

Use install.sh to add the yggdrasil's configuration directory.

```bash
$ install.sh
```

Then add this line in your .zshrc/.bashrc to use this project 
```bash
source <path_to_folder>/yggdrasil/yggdrasil.sh
PROMPT='$(yggdrasil_ps1)'$PROMPT
```

And reload your current shell with `bash` or `zsh` command.