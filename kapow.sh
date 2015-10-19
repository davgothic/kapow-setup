# Kapow! Setup Script - Requires Bash shell on OSX
# -----------------------------------------------------------------------------

# Input variables
slug=$1
nicename=$2
dbname=$3
authorname=$4
authoremail=$5

# GitHub Kapow URL prefix
prefix="https://github.com/mkdo/kapow-";
suffix="/archive/master.zip";

# Array of Kapow! component names
declare -a arr=("skeleton" "sass" "grunt" "theme")

# Fetch and extract the archives
for i in "${arr[@]}"
	do
		file="$i.zip"

		curl -Lo $file $prefix$i$suffix

		unzip $file
done

# Move Skeleton
skeldir="kapow-skeleton-master/kapow-skeleton";
if [ -d $skeldir ]
	then
	cp -r $skeldir/* .
	cp -r $skeldir/.gitignore .
fi

# Move Sass
sassdir="kapow-sass-master/kapow-sass";
if [ -d $sassdir ]
	then
	cp -a $sassdir/* assets/sass
fi

# Move Grunt
gruntdir="kapow-grunt-master/kapow-grunt";
if [ -d $gruntdir ]
	then
	cp -a $gruntdir/* .
fi

# Move Theme
themedir="kapow-theme-master/kapow-theme";
if [ -d $themedir ]
	then

	if [ ! $slug ]
	then
	slug="my-project"
	fi

	mkdir build/wp-content/themes/$slug
	chmod 755 build/wp-content/themes/$slug
	cp -a $themedir/* build/wp-content/themes/$slug
fi

# Remove the archives
rm *.zip
rm -r kapow-*

# String replacements using input variables
for file in `find .  -type f ! -name 'kapow.sh' ! -name '.DS_Store' ! -name '*.png' ! -name '*.mo'`; do
	if [[ -f $file ]] && [[ -w $file ]]; then

		# Slug
		if [[ $slug ]]
		then
		sed -i "" "s/my-project/$slug/g" "$file"
		fi

		# Nice Name
		if [[ $nicename ]]
		then
		sed -i "" "s/My Project/$nicename/g" "$file"
		fi

		# DB Name
		if [[ $dbname ]]
		then
		sed -i "" "s/my_project/$dbname/g" "$file"
		fi

		# Author Name
		if [[ $authorname ]]
		then
		sed -i "" "s/Author Name/$authorname/g" "$file"
		fi

		# Author Email
		if [[ $authoremail ]]
		then
		sed -i "" "s/hello@my-project.com/$authoremail/g" "$file"
		fi

	fi
done

# Install All The Things(tm)
npm install && bower install && composer install
