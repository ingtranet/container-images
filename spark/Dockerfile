ARG JAVA_VERSION
FROM eclipse-temurin:$JAVA_VERSION-jdk AS builder

ARG ICEBERG_VERSION
ARG SPARK_VERSION
ARG SCALA_VERSION

WORKDIR /build

RUN apt update -y && \
    apt install -y wget python3 python3-pip

RUN wget http://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz && \
    tar zxf spark-$SPARK_VERSION.tgz

WORKDIR /build/spark-$SPARK_VERSION

ENV MAVEN_OPTS="-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"
RUN ./dev/change-scala-version.sh $SCALA_VERSION && \
    ./dev/make-distribution.sh \
      --name ingtranet --pip --tgz \
      -X -Pscala-$SCALA_VERSION -Phive -Phive-thriftserver -Pkubernetes -Phadoop-cloud
RUN tar zxf spark-$SPARK_VERSION-bin-ingtranet.tgz && \
    mv /build/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-ingtranet /

WORKDIR /spark-$SPARK_VERSION-bin-ingtranet/jars

RUN wget http://maven-central-asia.storage-download.googleapis.com/maven2/org/bouncycastle/bcprov-jdk18on/1.71/bcprov-jdk18on-1.71.jar
RUN wget http://maven-central-asia.storage-download.googleapis.com/maven2/org/bouncycastle/bcpkix-jdk18on/1.71/bcpkix-jdk18on-1.71.jar
RUN wget http://maven-central-asia.storage-download.googleapis.com/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_$SCALA_VERSION/$ICEBERG_VERSION/iceberg-spark-runtime-3.3_$SCALA_VERSION-$ICEBERG_VERSION.jar
##### BUILD FINISHED #####

ARG JAVA_VERSION
FROM eclipse-temurin:$JAVA_VERSION

ARG SPARK_VERSION
ARG spark_uid=185

RUN set -ex && \ 
    mkdir -p /opt/spark && \
    mkdir -p /opt/spark/examples && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd

RUN apt update -y && \
    apt install -y tini && \
    rm -rf /var/cache/apt/*

COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/jars /opt/spark/jars
COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/bin /opt/spark/bin
COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/sbin /opt/spark/sbin
COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/kubernetes/dockerfiles/spark/entrypoint.sh /opt/
COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/kubernetes/dockerfiles/spark/decom.sh /opt/
COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/examples /opt/spark/examples
COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/kubernetes/tests /opt/spark/tests
COPY --from=builder /spark-$SPARK_VERSION-bin-ingtranet/data /opt/spark/data

ENV SPARK_HOME /opt/spark

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir
RUN chmod a+x /opt/decom.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER ${spark_uid}
