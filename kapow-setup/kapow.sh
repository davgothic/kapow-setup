#!/usr/bin/env bash
# Kapow! Setup Script - Requires a Bash shell on OSX
# -----------------------------------------------------------------------------

# Input variables
if [ $1 = "develop" ]
	# Assume first argument is a branch
	# if the value is develop.
	then
		branch=$1
		slug=$2
		nicename=$3
		authorname=$4
		authoremail=$5
		authorurl=$6
	# Alternatively, set the variables
	# as normal.
	else
		branch="master"
		slug=$1
		nicename=$2
		authorname=$3
		authoremail=$4
		authorurl=$5
fi

# GitHub Kapow URL prefix & suffix.
prefix="https://github.com/mkdo/kapow-";
suffix="/archive/$branch.zip";

# Array of Kapow! component names.
declare -a arr=("skeleton" "sass" "grunt" "theme" "core")

# Fetch and extract the archives from GitHub.
for i in "${arr[@]}"
	do
		file="$i.zip"

		curl -Lo $file $prefix$i$suffix

		unzip $file
done

# Move Skeleton.
skeldir="kapow-skeleton-$branch/kapow-skeleton";
if [ -d $skeldir ]
	then
	cp -r $skeldir/* .
	cp -r $skeldir/.gitignore .
fi

# Move Sass.
sassdir="kapow-sass-$branch/kapow-sass";
if [ -d $sassdir ]
	then
	cp -a $sassdir/* assets/scss
fi

# Move Grunt.
gruntdir="kapow-grunt-$branch/kapow-grunt";
if [ -d $gruntdir ]
	then
	cp -a $gruntdir/* .
fi

# Move Theme.
themedir="kapow-theme-$branch/kapow-theme";
if [ -d $themedir ]
	then

	# If we have no slug, default to the
	# standard 'my-project' slug.
	if [ ! $slug ]
		then
		slug="my-project"
	fi

	# Create the theme directory, give it
	# the correct permissions and then
	# copy the theme files over.
	mkdir build/wp-content/themes/$slug
	chmod 755 build/wp-content/themes/$slug
	cp -a $themedir/* build/wp-content/themes/$slug
fi

# Move Core.
coredir="kapow-core-$branch/kapow-core";
if [ -d $coredir ]
	then
	# Create the core plugin directory, give it
	# the correct permissions and then
	# copy the theme files over.
	mkdir build/wp-content/plugins/kapow-core
	chmod 755 build/wp-content/plugins/kapow-core
	cp -a $coredir/* build/wp-content/plugins/kapow-core
fi

# Remove the archives for good housekeeping.
rm *.zip
rm -r kapow-*

# String replacements using input variables
for file in `find .  -type f ! -name 'kapow.sh' ! -name '.DS_Store' ! -name '*.png' ! -name '*.mo'`; do
	if [[ -f $file ]] && [[ -w $file ]]; then

		# Author URL - Must come before Slug.
		# We use hash as the delimiter string here to ensure that any slashes in
		# the url string don't mess things up.
		if [[ $authorurl ]]
		then
		sed -i "" "s#http://my-project.com#http://$authorurl#g" "$file"
		fi

		# Slug - hyphen and underscore replacements.
		if [[ $slug ]]
		then
		sed -i "" "s/my-project/$slug/g" "$file"

		underslug=`echo $slug|tr '-' '_'`
		sed -i "" "s/my_project/$underslug/g" "$file"
		fi

		# Nice Name.
		if [[ $nicename ]]
		then
		sed -i "" "s/My Project/$nicename/g" "$file"
		fi

		# Author Name.
		if [[ $authorname ]]
		then
		sed -i "" "s/Author Name/$authorname/g" "$file"
		fi

		# Author Email.
		if [[ $authoremail ]]
		then
		sed -i "" "s/hello@my-project.com/$authoremail/g" "$file"
		fi

	fi
done

# Rename the .pot file
if [ $slug ]
	then
	potdir="build/wp-content/themes/$slug/languages"
	potfile="my-project"
	rootdir="$PWD"

	if [ $potdir ]
		then

		cd $potdir
		mv "$potfile.pot" "$slug.pot"
		cd $rootdir
	fi

fi

# Install All The Things(tm).
bower install && npm install

# Build the project.
grunt

# Append the site config to user's vvv-custom.yml
# if it exists in the usual location.
echo "Attempting to manually update your VVV configuration..."

vagrantfile="/Users/$USER/Vagrant/vvv-custom.yml"

if [ -f $vagrantfile ]

	then

	echo "  $slug:
	    hosts:
	      - $slug.dev
	    nginx_upstream: php71" >> $vagrantfile

	echo "$(tput setaf 2)Success! New VVV site configured for'$slug' in:
$vagrantfile$(tput setaf 9)"

	else

	echo "$(tput setaf 3)Your vvv-custom.yml file cannot be located!

Please add the following VVV site configuration to your file.

$(tput setaf 2)  $slug:
    hosts:
      - $slug.dev
    nginx_upstream: php71$(tput setaf 9)"
fi
