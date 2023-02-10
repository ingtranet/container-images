#!/bin/bash
set -ex
wget https://archive.apache.org/dist/incubator/kyuubi/kyuubi-$KYUUBI_VERSION-incubating/apache-kyuubi-$KYUUBI_VERSION-incubating-bin.tgz
tar zxvf apache-kyuubi-$KYUUBI_VERSION-incubating-bin.tgz
./apache-kyuubi-$KYUUBI_VERSION-incubating-bin/bin/docker-image-tool.sh \
    -r ingtranet-kyuubi -t latest -S /opt/spark -b BASE_IMAGE=$SPARK_IMAGE:$SPARK_TAG build
