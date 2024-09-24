ARG REPO_PREFIX
ARG L4T_VERSION
FROM ${REPO_PREFIX}docker.io/dustynv/transformers:r$L4T_VERSION AS builder

WORKDIR /tmp

ARG AUTOAWQ_KERNEL_VERSION
ARG AUTOAWQ_VERSION
ARG CUDA_ARCH

WORKDIR /tmp/build

RUN mkdir /tmp/wheels
RUN apt update -y && apt install -y git

RUN git clone --depth 1 --branch v${AUTOAWQ_KERNEL_VERSION} https://github.com/casper-hansen/AutoAWQ_kernels.git && \
    cd AutoAWQ_kernels && \
    sed "s|{75, 80, 86, 89, 90}|{ ${CUDA_ARCH} }|g" -i setup.py && \
    cat setup.py | grep 'compute_capabilities' && \
    MAX_JOBS=4 python3 setup.py --verbose bdist_wheel && \
    pip3 install ./dist/autoawq_kernels*.whl && \
    mv ./dist/*.whl /tmp/wheels
    
RUN git clone --depth 1 --branch v${AUTOAWQ_VERSION} https://github.com/casper-hansen/AutoAWQ.git && \
    cd AutoAWQ && \
    MAX_JOBS=4 python3 setup.py --verbose bdist_wheel && \
    mv ./dist/*.whl /tmp/wheels
 
FROM busybox:1.36.1

COPY --from=builder /tmp/wheels /wheels
