export RAILSREADY_TEST_ROOT="$( cd "$( dirname "${BASH_SOURCE:-${(%):-%N}}" )" ; pwd )"
bash "${RAILSREADY_TEST_ROOT}/libexec/all" "$@"
