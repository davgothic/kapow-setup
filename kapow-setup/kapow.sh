#!/usr/bin/env bash
# Kapow! Setup Script - Requires a Bash shell on OSX
# -----------------------------------------------------------------------------

echo "$(tput setaf 2)Initialising Kapow! Setup script...$(tput setaf 9)"

hash git 2>&- || { echo >&2 "Git is required but missing. Exiting."; exit 1; }
hash unzip 2>&- || { echo >&2 "Unzip is required but missing. Exiting."; exit 1; }
hash curl 2>&- || { echo >&2 "cURL is required but missing. Exiting."; exit 1; }

# Input variables
if [ "$1" = "develop" ]
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

# If we have no slug, default to the
# standard 'my-project' slug.
if [ ! "$slug" ]
	then
	slug="my-project"
fi

# Import the Kapow! config file if it exists.
echo "$(tput setaf 3)Checking for Kapow! configuration file...$(tput setaf 9)"
echo

gitdir=".git"
configfile="kapow.config"

if [ -f "$configfile" ]
	then

		echo "$(tput setaf 2)Config file found! Loading...$(tput setaf 9)"
		echo
		source kapow.config
	else

	# Default Setup variables.
	setuprepository=true
	setupbranches=true

	# Default Skeleton variables.
	skeletonphpversion="71"
	skeletonwpplugins=true
	skeletonwpsalts=true
	skeletonupdateoptions=true
	skeletonwptestdata=true
	skeletonprecommitwpcs=true

	# Default Sass variables.
	sassnormalize=true
	sassframework="noframework"

	# Default Grunt variables.
	gruntlintphp=false
	gruntlintscss=false
	gruntlintjs=false
	gruntdocumentphp=false
	gruntdocumentscss=false
	gruntdocumentjs=false
	gruntlegacybrowsers=false
fi

# Create the repository.
if [ "$setuprepository" ]

	then

	# Ask if a repository needs to be created.
	printf "$(tput setaf 3)Would you like to create a new GitHub repository? (y/n) $(tput setaf 9)"
	read -e createrepo
	echo

	# Proceed if yes.
	if [ "$createrepo" = "y" ]

		then

			# Check to see if this script is being executed from an existing repository.
			if [ ! -d "$gitdir" ]

				then

					# Ask for GitHub org username.
					printf "$(tput setaf 3)Please enter the GitHub organisation username: $(tput setaf 9)"
					read -e githuborg
					echo

					# Exit if no GitHub org username entered.
					if [ -z "$githuborg" ]

						then

						echo "$(tput setaf 1)ERROR: no GitHub organisation username entered!$(tput setaf 9)"
						echo

						exit 1

					fi

					# Ask for GitHub username.
					printf "$(tput setaf 3)Please enter your GitHub username: $(tput setaf 9)"
					read -e githubuser
					echo

					# Exit if no GitHub username entered.
					if [ -z "$githubuser" ]

						then

						echo "$(tput setaf 1)ERROR: no GitHub username entered!$(tput setaf 9)"
						echo

						exit 1

					fi

					# Attempt to create the repository
					echo "$(tput setaf 3)Attempting to create the repository on GitHub...$(tput setaf 9)"
					echo

					httpresponse=$(curl --silent -u "$githubuser" -w 'HTTPSTATUS:%{http_code}' -d "{\"name\":\"$slug\",\"private\":\"true\"}" https://api.github.com/orgs/"$githuborg"/repos)

					httpstatus=$(echo "$httpresponse" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

					# Proceed if successful.
					if [ "$httpstatus" = "201" ]
						then

							git clone git@github.com:"$githuborg"/"$slug".git

							if [ -d "$slug" ]

								then

								echo "$(tput setaf 2)Repository successfully created and cloned!$(tput setaf 9)"
								echo

								# Enter the repository directory.
								echo "$(tput setaf 3)Switching to repository directory...$(tput setaf 9)"
								echo

								cd "$slug"

							fi

						else

							echo "$(tput setaf 1)ERROR: failed to create the repository!$(tput setaf 9)"
							echo

							exit 1

					fi

				else

					echo "$(tput setaf 1)ERROR: this script has been executed inside an existing repository!$(tput setaf 9)"
					echo

					exit 1

			fi

	fi

fi

# GitHub Kapow URL prefix & suffix.
prefix="https://github.com/kapow-wp/kapow-";
suffix="/archive/$branch.zip";

# Array of Kapow! component names.
declare -a arr=("skeleton" "sass" "grunt" "theme" "core" "project-core")

# Fetch and extract the archives from GitHub.
echo "$(tput setaf 3)Downloading Kapow! repositories...$(tput setaf 9)"
echo
for i in "${arr[@]}"
	do
		file="$i.zip"

		curl -s -Lo "$file" "$prefix$i$suffix"

		unzip "$file" > /dev/null 2>&1
done

echo "$(tput setaf 3)Scaffolding the instance...$(tput setaf 9)"
echo

# Move Skeleton.
skeldir="kapow-skeleton-$branch/kapow-skeleton";
if [ -d "$skeldir" ]
	then
	cp -r "$skeldir"/* .
	cp -r "$skeldir"/.gitignore .
fi

# Move Sass.
sassdir="kapow-sass-$branch/kapow-sass";
if [ -d "$sassdir" ]
	then
	cp -a "$sassdir"/* assets/scss
fi

# Move Grunt.
gruntdir="kapow-grunt-$branch/kapow-grunt";
if [ -d "$gruntdir" ]
	then
	cp -a "$gruntdir"/* .
fi

# Move Theme.
themedir="kapow-theme-$branch/kapow-theme";
if [ -d "$themedir" ]
	then

	# Create the theme directory, give it
	# the correct permissions and then
	# copy the theme files over.
	mkdir build/wp-content/themes/"$slug"
	chmod 755 build/wp-content/themes/"$slug"
	cp -a "$themedir"/* build/wp-content/themes/"$slug"
fi

# Move Core.
coredir="kapow-core-$branch/kapow-core";
if [ -d "$coredir" ]
	then
	# Create the core plugin directory, give it
	# the correct permissions and then
	# copy the theme files over.
	mkdir build/wp-content/plugins/kapow-core
	chmod 755 build/wp-content/plugins/kapow-core
	cp -a "$coredir"/* build/wp-content/plugins/kapow-core
fi

# Move Project Core.
projectcoredir="kapow-project-core-$branch/project-core";
if [ -d "$projectcoredir" ]
	then
	# Create the project core plugin directory, give it
	# the correct permissions and then
	# copy the theme files over.
	mkdir build/wp-content/plugins/project-core
	chmod 755 build/wp-content/plugins/project-core
	cp -a "$projectcoredir"/* build/wp-content/plugins/project-core
fi

# Remove the archives for good housekeeping.
rm ./*.zip
rm -r kapow-*

# String replacements using input variables
echo "$(tput setaf 3)Carrying out string replacements...$(tput setaf 9)"
echo
for file in $(find .  -type f ! -name 'kapow.sh' ! -name 'kapow.config' ! -name '.DS_Store' ! -name '*.png' ! -name '*.mo'); do
	if [[ -f $file ]] && [[ -w $file ]]; then

		# This is needed in order for this script to work with BSD & GNU sed
		bakfile=".bak"

		# Author URL - Must come before Slug.
		# We use hash as the delimiter string here to ensure that any slashes in
		# the url string don't mess things up.
		if [[ "$authorurl" ]]
		then
		sed -i$bakfile "s#http://my-project.com#http://$authorurl#g" "$file"
		fi

		# Slug - hyphen and underscore replacements.
		if [[ "$slug" ]]
		then
		sed -i$bakfile "s/my-project/$slug/g" "$file"

		underslug=$(echo $slug|tr '-' '_')
		sed -i$bakfile "s/my_project/$underslug/g" "$file"
		fi

		# Nice Name.
		if [[ "$nicename" ]]
		then
		sed -i$bakfile "s/My Project/$nicename/g" "$file"
		fi

		# Author Name.
		if [[ "$authorname" ]]
		then
		sed -i$bakfile "s/Author Name/$authorname/g" "$file"
		fi

		# Author Email.
		if [[ "$authoremail" ]]
		then
		sed -i$bakfile "s/hello@my-project.com/$authoremail/g" "$file"
		fi

	fi
done

# Remove all the .bak files
find . -name '*.bak' -delete

# Rename the .pot file
if [ "$slug" ]
	then
	potdir="build/wp-content/themes/$slug/languages"
	potfile="my-project"
	rootdir="$PWD"

	if [ "$potdir" ]
		then

		cd "$potdir" || exit
		mv "$potfile.pot" "$slug.pot"
		cd "$rootdir" || exit
	fi

fi

# Implement Kapow! config settings.
# For reference, the variables in the vvv-init.sh
# script are set as follows:
#
# plugins=true
# salts=true
# options=true
# testdata=true
# precommit=true
echo "$(tput setaf 3)Configuring Kapow! instance...$(tput setaf 9)"
echo
# @todo - Script all the core variable updates!

# Install All The Things(tm).
echo "$(tput setaf 3)Installing Bower dependencies...$(tput setaf 9)"
echo
bower install

echo "$(tput setaf 3)Installing NPM dependencies...$(tput setaf 9)"
echo
npm install

echo "$(tput setaf 3)Installing Composer dependencies...$(tput setaf 9)"
echo
composer install

# Modify the Git pre-commit hook to write PHPCS output to file.
precommitfile=".git/hooks/pre-commit"
precommittarget="--standard=./phpcs.xml"
precommitextra="--report-full=./reports/wpcs.md"
if [ -f "$precommitfile" ]
	then

	sed -i "" "s#$precommittarget#$precommittarget $precommitextra#g" "$precommitfile"
fi

# Build the project.
grunt

# Append the site config to user's vvv-custom.yml
# if it exists in the usual location.
echo "$(tput setaf 3)Attempting to manually update your VVV configuration...$(tput setaf 9)"
echo

vagrantfile="/Users/$USER/Vagrant/vvv-custom.yml"
if [ -f "$vagrantfile" ]

	then

	echo "  $slug:
    hosts:
      - $slug.dev
    nginx_upstream: php$skeletonphpversion" >> "$vagrantfile"

	echo "$(tput setaf 2)A new VVV site has been configured for '$slug' in:
$vagrantfile$(tput setaf 9)"
	echo

	else

	echo "$(tput setaf 3)Your vvv-custom.yml file cannot be located!

Please add the following VVV site configuration to your file.

$(tput setaf 2)  $slug:
    hosts:
      - $slug.dev
    nginx_upstream: php$skeletonphpversion$(tput setaf 9)"
	echo
fi

# Remove Kapow! Setup!
echo "$(tput setaf 3)Removing Kapow! Setup files...$(tput setaf 9)"
echo

kapowscript="kapow.sh"
if [ -f "$kapowscript" ]
	then

	rm kapow.sh
fi

kapowconfig="kapow.config"
if [ -f "$kapowconfig" ]
	then

	rm kapow.config
fi


# Success!
echo "$(tput setaf 3)Success! Your Kapow! instance has now been created.$(tput setaf 9)"
echo

# Commit and push to repo now or not?
printf "$(tput setaf 3)Would you like to commit and push now? (y|n) "
read -e COMMITPUSH
echo

if [ "$COMMITPUSH" = "y" ] && [ -d "$gitdir" ]
	then

	echo "$(tput setaf 3)Committing and pushing to repo...$(tput setaf 9)"
	echo

	git add .
	git commit -m "Initial Kapow! instance."
	git push origin master

	# Setup branches.
	if [ "$setupbranches" = true ] && [ -d "$gitdir" ]
		then

			echo "$(tput setaf 3)Creating the addition default branches (staging, develop)...$(tput setaf 9)"
			echo

			# Staging
			git checkout -b staging

			git push origin staging

			git branch --set-upstream-to=origin/staging staging

			# Develop

			git checkout -b develop

			git push origin develop

			git branch --set-upstream-to=origin/develop develop
	fi
fi

# Provision now or not?
printf "$(tput setaf 3)Would you like to provision this site now? (y|n) "
read -e PROVISION
echo

if [ "$PROVISION" = "y" ]
	then

	echo "$(tput setaf 3)Provisioning $slug.dev...$(tput setaf 9)"
	echo

	vagrant provision --provision-with=site-"$slug"

	else

	echo "$(tput setaf 3)No problem, just run this command when you're ready...$(tput setaf 9)"
	echo "$(tput setaf 2)vagrant provision --provision-with=site-$slug$(tput setaf 9)"
	echo
fi
