# Kapow! Team...ASSEMBLE!!!
# -----------------------------------------------------------------------------

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
skeldir="kapow-skeleton-master";
if [ -d $skeldir ]
  then
  cp -a $skeldir/* kapow/
fi

# Move Sass
sassdir="kapow-sass-master";
if [ -d $sassdir ]
  then
  cp -a $sassdir/* kapow/assets/sass
fi

# Move Grunt
gruntdir="kapow-grunt-master";
if [ -d $gruntdir ]
  then
  cp -a $gruntdir/* kapow/
fi

# Move Theme
themedir="kapow-theme-master";
if [ -d $themedir ]
  then
  mkdir kapow/htdocs/wp-content/themes/my-project
  cp -a $themedir/* kapow/htdocs/wp-content/themes/my-project
fi

# Remove the archives
rm *.zip
rm -r kapow-*

# Clone WordPress and install NPM & Bower dependencies
cd kapow

rm -r htdocs/wordpress

git submodule add -f git@github.com:WordPress/WordPress.git htdocs/wordpress

npm install && bower install
