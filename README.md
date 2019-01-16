# Nix fetchGit with `ref = "*"`

This repository is two things:

* A Nix plugin that replaced `fetchGit` with the one from [NixOS/nix#2409][patch].
* A function which you can use to wrap your Nix and have this plugin activated.

It is essentially the same as applying the patch from the pull request, but builds faster.


  [patch]: https://github.com/NixOS/nix/pull/2409
