# Kapow! Test Suite
A test suite to quickly test for breaking changes caused by Kapow! component updates.

1) Create a new folder in your Vagrant web root

2) Download the `kapow.sh` script and move it to the folder you just created.

3) Make the script executable via the command line using `chmod +x kapow.sh`

4) Run the script with `./kapow.sh`

5) Run `grunt` to build the project and check for any Grunt errors

5)  Run `vagrant up --provision` so that you can check for any front-end or theme errors using `my-project.dev` as the local domain.
