ARG OPENSEARCH_DASHBOARDS_VERSION

FROM opensearchproject/opensearch-dashboards:$OPENSEARCH_DASHBOARDS_VERSION
RUN /usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin remove securityDashboards
COPY --chown=opensearch-dashboards:opensearch-dashboards opensearch_dashboards.yml /usr/share/opensearch-dashboards/config/