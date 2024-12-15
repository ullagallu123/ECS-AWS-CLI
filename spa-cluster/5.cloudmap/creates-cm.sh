#!/bin/bash
aws servicediscovery create-service \
    --name spa-backend \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

