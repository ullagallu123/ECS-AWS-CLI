#!/bin/bash
CLUSTER_NAME="roboshop"

# List and update services to set desired count to 0
SERVICES=$(aws ecs list-services --cluster $CLUSTER_NAME --query 'serviceArns' --output text)
for SERVICE in $SERVICES; do
    # Update the service to set desired count to 0
    aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE --desired-count 0
    echo "Scaled down service to 0: $SERVICE"
done

# Wait for services to stabilize
echo "Waiting for services to stabilize..."
sleep 30  # Adjust the sleep time as necessary

# List and delete services
for SERVICE in $SERVICES; do
    aws ecs delete-service --cluster $CLUSTER_NAME --service $SERVICE
    echo "Deleted service: $SERVICE"
done

# List and stop tasks
TASKS=$(aws ecs list-tasks --cluster $CLUSTER_NAME --query 'taskArns' --output text)
for TASK in $TASKS; do
    aws ecs stop-task --cluster $CLUSTER_NAME --task $TASK
    echo "Stopped task: $TASK"
done

# Delete the cluster
aws ecs delete-cluster --cluster $CLUSTER_NAME
echo "Deleted cluster: $CLUSTER_NAME"