# Yggdrasil

Yggdrasil is a project which permits, if added in your favorite shell, to create and configure easily shell environment. Each variables declared in a context will be available only in this context. When the context is changed, the specific environment variable of this context will be unset. In addition, it print the current context on your shell line.

## Getting Started

This file regroups instructions on how to install this project and how to use it.

### Installing

First, use install.sh to add the Yggdrasil's configuration directory.

```bash
$ install.sh
```

Then add this line in your .zshrc/.bashrc to use this project 
```bash
source <path_to_folder>/yggdrasil/yggdrasil.sh
```

And reload your current shell with `bash` or `zsh` command.

End with an example of getting some data out of the system or using it for a little demo.

Normally, if this work, you should see this `(♎  None)` appear in your ps1 line. It represents the current context (in our case None which represents no-context).

### Usage

Yggdrasil comes with a list of command to create, edit, use or remove a context. You can get the list of them with the following command:

```bash
$ yggdrasil help
Usage: yggdrasil <command> [args]

Yggdrasil permits to switch easily between two shell
contexts.
The available commands for execution are listed below.
You can use the --help flag in every other command than
help.

Common commands:
  create    Create a new context
  list      Print all existing context.
  edit      Open your current editor and edit the context.
  remove    Remove a specific existing context.
  use       Change the current context to a new one.

All other commands:
  help      print usage
```

Notice that yggdrasil handle regex so be careful with them.

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/aboulay/yggdrasil/tags). 

## Authors

* **Boulay Adrien** - *Initial work* - [aboulay](https://github.com/aboulay)

See also the list of [contributors](https://github.com/aboulay/yggdrasil/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Inspiration

It born thanks to one of my co-worker recommandation.

This project is inspired by the [kube-ps1](https://github.com/jonmosco/kube-ps1) project.