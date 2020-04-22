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
FROM scala
ARG OPENWHISK_JAR
ENV DOCKER_VERSION=18.06.3-ce
ENV WSK_VERSION=1.0.0
ENV TRAEFIK_VERSION=1.7.20
ADD init /
ADD stop waitready /bin/
RUN apt-get update && apt-get -y install jq ;\
  chmod +x /bin/stop /bin/waitready ;\
  curl -sL \
  https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
  | tar xzvf -  -C /usr/bin --strip 1 docker/docker ;\
  curl -sL \
  https://github.com/apache/openwhisk-cli/releases/download/${WSK_VERSION}/OpenWhisk_CLI-${WSK_VERSION}-linux-amd64.tgz \
  | tar xzvf - -C /usr/bin wsk
ADD ${OPENWHISK_JAR} /openwhisk-standalone.jar
ADD traefik.toml /etc/traefik.toml
ADD index.html /app/public/index.html
RUN curl -o /sbin/traefik -sL \
    https://github.com/containous/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_linux-amd64 && \
    chmod +x /sbin/traefik && \
    mkdir /app/actions
WORKDIR /
ENTRYPOINT  ["/init"]
