# Kapow! Setup
A setup script to quickly scaffold a new Kapow! project or test for breaking changes caused by module updates.

1) Create a new folder in your Vagrant web root e.g. `Vagrant/www/my-project`.

2) Download the `kapow.sh` script and move it to the folder you just created.

`curl -O https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

`wget https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

3) Make the script executable via the command line using `chmod +x kapow.sh`.

4) Run the script with `./kapow.sh` and up to five additional parameters to facilitate string replacement across the entire new Kapow! project you've created:

- Project Slug e.g. `avengers-initiative`
- Project Nice Name e.g `"Avengers Initiative"`
- DB Name & Function Prefix e.g. `avengers_int`
- Author Name e.g. `"Director Fury"`
- Author Email e.g. `director@avengers.com`
- Author Website e.g. `www.avengers.com`

*NB: The project slug is also used as the theme folder name and `textdomain`.*

An example using all of the above would look like this:

`./kapow.sh the-avengers "The Avengers" the_avengers "Nick Fury" nick@avengers.com www.avengers.com`

*NB: Strings containing spaces must be encapsulated in double quotes.*

5) After Grunt has finished, run `vagrant up --provision` and view the site using `your-slug.dev`.
