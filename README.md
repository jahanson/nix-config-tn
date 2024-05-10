# jahanson's homelab

[Repository Documentation](https://truxnell.github.io/nix-config/)

## Getting started

To Install

```sh
nixos-rebuild switch --flake github:jahanson/nix-config-tn#HOST
```

## Goals

- [ ] Learn nix
- [ ] Services I want to separate from my kubernetes cluster I will use Nix.
- [ ] Approval-based update automation for flakes.
- [ ] Expand usage to other shell environments such as WSL, etc
- [ ] keep it simple, use trusted boring tools

## TODO

- [ ] Forgejo Actions
- [ ] Bring over hosts
  - [ ] git.hsn.dev
  - [ ] Telperion (network services)
  - [ ] Gandalf (NixNAS)
  - [ ] Thinkpad T470

## Checklist

### Adding a new node

- Ensure secrets are grabbed from note and all sops re-encrypte with task sops:re-encrypt
- Add to relevant github action workflows
- Add to .github/settings.yaml for PR checks

## Applying configuration changes on a local machine can be done as follows:

```sh
cd ~/dotfiles
sudo nixos-rebuild switch --flake .
# This will automatically pick the configuration name based on the hostname
```

Applying configuration changes to a remote machine can be done as follows:

```sh
cd ~/dotfiles
nixos-rebuild switch --flake .#nameOfMachine --target-host machineToSshInto --use-remote-sudo
```

## Hacking at nix files

Eval config to see what keys are being set.

```bash
nix eval .#nixosConfigurations.rickenbacker.config.security.sudo.WheelNeedsPassword
nix eval .#nixosConfigurations.rickenbacker.config.mySystem.security.wheelNeedsPassword
```

And browsing whats at a certain level in options - or just use [nix-inspect](https://github.com/bluskript/nix-inspect) TUI 

```bash
nix eval .#nixosConfigurations.rickenbacker.config.home-manager.users.jahanson --apply builtins.attrNames --json
```

Quickly run a flake to see what the next error message is as you hack.

```bash
nixos-rebuild dry-run --flake . --fast --impure
```

## Links & References

- [Misterio77/nix-starter-config](https://github.com/Misterio77/nix-starter-configs)
- [billimek/dotfiles](https://github.com/billimek/dotfiles/)
- [Erase your Darlings](https://grahamc.com/blog/erase-your-darlings/)
- [NixOS Flakes](https://www.tweag.io/blog/2020-07-31-nixos-flakes/)
