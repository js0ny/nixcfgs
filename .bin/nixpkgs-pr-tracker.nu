#!/usr/bin/env nu

# Track a nixpkgs pull request across integration and release branches.
def main [pr: int, --json] {
    $env.PATH = ($env.PATH | append $"/etc/profiles/per-user/($env.USER)/bin")

    let repo = "NixOS/nixpkgs"
    let merge = ^gh pr view $pr -R $repo --json mergeCommit --jq '.mergeCommit.oid' | complete
    if $merge.exit_code != 0 {
        print --stderr --no-newline $merge.stderr
        exit $merge.exit_code
    }

    let merge_sha = $merge.stdout | str trim
    let merged = $merge_sha not-in ["" "null"]
    mut result = {
        pr: $pr
        merged: $merged
        merge_commit: (if $merged { $merge_sha } else { null })
        branches: {}
    }

    if not $json {
        print $"PR #($pr)"
        if $merged {
            print $"merge commit: ($merge_sha)"
            print ""
        } else {
            print "not merged"
        }
    }

    if $merged {
        let branches = [
            master
            nixpkgs-unstable
            nixos-unstable-small
            nixos-unstable
        ]

        for branch in $branches {
            let comparison = ^gh api $"repos/($repo)/compare/($branch)...($merge_sha)" --jq '.status' | complete
            let status = if $comparison.exit_code == 0 {
                $comparison.stdout | str trim
            } else {
                "unknown"
            }
            $result.branches = ($result.branches | insert $branch {
                compare_status: $status
                contains: ($status in [behind identical])
            })

            if not $json {
                let message = match $status {
                    behind => $"✓ ($branch) contains PR"
                    identical => $"= ($branch) is merge commit"
                    ahead | diverged => $"· ($branch) does NOT contain PR yet"
                    _ => $"? ($branch) unknown"
                }
                print $message
            }
        }
    }

    if $json {
        $result | to json --raw
    }
}
