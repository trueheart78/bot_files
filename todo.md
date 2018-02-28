## Feb 27th

1. ~~Properly detect the shell.~~
   * `BotFiles::Shell` class
1. ~~Read the shell and look at lines that start with "source".~~
   * `BotFiles::Shell.sources`
1. Override the config support for a `.dotfiles` map to be required.
   * This would _currently_ happen as the first default assignment map in `Linker`.
   * Name should probably stay as `.dotfiles`, or be changed to `.dotfile_shells`.
   * This is where things get sourced, though. So it would be pointing to the `dotfiles/shells` directory.
   * Sources strings generated should definitely utilize this.
1. Generator should create a repo with a `shells` directory, where the specific shell-related sources go.
   * See [Sample Structure][sample-structure]

### Long-Term

1. `.bot_files.yml` should support a header with the names for each shell file to be sourced.
   * `aliases`
   * `config`
   * `functions`


### Sample Structure

```
dotfiles
└── shells
    ├── bash
    │   ├── aliases.sh
    │   ├── config.sh
    │   └── functions.sh
    ├── shared
    │   ├── aliases.sh
    │   ├── config.sh
    │   └── functions.sh
    └── zsh
        ├── aliases.sh
        ├── config.sh
        └── functions.sh
```


[sample-structure]: #sample-structure
