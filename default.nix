{ pkgs ? import <nixpkgs> {} }:

origNix:

with pkgs;

let
  nix-fetchgit =
    stdenv.mkDerivation {
      name = "nix-fetchgit";

      src = lib.sourceByRegex ./. ["^CMakeLists.txt$"];
      patchSrc = fetchpatch {
        url = "https://github.com/NixOS/nix/commit/4b279a099f19bd13a98fa2ae519c4aa263bb6b6e.patch";
        sha256 = "0sisavs3x2p37hrmhnhvhh2rzb0qyjvvd4y0azk25329wylqnw88";
      };

      postPatch = ''
        tar -xf "${nix.src}" --strip-components 4 "${nix.name}"/src/libexpr/primops/fetchGit.cc
        tar -xf "${nix.src}" --strip-components 2 "${nix.name}"/src/nlohmann
        patch -p4 < "$patchSrc"
        sed -i 's/^GitInfo exportGit/static GitInfo exportGit/' fetchGit.cc
      '';

      nativeBuildInputs = [ cmake pkgconfig ];
      buildInputs = [ origNix boost ];

      meta = {
        # https://github.com/NixOS/nix/pull/2409
        description = ''A fetchGit replacement plugin which supports ref = "*"'';
        homepage = https://github.com/kirelagin/nix-fetchgit;
        license = stdenv.lib.licenses.mit;
        platforms = stdenv.lib.platforms.all;
      };
    };

in

symlinkJoin {
  inherit (origNix) name;

  paths = [ origNix ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for p in "$out"/bin/*; do
      wrapProgram "$p" \
        --add-flags "--option plugin-files ${nix-fetchgit}/lib/nix/plugins/libnix-fetchgit*"
    done
    '';
}
