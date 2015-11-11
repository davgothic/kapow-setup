# Kapow! Setup
The setup script for the Kapow! boilerplate/framework for WordPress site development. 

1) Create a new folder in your Vagrant web root e.g. `Vagrant/www/my-project`.

2) Download the `kapow.sh` script from this repo and move it to the folder you just created or grab it directly via the command line using the commands below and:

`curl -O https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

`wget https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

3) Make the script executable via the command line using `chmod a+x kapow.sh`.

4) Run the script with `./kapow.sh` and up to five additional parameters to facilitate string replacement across the entire new Kapow! project you've created. The parameters must be added in the following order:

- Project Slug e.g. `avengers-initiative` *
- Project Nice Name e.g `"Avengers Initiative"`
- Author Name e.g. `"Director Fury"`
- Author Email e.g. `director@avengers.com`
- Author Website e.g. `www.avengers.com`

*NB: The project slug will be used for the theme folder name, theme textdomain, code namespace and database name.*

An example using all of the above would look like this:

`./kapow.sh the-avengers "The Avengers" "Nick Fury" nick@avengers.com www.avengers.com`

*NB: Strings containing spaces must be encapsulated in double quotes.*

5) After Grunt has finished, run `vagrant up --provision` and view the site using `your-slug.dev`.
