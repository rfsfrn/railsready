#!/usr/bin/env bats
#
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>

load test_helper

@test "it should have bats installed" {
  run which bats
  assert_status 0
}

@test "bats should be v${RAILSREADY_BATS_VERSION}" {
  run bash -c "bats -v | grep '${RAILSREADY_BATS_VERSION}'"
  assert_status 0
  assert_success "Bats ${RAILSREADY_BATS_VERSION}"
}

@test "no arguments prints usage instructions" {
  run bats
  assert_status 1
  assert_output <<OUT
Bats ${RAILSREADY_BATS_VERSION}
Usage: bats [-c] [-p | -t] <test> [<test> ...]
OUT
}

@test "-v and --version print version number" {
  run bats -v
  assert_status 0
  assert_match "Bats [0-9][0-9.]*"
}

@test "-h and --help print help" {
  run bats -h
  assert_status 0
  refute_line 10
  assert_output <<OUT
Bats ${RAILSREADY_BATS_VERSION}
Usage: bats [-c] [-p | -t] <test> [<test> ...]

  <test> is the path to a Bats test file, or the path to a directory
  containing Bats test files.

  -c, --count    Count the number of test cases without running any tests
  -h, --help     Display this help message
  -p, --pretty   Show results in pretty format (default for terminals)
  -t, --tap      Show results in TAP format
  -v, --version  Display the version number

  For more information, see https://github.com/sstephenson/bats
OUT
}

@test "invalid filename prints an error" {
  run bats nonexistent
  assert_status 1
  assert_match '.*does not exist.*'
}
