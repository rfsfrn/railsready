#!/usr/bin/env bash
#
#  Test helper functions.
#
# Authors:
#   rfsfrn <rfsfrn@users.noreply.github.com>

source "${RAILSREADY_TEST_ROOT}/lib/assertions.bash"

export RAILSREADY_BATS_VERSION='0.4.0'

export RAILSREADY_ROOT="$( cd "$( dirname "${BASH_SOURCE:-${(%):-%N}}" )/.." ; pwd )"
export RAILSREADY_TEMP_ROOT="${RAILSREADY_TEST_ROOT}/tmp"
export RAILSREADY_APP_NAME=${RAILSREADY_APP_NAME:-example}
export RAILSREADY_APP_ROOT="${RAILSREADY_TEMP_ROOT}/${RAILSREADY_APP_NAME}"
export RAILSREADY_BUNDLE_PATH='vendor/bundle'
export RAILSREADY_RAILS_VERSION=${RAILSREADY_RAILS_VERSION:-4.2.5}
export RAILSREADY_RAILS_DATABASE_NAME='postgresql'
export RAILSREADY_LOG_PATH="${RAILSREADY_ROOT}/bats.log"

export PATH="${RAILSREADY_ROOT}:$PATH"

mkdir -p "${RAILSREADY_TEMP_ROOT}"
mkdir -p "${RAILSREADY_APP_ROOT}"
touch "${RAILSREADY_LOG_PATH}"

move_workspace_root() {
  cd "${RAILSREADY_TEMP_ROOT}"
}

move_application_root() {
  cd "${RAILSREADY_APP_ROOT}"
}

clean() {
  [ -d "${RAILSREADY_TEMP_ROOT}" ] && rm -rf "${RAILSREADY_TEMP_ROOT}"
}

setup() {
  true
  move_workspace_root
  echo "=====> set up start" >> "${RAILSREADY_LOG_PATH}"
  echo "BATS_TEST_NAME:        ${BATS_TEST_NAME}" >> "${RAILSREADY_LOG_PATH}"
  echo "BATS_TEST_FILENAME:    ${BATS_TEST_FILENAME}" >> "${RAILSREADY_LOG_PATH}"
  echo "BATS_TEST_DIRNAME:     ${BATS_TEST_DIRNAME}" >> "${RAILSREADY_LOG_PATH}"
  echo "BATS_TEST_NAMES:       ${BATS_TEST_NAMES[$INDEX]}" >> "${RAILSREADY_LOG_PATH}"
  echo "BATS_TEST_DESCRIPTION: ${BATS_TEST_DESCRIPTION}" >> "${RAILSREADY_LOG_PATH}"
  echo "BATS_TEST_NUMBER:      ${BATS_TEST_NUMBER}" >> "${RAILSREADY_LOG_PATH}"
  echo "BATS_TMPDIR:           ${BATS_TMPDIR}" >> "${RAILSREADY_LOG_PATH}"
  echo "=====> set up end" >> "${RAILSREADY_LOG_PATH}"
}
