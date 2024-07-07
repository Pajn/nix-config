{ pkgs }:
pkgs.linkFarm "git-some-extras" (
  map
    (cmd: {
      name = "bin/git-${cmd}";
      path = pkgs.git-extras + "/bin/git-${cmd}";
    })
    [
      "abort"
      "brv"
      "coauthor"
      "commits-since"
      "fork"
      "rename-branch"
      "rename-tag"
      "rename-remote"
      "ignore"
      "info"
      "cp"
      "delete-tag"
      "sed"
      "show-merged-branches"
      "show-unmerged-branches"
      "stamp"
      "standup"
      "touch"
      "obliterate"
      "local-commits"
      "missing"
      "lock"
      "locked"
      "unlock"
      "pr"
      "root"
      "delta"
      "browse"
      "browse-ci"
    ]
)
