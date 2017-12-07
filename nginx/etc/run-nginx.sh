#!/bin/bash
term_handler() {
  echo "Killing nginx"
  kill 14
  echo "Done"
  exit 0;
}

trap 'term_handler' SIGTERM EXIT

/bin/bash /etc/nginx/config.sh

nginx -g 'daemon off;' & wait ${1}
