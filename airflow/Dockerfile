ARG AIRFLOW_VERSION
ARG PYTHON_VERSION

FROM apache/airflow:$AIRFLOW_VERSION-python$PYTHON_VERSION

USER root
RUN apt update -y && apt install -y build-essential libsasl2-dev

USER airflow
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

USER root
RUN rm /tmp/requirements.txt

USER airflow