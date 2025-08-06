# How lock file works ,and how ot update packages

So basically, once you get pulled into flakes, with no way out, then the way you update a package is by (my memory may fail me with the command) `nix flake update` and when you do this, it would update the rev of your nixpkgs version (so if your nixpkgs 25.05 is on xxxxxxx rev, it would update it to yyyyyyyy rev). But eventually nixpkgs goes up a version. Ig after that the rev of nixpkgs version (i.e nixpkgs 24.11) is never updated, and now you will have to change your version manually to 25.05, and then nix flake update to update the lock file. so now that the nixpkgs input is updated to the latest rev you can download the updated pkg version over there.

Also every version update is basically a branch update, so when you change the 24.11 to 25.05 in flake.nix, your basically changing the branch, and now you'll be on the latest commit of that branch

## Why do I need to update nixpkgs to install the new package version there?

cause nixpkgs contains all the information for how to install a package, it's basically a "manual for nixos itself" on how to install a package. So everytime a package version is updated, the installation instructions are updated in the "manual for nixos itelf" aka nixpkgs and hence you need to download the updated manual, so nixos knows how to download the updated version of this package

## Questions I don't know an answer to

- when a new versino of nixpkgs is released (i.e 25.05) then do old versions (i.e 24.11) still recieve updates?
- How to only update a specific package version, because everytime you update nixpkgs rev for a specific package, it would also update other packages. A solution to this for versions jumps like 24.11 -> 25.05 is to install 25.05 as a seperate input and then do something like nixpkgs-25.05.package, but what about rev jumps?
- Does nixos itself update? If we're just changing the nixpkgs versions, does that also update nixos itself? What exactly is nixos, what exactly does nixos refer to?
- Inqure about the nix flake way download the latest rev of a branch seperately, I can use pins, but is there a nix flake way, do I have to add another nixpkgs. is it more or less practical?

## Blogging notes 
Also write an explanation of this for nix channel users

# My way of managing nixos

- I am gonna not always update all my packages to the latest version
- everytime I need a package with the latest version, I will download a new nixpkgs, seperately and only update that package
- if I need more updated packages I'll check if the seperate nixpkgs version I downloaded suffices, if not, then I'll install the latest nixpkgs version, but if I Need a more specific version of the package, than ig new nixpkgs
