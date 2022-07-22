FROM eclipse-temurin:17-jdk AS builder

ENV VERSION=3.3.0

WORKDIR /build

RUN apt update -y && \
    apt install -y wget python3 python3-pip

RUN wget http://dlcdn.apache.org/spark/spark-$VERSION/spark-$VERSION.tgz && \
    tar zxf spark-$VERSION.tgz

WORKDIR /build/spark-$VERSION

ENV MAVEN_OPTS="-Xss64m -Xmx2g -XX:ReservedCodeCacheSize=1g"
RUN ./dev/change-scala-version.sh 2.13 && \
    ./dev/make-distribution.sh \
      --name ingtranet --pip --tgz \
      -X -Pscala-2.13 -Phive -Phive-thriftserver -Pkubernetes -Phadoop-cloud
RUN tar zxf spark-$VERSION-bin-ingtranet.tgz && \
    mv /build/spark-$VERSION/spark-$VERSION-bin-ingtranet /

WORKDIR /spark-$VERSION-bin-ingtranet/jars

RUN wget http://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk15on/1.71/bcprov-jdk15on-1.71.jar
RUN wget http://repo1.maven.org/maven2/org/bouncycastle/bcpkix-jdk15on/1.71/bcpkix-jdk15on-1.71.jar
RUN wget http://search.maven.org/remotecontent?filepath=org/apache/iceberg/iceberg-spark-runtime-3.3_2.13/0.14.0/iceberg-spark-runtime-3.3_2.13-0.14.0.jar

##### BUILD FINISHED #####

FROM eclipse-temurin:17

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

COPY --from=builder /spark-$VERSION-bin-ingtranet/jars /opt/spark/jars
COPY --from=builder /spark-$VERSION-bin-ingtranet/bin /opt/spark/bin
COPY --from=builder /spark-$VERSION-bin-ingtranet/sbin /opt/spark/sbin
COPY --from=builder /spark-$VERSION-bin-ingtranet/kubernetes/dockerfiles/spark/entrypoint.sh /opt/
COPY --from=builder /spark-$VERSION-bin-ingtranet/kubernetes/dockerfiles/spark/decom.sh /opt/
COPY --from=builder /spark-$VERSION-bin-ingtranet/examples /opt/spark/examples
COPY --from=builder /spark-$VERSION-bin-ingtranet/kubernetes/tests /opt/spark/tests
COPY --from=builder /spark-$VERSION-bin-ingtranet/data /opt/spark/data

ENV SPARK_HOME /opt/spark

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir
RUN chmod a+x /opt/decom.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER ${spark_uid}
