#!/bin/bash
aws servicediscovery create-public-dns-namespace \
    --name "bapatlas.site" \
    --description "Namespace using the bapatlas.site hosted zone" \
    --creator-request-id "$(date +%s)"