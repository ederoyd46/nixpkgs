{
  lib,
  callPackage,
  fetchFromGitLab,
  buildGoModule,
  pkg-config,
}:

let
  version = "17.8.1";
  package_version = "v${lib.versions.major version}";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";

  git = callPackage ./git.nix { };

  commonOpts = {
    inherit version;

    # nixpkgs-update: no auto update
    src = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitaly";
      rev = "v${version}";
      hash = "sha256-ahYvfA1PvB/OP3swTABH++pZubejsb3Cohy+Z5fcAo4=";
    };

    vendorHash = "sha256-rR3dsKUoIVDj0NviN8p8g3mSAW8PTNChBacqd23yDf8=";

    ldflags = [
      "-X ${gitaly_package}/internal/version.version=${version}"
      "-X ${gitaly_package}/internal/version.moduleVersion=${version}"
    ];

    tags = [ "static" ];

    doCheck = false;
  };

  auxBins = buildGoModule (
    {
      pname = "gitaly-aux";

      subPackages = [
        "cmd/gitaly-hooks"
        "cmd/gitaly-ssh"
        "cmd/gitaly-lfs-smudge"
        "cmd/gitaly-gpg"
      ];
    }
    // commonOpts
  );
in
buildGoModule (
  {
    pname = "gitaly";

    subPackages = [
      "cmd/gitaly"
      "cmd/gitaly-backup"
    ];

    preConfigure = ''
      mkdir -p _build/bin
      cp -r ${auxBins}/bin/* _build/bin
      for f in ${git}/bin/git-*; do
        cp "$f" "_build/bin/gitaly-$(basename $f)";
      done
    '';

    outputs = [ "out" ];

    passthru = {
      inherit git;
    };

    meta = with lib; {
      homepage = "https://gitlab.com/gitlab-org/gitaly";
      description = "Git RPC service for handling all the git calls made by GitLab";
      platforms = platforms.linux ++ [ "x86_64-darwin" ];
      maintainers = teams.gitlab.members;
      license = licenses.mit;
    };
  }
  // commonOpts
)
