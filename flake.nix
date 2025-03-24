{
  description = "Kaitai Struct Compiler";

  inputs =
  {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    sbt = {
      url = "github:zaninime/sbt-derivation";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, utils, sbt }: inputs.utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      stdenv = pkgs.gcc14Stdenv;
    in
    {
      packages.default = sbt.mkSbtDerivation.${system}
      {
        pname = "kaitai_struct_compiler";
	version = "1.0.0";
	src = pkgs.lib.cleanSource ./.;
	nativeBuildInputs = [ pkgs.keepBuildTree ];
	depsSha256 = "sha256-U4+a96fv6i6lRvZCM8np0jCF2hJHS97kvZFumbJCrtI="; # Set to empty to auto-recompute
	buildPhase = "sbt compile";
	installPhase = ''
	  mkdir -p $out/target
	  cp ./jvm/target/universal/*.zip $out/target/kaitai.zip
	'';
      };

      #devShells.default = pkgs.mkShell.override { inherit stdenv; }
      #{
      #  inputsFrom = [self.packages.${system}.default];
      #  packages = [];
      #};
    }
  );
}
