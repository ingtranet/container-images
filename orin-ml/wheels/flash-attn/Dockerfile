ARG REPO_PREFIX
ARG L4T_VERSION
FROM ${REPO_PREFIX}docker.io/dustynv/pytorch:2.1-r$L4T_VERSION AS builder

ARG FLASH_ATTENTION_VERSION

WORKDIR /tmp/build

RUN apt update -y && apt install -y git
RUN pip install build packaging ninja
RUN git clone --depth 1 --branch v${FLASH_ATTENTION_VERSION} https://github.com/Dao-AILab/flash-attention.git
RUN cd flash-attention && \
    FLASH_ATTENTION_FORCE_BUILD=TRUE MAX_JOBS=4 python3 -m build --no-isolation
RUN mkdir /tmp/wheels && mv flash-attention/dist/*.whl /tmp/wheels

FROM scratch

COPY --from=builder /tmp/wheels /wheels
