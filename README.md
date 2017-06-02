# Kapow! Setup
The setup script for the Kapow! boilerplate for bespoke WordPress site development. 

## [Requirements](#requirements)

You will need the following installed on your system before attempting to set-up a Kapow! based project using this guide:

- [VirtualBox](http://www.virtualbox.org/), [Parallels](http://www.parallels.com) or another virtual machine
- [Vagrant](https://www.vagrantup.com/)
- [VVV (2.0.0+) a.k.a Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

If you don't plan on developing within the confines of a `vagrant ssh` session, you'll also need the following:

- [NodeJS](https://nodejs.org/)
- [Bower](http://bower.io/#install-bower)
- [Grunt](http://gruntjs.com/installing-grunt)
- [WP Cli](http://wp-cli.org/)

WP CLI version `0.24.x` or greater is required to avoid a fatal error when Vagrant runs the the `wp core install...` command, which prevents the core WP tables from being added to the database. Run `wp cli update` to upgrade to the latest stable release.

## [Installation](#installation)

1) Create a new folder in your Vagrant web root e.g. `Vagrant/www/my-project`.

2) Clone this repository and move `kapow.sh` and `kapow.config` to the folder you just created or grab the files directly via the terminal using the commands below:

`curl -O https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

`curl -O https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.config`

...or...

`wget https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

`wget https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.config`

3) Make the `kapow.sh` script executable via the command line using `chmod a+x kapow.sh`.

4) Run the script with `./kapow.sh` and up to five additional parameters to facilitate string replacement across the entire new Kapow! project you've created. 

*TIP: Create an alias called `getkapow` on your machine that invokes the curl/wget commands above to fetch Kapow! before making it executable. Useful if you use Kapow! as much as we do!*

5) Once the script has finished installing your Bower, NPM and Composer dependencies it will attempt to update your `Vagrant/vvv-custom.yml` file with a site configuration, ready for provisioning. If this file cannot be found, it will prompt you to add the config to the file manually. 

Once your Vagrant configuration has been updated, you're ready to provision the site using `vagrant provision --provision-with=site-stark-industries` for example.

**[Command Line Parameters](#command-line-parameters)**

The parameters must be added in the following order:

- Project Slug e.g. `stark-industries` *
- Project Nice Name e.g `"Stark Industries"`
- Author Name e.g. `"Tony Stark"`
- Author Email e.g. `tony@starkindustries.com`
- Author Website e.g. `www.starkindustries.com`

*NB: The project slug will be used for the theme folder name, theme textdomain and database name.*

An example using all of the above would look like this:

`./kapow.sh stark-industries "Stark Industries" "Tony Stark" tony@starkindustries.com www.starkindustries.com`

*NB: Strings containing spaces must be encapsulated in double quotes.*

**[Configuration Paramaters](#configuration-parameters)**

More info coming soon...
