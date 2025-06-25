{
  description = "A Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Or a specific commit/branch
    flake-utils.url = "github:numtide/flake-utils";     # Helps with multi-system support
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = false; # Set to true if you need unfree software
        };
      in
      {
        # Define a development shell named 'default'
        devShells.default = pkgs.mkShell {
          # List all the packages you want available in your shell environment
          buildInputs = with pkgs; [
            rustc           # The Rust compiler
            cargo           # The Rust package manager
            clippy          # A Rust linter
            rust-analyzer   # The Rust language server for IDEs
            # You can add other tools your project needs here, e.g.:
            # git
            # openssl.dev   # If your Rust project links against OpenSSL
            # pkg-config
          ];

          # Optional: Set environment variables for better tooling integration
          # RUST_SRC_PATH is useful for rust-analyzer to provide stdlib definitions
          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
          # LIBCLANG_PATH might be needed if you use bindgen or other tools that link to C
          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

          # Optional: A message to display when entering the shell
          shellHook = ''
            echo "Rust development shell active! (rustc ${pkgs.rustc.version})"
          '';
        };
      });
}
