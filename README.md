# dotfiles

These are my dotfiles. Setup is done by symbolic links, either manually or via [Make](https://www.gnu.org/software/make/). Repo is a work in progress.

## Notes

### `gitdir`

The script `gitdir.sh` depends on an environment variable `GITDIR`. This variable can be set via the `gitdir` make recipe, or manually in `~/.env`.

### `.gitconfig`

The enclosed `.gitconfig-base` is not automatically detected by Git, and has to be referenced in your actual `.gitconfig` to have any effect, like so:
```
[include]
	path = ~/.gitconfig-base
```
This section should be put at the very top of the `.gitconfig`, so that all values below overwrite the baseline settings in `.gitconfig-base`.
