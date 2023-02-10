ARG QUERYBOOK_VERSION

FROM querybook/querybook:$QUERYBOOK_VERSION

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt