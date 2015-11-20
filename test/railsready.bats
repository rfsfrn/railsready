#!/usr/bin/env bats
#
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>

load test_helper

setup() {
  cd "${RAILSREADY_ROOT}"
}

@test "railsready directory structure check - LICENSE" {
  [ -e $RAILSREADY_ROOT/LICENSE ]
  run cat 'LICENSE'
  assert_output <<OUT
The MIT License (MIT)

Copyright (c) 2015 rfsfrn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
OUT
}

@test "railsready directory structure check - README.md" {
  [ -e $RAILSREADY_ROOT/README.md ]
}

@test "railsready directory structure check - railsready" {
  [ -e $RAILSREADY_ROOT/railsready ]
}

@test "railsready directory structure check - test/lib/assertions.bash" {
  [ -e $RAILSREADY_TEST_ROOT/lib/assertions.bash ]
}

@test "railsready directory structure check - test/libexec/all" {
  [ -e $RAILSREADY_TEST_ROOT/libexec/all ]
}

@test "railsready directory structure check - test/railsready-bats.bats" {
  [ -e $RAILSREADY_TEST_ROOT/railsready-bats.bats ]
}

@test "railsready directory structure check - test/railsready-help.bats" {
  [ -e $RAILSREADY_TEST_ROOT/railsready-help.bats ]
}

@test "railsready directory structure check - test/railsready-mysql.bats" {
  [ -e $RAILSREADY_TEST_ROOT/railsready-mysql.bats ]
}

@test "railsready directory structure check - test/railsready-rails.bats" {
  [ -e $RAILSREADY_TEST_ROOT/railsready-rails.bats ]
}

@test "railsready directory structure check - test/railsready.bats" {
  [ -e $RAILSREADY_TEST_ROOT/railsready.bats ]
}

@test "railsready directory structure check - test/run.sh" {
  [ -e $RAILSREADY_TEST_ROOT/run.sh ]
}

@test "railsready directory structure check - test/test_helper.bash" {
  [ -e $RAILSREADY_TEST_ROOT/test_helper.bash ]
}

@test "it can bootstrap railsready app" {
  move_workspace_root
  app_name='test_app'
  run bash -c "railsready '${app_name}'"
  assert_status 0
  cd ${app_name}
  run bundle exec rails s --daemon
  run pgrep -f ".*rails s"
  run bash -c "curl -s -k 'http://localhost:3000' 2>/dev/null"
  assert_match "<title>Ruby on Rails: Welcome aboard</title>" "$output"
  run bash -c "kill -9 $(lsof -i :3000 -t)"
  assert_status 0
  run clean
  assert_status 0
}
