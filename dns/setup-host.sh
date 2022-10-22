#!/usr/bin/env bash

set -euo pipefail

declare -i default_port=5300

function die() {
  echo "Fatal: $*" >&2
  exit 1
}

function installed_and_executable() {
  local name
  name="$(command -v "${1}")"

  [[ -n "${name}" ]] && [[ -f "${name}" ]] && [[ -x "${name}" ]]
  return $?
}

function check_deps() {
  deps=(iptables)
  for dep in "${deps[@]}"; do
    installed_and_executable "${dep}" || die "${dep} not installed"
  done
}

function set_up_rules() {
  local action="$1"
  local port="$2"
  shift; shift
  local nameservers=( "$@" )

  for nameserver in "${nameservers[@]}"; do
    printf "%s: %s\n" "[+] setting redirection for" "${nameserver}"

    if [[ "${action}" = create ]]; then
      iptables -t nat -A OUTPUT -d "${nameserver}" -p udp --dport 53 -j REDIRECT --to-ports "${port}"
    fi

    if [[ "${action}" = destroy ]]; then
      iptables -t nat -D OUTPUT -d "${nameserver}" -p udp --dport 53 -j REDIRECT --to-ports "${port}"
    fi
  done
}

function print_help() {
  cat<<END_HELP
Set up iptables rules for Docker dns container

Usage:
  setup-host.sh <-c|-d> [-p 5302]
  setup-host.sh -c -p 5300
  setup-host.sh -d -p 5300
  setup-host.sh -c
  setup-host.sh -h

Options:
  -c    Create rules
  -d    Destroy rules
  -p    Destination port
  -h    Print this help
END_HELP
}

function main() {
  check_deps

  IFS=" " read -r -a nameservers <<< "$(grep -E '^\s{0,}nameserver' /etc/resolv.conf | cut -d' ' -f2 | tr '\n' ' ')"

  action=
  port=${default_port}
  while getopts "cdhp:" opt; do
    case "${opt}" in
      c)
        action=create
        ;;
      d)
        action=destroy
        ;;
      h)
        print_help
        exit 0
        ;;
      p)
        port="${OPTARG}"
        ;;
      *)
        print_help
        exit 1
        ;;
    esac
  done

  if [[ -z "${action}" ]]; then
    printf "%s\n" "Choose either -c or -d"
    exit 1
  fi

  set_up_rules "${action}" "${port}" "${nameservers[@]}"
}

main "$@"
