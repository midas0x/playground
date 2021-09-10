let
  pkgs = import (builtins.fetchGit rec {
    name = "dapptools-${rev}";
    url = "https://github.com/dapphub/dapptools";
    rev = "c43ea2a6240b6e49c0b79b067ab703e018f617c8";
  }) { };

in pkgs.mkShell {
  src = null;
  name = "dapptools";
  buildInputs = with pkgs; [
    # Node.js
    pkgs.nodejs
    # Dapp Tools
    pkgs.dapp
    pkgs.ethsign
    pkgs.hevm
    pkgs.seth
    pkgs.solc
  ];
}
