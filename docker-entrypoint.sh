#!/bin/bash
set -e

if [ ! -x "$JAVA_HOME/bin/java" ]; then
  echo "WARNING: JAVA_HOME was not mapped (ie: docker run -v /path/to/jdk1.8:/opt/java ..."
fi

exec "$@"
