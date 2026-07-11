export DEV_DIR="$HOME/Documents/Code"

if [[ -o interactive && -d "$DEV_DIR" && "$PWD" == "$HOME" ]]; then
  cd "$DEV_DIR"
fi