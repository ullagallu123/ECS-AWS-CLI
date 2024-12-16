#!/bin/bash

# Variables
TASK_DEFINITION_FAMILY="spa-backend"

# Get all revisions for the specified task definition family
echo "Fetching task definition revisions for family: $TASK_DEFINITION_FAMILY..."

# List revisions for the task definition family
TASK_DEFINITIONS=$(aws ecs list-task-definitions \
    --family-prefix "$TASK_DEFINITION_FAMILY" \
    --query 'taskDefinitionArns' \
    --output text)

# Loop through and deregister each revision
for task_definition in $TASK_DEFINITIONS; do
    echo "Deregistering $task_definition..."

    aws ecs deregister-task-definition \
        --task-definition "$task_definition"

    if [ $? -eq 0 ]; then
        echo "Successfully deregistered $task_definition"
    else
        echo "Failed to deregister $task_definition"
    fi
done

echo "All revisions under $TASK_DEFINITION_FAMILY have been deregistered."
