# Kapow! Test Suite
A test suite to quickly test for breaking changes caused by Kapow! component updates.

1) Clone the repo

2) Run the bash script with `./kapow.sh`

3) Move into the test suite folder `cd kapow`

4) Run `grunt` to check for any Grunt errors

5) Copy the contents of this folder into a new folder in your Vagrant web root then run `vagrant up --provision` so that you can check for any front-end or theme errors using `my-project.dev` as the local domain.
