#!/bin/bash

# Scale down the service
aws ecs update-service \
    --cluster spa \
    --service backend \
    --desired-count 0

# Delete the service
aws ecs delete-service \
    --cluster spa \
    --service backend
