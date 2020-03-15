#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
IMAGE="openwhisk/standalone:nightly"
DOCKER_EXTRA_ARGS=""
JVM_EXTRA_ARGS=""
START="-d"
while getopts ":j:d:i:g" o; do
    case "${o}" in
        d)
            DOCKER_EXTRA_ARGS="${DOCKER_EXTRA_ARGS}${OPTARG} "
            ;;
        j)
            JVM_EXTRA_ARGS="${JVM_EXTRA_ARGS}${OPTARG} "
            ;;
        i)
            IMAGE="${OPTARG}"
            ;;
        g)  # undocumented debugging option
            START="-ti --entrypoint=/bin/bash"
            ;;
        *)
            echo "(-j <jvm-args>|-d <docker-run-arg>|-i <image-name>)* <openwhisk-arg>..."
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))
docker run --rm $START \
  -h openwhisk --name openwhisk -p 3280:3280 \
  -v //var/run/docker.sock:/var/run/docker.sock \
  $DOCKER_EXTRA_ARGS -e JVM_EXTRA_ARGS="$JVM_EXTRA_ARGS" "$IMAGE" "$@"
if docker exec openwhisk waitready
then
  case "$(uname)" in
   (Linux) xdg-open http://localhost:3280 ;;
   (Darwin) open http://localhost:3280 ;;
   (MINGW*) start http://localhost:3280 ;;
   (*) echo Please use http://localhost:3280 for playground ;;
  esac
else
  echo error starting standalone OpenWhisk
fi