with import <nixpkgs> {};

buildGoModule rec {
  pname = "dotm";
  version = "0.5.0-d8b14f9772e8f2226a8afc0ba705b00db7c52e92";

  src = fetchFromGitHub {
    owner = "relnod";
    repo = "dotm";
    # rev = "v${version}";
    rev = "d8b14f9772e8f2226a8afc0ba705b00db7c52e92";
    sha256 = "1phzkrvw4cl008qjf0yfpg1inwqg6rd8km1glaymjasgds8sql3m";
  };

  modSha256 = "0kp9awxazh2wkgbv94f19fknq14yj9vk32jrf49ki9h24l8wisda";

  subPackages = [ "cmd/dotm" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/relnod/dotm";
    description = "Manage dotfiles with multiple profiles and per program";
    license = licenses.mit;
    # maintainers = with maintainers; [ relnod ];
    platforms = platforms.linux;
  };
}
