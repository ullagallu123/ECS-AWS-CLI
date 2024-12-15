#!/bin/bash
aws servicediscovery create-service \
    --name spa-backend \
    --namespace-id ns-5zsaptwcvbg3ve2z \
    --dns-config "NamespaceId=ns-5zsaptwcvbg3ve2z,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

