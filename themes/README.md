# themes

Saved copies of the themes I use, one folder per theme family and one subfolder per app. Nothing here is linked by the setup scripts: each app is installed by hand with the steps below.

## Oscura

Based on the [Oscura](https://github.com/narative/oscura) VS Code theme. Midnight is the variant in daily use.

```
oscura/
├── omarchy/oscura-midnight/   # Omarchy system theme (Hyprland, terminal, bar, Neovim, btop…)
└── t3code/                    # T3 Code themes: Midnight and Dusk, four variants each
```

### Omarchy

```sh
cp -r themes/oscura/omarchy/oscura-midnight ~/.config/omarchy/themes/
omarchy-theme-set "Oscura Midnight"
```

- `colors.toml` is the whole palette; Omarchy generates every app config from it. The terminal colors match the Ghostty block in `mac/ghostty/config.ghostty`, the accent and the orange come from the T3 Code theme.
- `hyprland_active_border` / `hyprland_inactive_border` make the window border white when focused and 20% white otherwise. The 1px width is not part of the theme: it is `border_size = 1` in `~/.config/hypr/looknfeel.lua`.
- `vscode.json` points VS Code and Cursor at the `Fey.oscura` extension.
- Only the solid background is stored here. On the PC the theme also uses two photos that ship with Omarchy, copied from its Matte Black theme:

  ```sh
  cp /usr/share/omarchy/themes/matte-black/backgrounds/1-dark-waters.jpg ~/.config/omarchy/themes/oscura-midnight/backgrounds/0-dark-waters.jpg
  cp /usr/share/omarchy/themes/matte-black/backgrounds/2-dot-hands.jpg ~/.config/omarchy/themes/oscura-midnight/backgrounds/1-dot-hands.jpg
  ```

### T3 Code

In the app, import the JSON from the theme settings. On a machine that runs the T3 Code server, publish it for every connected client instead:

```sh
t3 theme set themes/oscura/t3code/oscura-midnight-dark-sidebar.json
```

(`t3-nightly` on the nightly build.) `oscura-midnight-dark-sidebar` is the one in use.

### Ghostty and cmux

There is no separate file: the Oscura Midnight colors live in `mac/ghostty/config.ghostty`, and cmux reads that same Ghostty config.
