# folders

Group directories and sequentially run shell operation on all group members.

![Folders Demo][demo]

[demo]: https://muroc.github.io/folders/tty.gif

## Installation

Below instuction assumes that you have `~/bin` directory which is added to your
`PATH` environment variable.

```sh
wget https://raw.githubusercontent.com/muroc/folders/master/folders.sh -O ~/bin/folders
chmod +x ~/bin/folders
```

## Usage

```
Usage: folders <command> [arguments...]

  Commands:
    list - lists folders added to the group
    add [folders...] - adds specified folders to the group
    del [folders...] - deletes specified folders from the group
    run <command-line> - runs specified command on all added folders
    usage - shows this message
    
  Options:
    --clean (-c) - displays only stdout and stderr from child processes
```

### Creating Groups

In order to create a group, just link the script into another file.

```sh
cd ~/bin
ln -s folders all-repos
```

New group is used when running the script via `all-repos` symlink.

```
all-repos add ~/code/*
all-repos run git checkout master
all-repos run git pull
```

Above code:

 1. Adds all folders from `~/code/` directory to the group,
 2. Runs `git checkout master` command on all folders,
 3. Runs `git pull` command on all folders.

## License

&copy; 2017 Maciej Chałapuk. Released under [MIT License](LICENSE).

