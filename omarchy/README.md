# omarchy

What I change on top of a stock [Omarchy](https://omarchy.org) install on the desktop PC. `install.sh` applies everything that runs as the user; the rest (packages, **sudo** steps, sign-ins) is below, in order.

Written against Omarchy 4.0.4.

```
omarchy/
├── install.sh                       # user-level setup, idempotent
├── shell/bashrc.sh                  # sourced from ~/.bashrc: shared aliases, drops `c`
├── shell/starship.toml              # prompt styled after the Mac's Powerlevel10k
├── git/machine                      # signs commits with ~/.ssh/git_signing_ed25519
├── hypr/                            # looknfeel.lua (1px borders, no transparency), monitors.lua (1.5 scale)
├── bin/omarchy-agent-usage-cursor   # Cursor collector for the bar's agents panel
├── systemd/                         # user timer that refreshes it every 15 minutes
└── patches/                         # fix for Omarchy's Codex collector
```

## What `install.sh` does

Run it from the clone (`~/Code/dotfiles/omarchy/install.sh`) after the packages in step 3 are in.

- Creates `~/.ssh/git_signing_ed25519` if missing and prints the public key. Add it on GitHub (Settings → SSH and GPG keys → New SSH key, type **Signing Key**) so commits from the PC show "Verified".
- Runs `shared/install.sh omarchy`: git config, mise tools, shared aliases and the coding agents (rules, Claude Code settings, global skills).
- Links `shell/bashrc.sh` and `shell/starship.toml`, and adds one line to `~/.bashrc` that sources the former. Omarchy's own bash config stays untouched.
- Links the two Hyprland files and reloads Hyprland.
- Installs and enables the Cursor collector for the agents panel (section 7).

## 1. Theme

Install Oscura Midnight from [`themes/`](../themes/README.md), then point T3 Code at the exact theme file:

```sh
cp -r themes/oscura/omarchy/oscura-midnight ~/.config/omarchy/themes/
omarchy-theme-set "Oscura Midnight"
t3-nightly theme set themes/oscura/t3code/oscura-midnight-dark-sidebar.json
```

## 2. Hyprland

Done by `install.sh`.

- `looknfeel.lua`: Omarchy's default file plus `border_size = 1` and no window transparency. The border colors come from the theme.
- `monitors.lua`: 1.5 scale for the 32" 4K monitor on `DP-1`. Change it on other hardware.

## 3. Packages

**sudo**

```sh
sudo pacman -S t3code-nightly-bin cursor-bin grok-bot
yay -S helium-browser-bin openlogi-bin figma-agent-linux-bin
sudo pacman -Rns obs-studio moonlight-qt
```

`claude`, `codex`, `cursor-agent`, `gh` and Node come from mise (`install.sh`). Sign in afterwards: `cursor-agent login`, `codex login`, `claude`, `gh auth login`, Grok Bot, and each site inside Helium.

## 4. Helium as the default browser

```sh
xdg-settings set default-web-browser helium.desktop
```

`omarchy-default-browser` does not know Helium, but `omarchy-launch-webapp` does, so web apps follow the default.

### 1Password integration

1Password only talks to a fixed list of browsers. Give Helium the native-messaging manifest 1Password writes for Chromium, then allow its binary (**sudo**):

```sh
cp ~/.config/chromium/NativeMessagingHosts/com.1password.1password.json ~/.config/net.imput.helium/NativeMessagingHosts/
sudo mkdir -p /etc/1password
echo helium | sudo tee /etc/1password/custom_allowed_browsers
sudo chown root:root /etc/1password/custom_allowed_browsers
sudo chmod 755 /etc/1password/custom_allowed_browsers
```

Quit 1Password completely (`killall 1password`) and restart it and Helium.

## 5. Web apps

Remove the preinstalled ones I do not use and add three:

```sh
for app in Basecamp Discord "Google Contacts" "Google Maps" "Google Messages" "Google Photos" HEY Zoom; do
  OMARCHY_REMOVE_NOTIFY=false omarchy-webapp-remove "$app"
done

icons=https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png
omarchy-webapp-install "Figma" "https://www.figma.com/files" "$icons/figma.png"
omarchy-webapp-install "Notion" "https://www.notion.so" "$icons/notion.png"
omarchy-webapp-install "Notion Calendar" "https://calendar.notion.so" "$icons/notion-calendar.png"
```

Do not use `omarchy-remove-preinstalls`: it also deletes the `claude`, `codex` and `gh` launchers.

Local fonts in Figma need the agent running:

```sh
systemctl --user enable --now figma-agent.service
```

## 6. OpenLogi (MX Keys, MX Master 3)

The package ships udev rules, but they only apply once reloaded, and `/dev/uinput` stays root-only until the `uinput` module is loaded (**sudo**):

```sh
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo modprobe uinput
echo uinput | sudo tee /etc/modules-load.d/uinput.conf
systemctl --user enable --now openlogi-agent.service
```

`journalctl --user -u openlogi-agent` should say `OS input hook installed`.

OpenLogi does not pair devices. Pair over Bluetooth first; a keyboard shows a passkey that is typed on the keyboard itself, which is easier to see in the terminal than in the bar panel:

```sh
bluetoothctl --agent KeyboardDisplay
# pair <MAC>, type the passkey on the keyboard + Enter, then trust <MAC> and connect <MAC>
```

## 7. Cursor in the bar's agents panel

Omarchy ships collectors for Claude Code, Codex and Fireworks only. The panel draws any record that lands in `~/.local/state/omarchy/agents/usage/`, so `install.sh` adds one for Cursor and a user timer that runs it.

- It reads the `cursor-agent` login in `~/.config/cursor/auth.json` and calls two undocumented Cursor endpoints (the same ones T3 Code uses). When they fail it keeps the previous record.
- The numbers are account-wide and cover the last 30 days.
- Optional, so the panel's own refresh also runs it (**sudo**; an Omarchy update may remove the link):

  ```sh
  sudo ln -s ~/.local/bin/omarchy-agent-usage-cursor /usr/share/omarchy/bin/omarchy-agent-usage-cursor
  ```

## 8. Codex tab disappearing from the agents panel

With Codex CLI 0.162.1 the app-server sometimes never answers `account/read`. Omarchy's collector then drops the limits too, and the Codex tab vanishes when there is no local usage. The patch lets the collector carry on with the limits call, which also returns the plan (**sudo**):

```sh
sudo patch /usr/bin/omarchy-agent-usage-codex omarchy/patches/omarchy-agent-usage-codex.patch
```

An Omarchy update overwrites that file. Reapply the patch if the tab starts flickering again; drop it once the collector or Codex is fixed upstream.

## Not configured

- Docker: installed, but `docker.service` is disabled and the user is not in the `docker` group.
- Memory runs at 4200 MHz with XMP off on purpose: XMP at 5600 corrupted data during install. Leave it until a clean MemTest86 pass.
