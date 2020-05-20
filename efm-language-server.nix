with import <nixpkgs> {};

buildGoModule rec {
  pname = "efm-language-server";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "0gswjz9m68xl8r9f11bqp71lvb0b8j0j7vy0nkiwf4rmsyg0mjnb";
  };

  modSha256 = "0mi0rhfxbb06jjc87jl07kg9dgjysracc0ndjwmz9vic5jrjvydz";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mattn/efm-langserver";
    description = "General purpose Language Server";
    platforms = platforms.linux;
  };
}
