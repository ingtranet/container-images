FROM apache/airflow:2.2.4-python3.9

USER root
RUN apt update -y && apt install -y build-essential libsasl2-dev

USER airflow
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

USER root
RUN rm /tmp/requirements.txt

USER airflow