switch:
  git add .
  sudo nixos-rebuild switch --flake .#nixos
  git commit -m "Rebuild NixOS configuration [$(date '+%Y-%m-%d %H:%M:%S')]"

update:
  nix flake update

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

# sudo age-keygen -o /var/lib/sops-nix/key.txt
sops:
  sudo EDITOR=nvim SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops secrets.yaml
