#!/bin/bash
aws logs create-log-group --log-group-name /ecs/spa-backend
# for i in *.sh; do echo "Executing" $i; bash $i;done