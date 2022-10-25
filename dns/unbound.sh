#!/usr/bin/env bash

echo "nameserver 127.0.0.1" > /etc/resolv.conf

if [[ "${LOGGING}" = yes ]]; then
  {
    echo "server:"
    echo "  log-local-actions: yes"
    echo "  log-queries: yes"
    echo "  log-replies: yes"
    echo "  log-servfail: yes"
    echo "  verbosity: 1"
  } > /etc/unbound/unbound.conf.d/logging.conf
fi

unbound -c /etc/unbound/unbound.conf
