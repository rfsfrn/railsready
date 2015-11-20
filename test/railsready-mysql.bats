#!/usr/bin/env bats
#
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>

load test_helper

@test "check that the mysql client is available" {
  run bash -c 'command -v mysql'
  assert_status 0
}

@test "starts mysql" {
  run pgrep -f "mysql"
}
