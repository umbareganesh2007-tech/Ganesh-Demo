#!/usr/bin/env bash
set -euo pipefail

PORT=8080
WORKDIR="/workspace"

if curl -sf "http://localhost:${PORT}/" > /dev/null 2>&1; then
  echo "Web server already listening on port ${PORT}."
  exit 0
fi

cd "${WORKDIR}"
nohup python3 -m http.server "${PORT}" > /tmp/http-server.log 2>&1 &

for _ in $(seq 1 30); do
  if curl -sf "http://localhost:${PORT}/" > /dev/null; then
    echo "Web server ready at http://localhost:${PORT}/"
    exit 0
  fi
  sleep 1
done

echo "Web server failed to become ready on port ${PORT}."
exit 1
