#!/usr/bin/env bats
#
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>

load test_helper

@test "check that a 'gemrc' file exists" {
  run file ~/.gemrc
  assert_status 0
}

@test "Check that we have a '${RAILSREADY_TEMP_ROOT}' directory" {
  run stat ${RAILSREADY_TEMP_ROOT}
  assert_status 0
}

@test "ruby v2.x and rubygems v2.x are installed" {
  move_workspace_root
  # check if ruby is installed
  run ruby -v
  assert_status 0
  assert_match 'ruby 2'
  run gem -v
  assert_status 0
  assert_match '2'
}

@test "installs bundler gem if not already installed" {
  move_workspace_root
  # install bundler
  run gem install bundler --no-document
  assert_status 0
  assert_match ".*Successfully\ installed\ bundler*"
}

@test "bundler is installed" {
  move_workspace_root
  # check if bundler is installed
  run gem list bundler -i
  assert_status 0
}

@test "check that a 'Gemfile' file exists in ${RAILSREADY_TEMP_ROOT}" {
  run move_workspace_root
  assert_status 0
  # Initialize directory.
  run bundle init
  assert_success "Writing new Gemfile to ${RAILSREADY_TEMP_ROOT}/Gemfile"
  # Check if Gemfile file exists
  run file Gemfile
  assert_status 0
}

@test "replace the '#gem \"rails\"' to 'gem \"rails\", \"${RAILSREADY_RAILS_VERSION}\"" {
  run move_workspace_root
  assert_status 0
  # Replace `gem "rails"` to `gem "rails", "${RAILSREADY_RAILS_VERSION}"`
  run bash -c 'sed -i -e "s|^# gem \"rails\"|gem \"rails\", \"${RAILSREADY_RAILS_VERSION}\"|g" Gemfile'
  assert_status 0
  # Check the content of a Gemfile file
  run cat Gemfile
  assert_status 0
  assert_line 0 '# A sample Gemfile'
  assert_line 1 'source "https://rubygems.org"'
  assert_line 2 'gem "rails", "4.2.5"'
}

@test "install ruby on rails" {
  move_workspace_root
  # installs gem packages
  run bash -c "bundle install --path ${RAILSREADY_BUNDLE_PATH}"
  assert_status 0
  assert_match 'Bundle complete! 1 Gemfile dependency'
}

@test "rails is installed" {
  move_workspace_root
  run bash -c "bundle list 2>/dev/null | tail -n +2 | grep 'rails (${RAILSREADY_RAILS_VERSION})' | sed 's|^[ \t]*||'"
  assert_status 0
  assert_output "* rails (${RAILSREADY_RAILS_VERSION})"
  run bundle exec rails -v
  assert_status 0
  assert_success "Rails ${RAILSREADY_RAILS_VERSION}"
}

@test "generate rails application" {
  move_application_root
  run bash -c "bundle exec rails _${RAILSREADY_RAILS_VERSION}_ new . -B -T -d ${RAILSREADY_RAILS_DATABASE_NAME} -f"
  assert_status 0
  assert_match "config.ru"
}

@test "install rails application" {
  move_application_root
  run bash -c "bundle install --path ${RAILSREADY_BUNDLE_PATH}"
  assert_status 0
}

@test "rails should be v${RAILSREADY_RAILS_VERSION}" {
  move_application_root
  run bundle exec rails -v
  assert_equal "Rails ${RAILSREADY_RAILS_VERSION}" "$output"
}

@test "start rails server"  {
  move_application_root
  run bundle exec rails s --daemon
  assert_status 0
  run pgrep -f ".*rails s"
  assert_status 0
  assert_success $(lsof -i tcp:3000 -t)
}

@test "rails server is available on port 3000" {
  run nc -z 0.0.0.0 3000
  assert_status 0
}

#@test "rails server is available on port 443" {
#  run nc -z 0.0.0.0 443
#  assert_status 0
#}

@test "creates the database from DATABASE_URL or config/database.yml" {
  move_application_root
  run bundle exec rake db:create
  assert_status 0
}

@test "check web app is up"  {
  run bash -c "curl -s -k 'http://localhost:3000' 2>/dev/null"
  assert_match "<title>Ruby on Rails: Welcome aboard</title>" "$output"
}

@test "stop rails server" {
  run bash -c "kill -9 $(lsof -i tcp:3000 -t)"
  assert_status 0
}

@test "drops the database from DATABASE_URL or config/database.yml" {
  move_application_root
  run bundle exec rake db:drop
  assert_status 0
}

@test "clean application" {
  run clean
  assert_status 0
}
