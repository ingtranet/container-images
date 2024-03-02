ARG REPO_PREFIX
ARG L4T_VERSION
FROM ${REPO_PREFIX}docker.io/dustynv/pytorch:2.1-r$L4T_VERSION AS builder

WORKDIR /tmp

ARG AUTOAWQ_KERNEL_VERSION
ARG AUTOAWQ_VERSION
ARG CUDA_ARCH

WORKDIR /tmp/build

RUN mkdir /tmp/wheels
RUN apt update -y && apt install -y git
RUN pip install build

RUN git clone --depth 1 --branch v${AUTOAWQ_KERNEL_VERSION} https://github.com/casper-hansen/AutoAWQ_kernels.git && \
    cd AutoAWQ_kernels && \
    sed "s|{75, 80, 86, 89, 90}|{ ${CUDA_ARCH} }|g" -i setup.py && \
    cat setup.py | grep 'compute_capabilities' && \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH python3 -m build --no-isolation && \
    pip3 install ./dist/autoawq_kernels*.whl && \
    mv ./dist/*.whl /tmp/wheels
    
RUN git clone --depth 1 --branch v${AUTOAWQ_VERSION} https://github.com/casper-hansen/AutoAWQ.git && \
    cd AutoAWQ && \
    python3 -m build --no-isolation && \
    mv ./dist/*.whl /tmp/wheels
 
FROM scratch

COPY --from=builder /tmp/wheels /wheels
