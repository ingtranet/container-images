ARG REPO_PREFIX
ARG L4T_VERSION
FROM ${REPO_PREFIX}docker.io/dustynv/auto_gptq:r$L4T_VERSION

RUN mkdir /tmp/wheels
COPY --from=wheel-auto-awq /wheels/ /tmp/wheels
COPY --from=wheel-flash-attn /wheels/ /tmp/wheels

RUN pip install --no-cache-dir /tmp/wheels/*.whl
RUN pip install --no-cache-dir transformers==4.38.2
RUN pip install --no-cache-dir --ignore-installed mlserver mlserver-mlflow
RUN pip install --no-cache-dir --ignore-installed pydantic==1.10.12
