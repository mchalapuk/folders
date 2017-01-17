# folders

Group directories and sequentially run shell operation on all group members.

## Installation

Below instuction assumes that you have `~/bin` directory which is added to your
`PATH` environment variable.

```sh
cd ~
git clone https://github.com/muroc/folders
cd ~/bin
ln -s ../folders/folders.sh ./folders
```

## Usage

```
Usage: folder <command> [arguments...]

  Commands:
    list - lists folders added to the group
    add [folders...] - adds specified folders to the group
    del [folders...] - deletes specified folders from the group
    run <command-line> - runs specified command on all added folders
    usage - shows this message
```

### Creating Groups

In order to create a group, just link the script into another file.

```sh
ln -s ~/bin/program ~/bin/all-repos
all-repos add ~/code/*
all-repos run git checkout master
all-repos run git pull
```

Above code:

 1. Creates a group named `all-repos`,
 2. Adds all folders from `~/code/` directory to the group,
 3. Runs `git checkout master` command on all folders,
 4. Runs `git pull` command on all folders.

## License

&copy; 2017 Maciej Chałapuk. Released under [MIT License](LICENSE).

