.PHONY: update
update:
	home-manager switch --flake .#rasmus

.PHONY: clean
clean:
	nix-collect-garbage -d
