#!/bin/bash
aws servicediscovery create-service \
    --name mongo \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name mysql \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name redis \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name rabbit \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name catalogue \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name cart \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name user \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name shipping \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name payment \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name web \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name debug \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery create-service \
    --name dispatch \
    --namespace-id ns-asl6syvjpdvlthvc \
    --dns-config "NamespaceId=ns-asl6syvjpdvlthvc,RoutingPolicy=WEIGHTED,DnsRecords=[{Type=A,TTL=60}]"

aws servicediscovery list-services \
    --query "Services[*].[Id,Name]" \
    --output table

