ARG QUERYBOOK_VERSION

FROM querybook/querybook:$QUERYBOOK_VERSION

RUN pip install -r /opt/querybook/requirements/engine/hive.txt -r /opt/querybook/requirements/engine/trino.txt -r /opt/querybook/requirements/metastore/hms.txt