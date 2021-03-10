### How to retrieve arranger configuration

wget http://localhost:9200/arranger-projects-cqdg/_search?q=*

For each "hit", copy the content of the "_source" field into the corresponding configmap. 