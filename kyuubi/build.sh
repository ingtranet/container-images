#!/bin/bash
set -ex
wget https://dlcdn.apache.org/kyuubi/kyuubi-$KYUUBI_VERSION/apache-kyuubi-$KYUUBI_VERSION-bin.tgz
tar zxvf apache-kyuubi-$KYUUBI_VERSION-bin.tgz
./apache-kyuubi-$KYUUBI_VERSION-bin/bin/docker-image-tool.sh \
    -r ingtranet -t latest -S /opt/spark -b BASE_IMAGE=$SPARK_IMAGE:$SPARK_TAG build