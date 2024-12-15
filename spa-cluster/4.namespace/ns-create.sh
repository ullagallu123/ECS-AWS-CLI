#!/bin/bash
aws servicediscovery create-private-dns-namespace \
    --name spa-crud \
    --vpc vpc-057811f3f42dec09f

echo "Here are the ns avaialable"
aws servicediscovery list-namespaces
