# Nix `fetchGit` with `ref = "*"`

This repository is two things:

* A Nix plugin that replaces the `fetchGit` built-in with the one from [NixOS/nix#2409][patch].
* A function which you can use to wrap your Nix and have this plugin activated.

It is essentially the same as applying the patch from the pull request, but builds faster.


Use
====

```nix
{ pkgs ? import <nixpkgs> {} }:

let
  wrappedSrc = builtins.fetchTarball {
    url = "https://github.com/kirelagin/nix-fetchgit/archive/1.1.tar.gz";
    sha256 = "1p86qyjwbk8c0wgj8kf4cf5s19wlidmvs9fyh2inr6d8qn8zjr3n";
  };
  wrapped = import wrappedSrc { inherit pkgs; };
in wrapped pkgs.nix
```


  [patch]: https://github.com/NixOS/nix/pull/2409
