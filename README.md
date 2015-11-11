# Kapow! Setup
The setup script for the Kapow! boilerplate/framework for WordPress site development. 

## Requirements

You will need the following installed on your system before attempting to set-up a Kapow! project using this guide.

- [VirtualBox](http://www.virtualbox.org/) (or another virtual machine app such as Paralells)
- [Vagrant](https://www.vagrantup.com/)
- [VVV a.k.a Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [NodeJS](https://nodejs.org/)
- [Bower](http://bower.io/#install-bower)
- [Grunt](http://gruntjs.com/installing-grunt)

## Installation

1) Create a new folder in your Vagrant web root e.g. `Vagrant/www/my-project`.

2) Download the `kapow.sh` script from this repo and move it to the folder you just created or grab it directly via the terminal using the commands below and:

`curl -O https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

`wget https://raw.githubusercontent.com/mkdo/kapow-setup/master/kapow-setup/kapow.sh`

3) Make the script executable via the command line using `chmod a+x kapow.sh`.

4) Run the script with `./kapow.sh` and up to five additional parameters to facilitate string replacement across the entire new Kapow! project you've created. 

**Kapow! Setup Parameters**

The parameters must be added in the following order:

- Project Slug e.g. `avengers-initiative` *
- Project Nice Name e.g `"Avengers Initiative"`
- Author Name e.g. `"Director Fury"`
- Author Email e.g. `director@avengers.com`
- Author Website e.g. `www.avengers.com`

*NB: The project slug will be used for the theme folder name, theme textdomain, code namespace and database name.*

An example using all of the above would look like this:

`./kapow.sh the-avengers "The Avengers" "Nick Fury" nick@fury.com www.avengers.com`

*NB: Strings containing spaces must be encapsulated in double quotes.*

**Adding Kapow! Whoosh**

At [Make Do](http://www.makedo.net) (the brains behind Kapow!) we have a few extra WordPress and Front-end dependencies that are commonly used in the projects we work on.

As we didn't want to make Kapow! any more opinionated than it already is out of the box, we needed to stash our alternative `composer` and `bower` manifests in a seperate repo that we've decided to call [Kapow! Whoosh](https://github.com/mkdo/kapow-whoosh) in keeping with the comic/superhero theme!

If you'd like to add *Whoosh* to your project, simply add the `-w` flag immediately after your invoke the `kapow.sh` script, but before you pass in any parameters. It should look like this:

`./kapow.sh -w the-avengers "The Avengers" "Nick Fury" nick@fury.com www.avengers.com`

5) After Grunt has finished, run `vagrant up --provision` and view the site using `your-slug.dev`.
