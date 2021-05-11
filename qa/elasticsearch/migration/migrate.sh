#!/bin/sh

apt-get update && apt-get install -y curl;

for INDEX in $(curl http://elasticsearch-workers:9200/_cat/indices?h=idx)
do
    elasticdump \
      --input="http://elasticsearch-workers:9200/$INDEX" \
      --output="http://elasticsearch-workers-incoming:9200/$INDEX" \
      --type=settings

    elasticdump \
      --input="http://elasticsearch-workers:9200/$INDEX" \
      --output="http://elasticsearch-workers-incoming:9200/$INDEX" \
      --type=mapping

    elasticdump \
      --limit=300 \
      --concurrency=5 \
      --input="http://elasticsearch-workers:9200/$INDEX" \
      --output="http://elasticsearch-workers-incoming:9200/$INDEX" \
      --type=data
done