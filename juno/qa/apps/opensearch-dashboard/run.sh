docker run --rm \
           -v $(pwd)/opensearch_dashboards.yml:/usr/share/opensearch-dashboards/config/opensearch_dashboards.yml \
           -v $(pwd)/../../shared:/opt/certs \
           --network host \
           opensearchproject/opensearch-dashboards:2.2.1