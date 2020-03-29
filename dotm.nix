with import <nixpkgs> {};

buildGoModule rec {
  pname = "dotm";
  version = "0.5.0-5d1d0fe43ffcf3a6f9667406e0f42fa1c230537a";

  src = fetchFromGitHub {
    owner = "relnod";
    repo = "dotm";
    # rev = "v${version}";
    rev = "5d1d0fe43ffcf3a6f9667406e0f42fa1c230537a";
    sha256 = "1xv6ahlpscdpz1l3545c7ljcdg6mfrvnlnvs04mfyn770hk9fsbm";
  };

  modSha256 = "14q2ahll4ykkgi6lk46vzjn1fg7rf5ynryx4bmyy78zmwv6dz541";

  subPackages = [ "cmd/dotm" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/relnod/dotm";
    description = "Manage dotfiles with multiple profiles and per program";
    license = licenses.mit;
    # maintainers = with maintainers; [ relnod ];
    platforms = platforms.linux;
  };
}
