#!/usr/bin/env bash
#
#  Rails Ready -- Get ready for ruby on rails.
#
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>
#

## ============================================================================
## Parameters
## ============================================================================

# Check if application name exist.
[ $# -lt 1 ] && {
  echo -e "\033[1;33mUsage: shell> bash `basename $0` <name_of_your_rails_app>\033[0m" >&2
  exit 1
}

# Get the application module name.
project_name=${1}

# Set a default database.
database_name=${2:-mysql}

##
## ============================================================================
##

## ============================================================================
## Variables
## ============================================================================

# Set a default ruby on rails.
rails_version=${rails_version:-4.2.5}

# Set a default bundle path.
bundle_path='vendor/bundle'

##
## ============================================================================
##

## ============================================================================
## Ruby on Rails
## ============================================================================

## RubyGems
## ----------------------------------------------------------------------------

# Don't generate RDoc and RI documentation for gems.
test -e ~/.gemrc && grep -q 'no-document' ~/.gemrc || { echo "gem: --no-document" >> ~/.gemrc ; }

## Bundler
## ----------------------------------------------------------------------------

# Install bundler gem if it's not installed.
gem list bundler -i >/dev/null || { gem i bundler ; }

# Initialize directory.
test -e Gemfile || {
  bundle init >/dev/null 2>&1 || { echo 'bundle init faild' ; }
}

## Rails
## ----------------------------------------------------------------------------

# Replace '# gem "rails"' with 'gem "rails", "${rails_version}"'.
grep -q '^# gem "rails"$' Gemfile && {
  # Use RoR available in build root.
  sed -i "" -e "s|^# gem \"rails\"|gem \"rails\", \"${rails_version}\"|g" Gemfile
}

# Install ruby on rails.
bundle list 2>/dev/null | grep -qE "\* rails " || {
  # Install all gems defined in the Gemfile.
  bundle install --path "${bundle_path}" || { echo 'bundle install faild' ; }
}

##
## ============================================================================
##

## ============================================================================
## Application
## ============================================================================

## Rails application
## ----------------------------------------------------------------------------

# Make new directory.
test -d ${project_name} || mkdir ${project_name}

# Stores the project name of the current directory.
pushd ${project_name} >/dev/null

# Generate a new Rails application.
test -e config.ru || {
  bundle exec rails _${rails_version}_ new . -B -T -d ${database_name} -f
}

# Install all gems defined in the Gemfile.
bundle list 2>/dev/null | grep -qE "\* rails " || {
  bundle install --path "${bundle_path}" || { echo 'bundle install faild' ; }
}

# Set up DB.
bin/rake --version >/dev/null 2>&1 && {
  # Create the DB.
  bundle exec rake db:create
}

# Changes the current directory to the directory stored by the pushd command.
popd >/dev/null

##
## ============================================================================
##

echo "--> To start the server run 'pushd ${project_name} && bundle exec rails s'"
