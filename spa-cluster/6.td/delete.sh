#!/bin/bash

# Variables
TASK_DEFINITION_FAMILY="spa-backend"
TASK_DEFINITION_REVISION="1"

# Deregister the specific task definition
echo "Deregistering the task definition $TASK_DEFINITION_FAMILY:$TASK_DEFINITION_REVISION..."

aws ecs deregister-task-definition \
    --task-definition "${TASK_DEFINITION_FAMILY}:${TASK_DEFINITION_REVISION}"

# Confirm the deregistration
if [ $? -eq 0 ]; then
    echo "Task definition ${TASK_DEFINITION_FAMILY}:${TASK_DEFINITION_REVISION} has been successfully deregistered."
else
    echo "Failed to deregister the task definition ${TASK_DEFINITION_FAMILY}:${TASK_DEFINITION_REVISION}."
fi
