#!/usr/bin/env bats
#
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>

load test_helper

@test "invoke 'railsready' without arguments prints usage" {
  run bash -c "railsready"
  assert_status 1
  assert_failure "`echo -e "\033[1;33mUsage: shell> bash railsready <name_of_your_rails_app>\033[0m"`"
}
