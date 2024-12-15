#!/bin/bash

# Variables
VPC_ID="vpc-057811f3f42dec09f"
SUBNETS=("subnet-01899a28d9cd091c2" "subnet-000f164cabd01ad15")
SECURITY_GROUP="sg-0c2026150f42233ac"
CLUSTER_NAME="spa"
SERVICE_NAME="backend"
HOSTED_ZONE_ID="Z08801502JQFVUXR02K9R"
DOMAIN_NAME="spa-backend.bapatlas.site"
CONTAINER_NAME="backend"

# 1. Create the Target Group
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
    --name spa \
    --protocol HTTP \
    --port 8080 \
    --vpc-id $VPC_ID \
    --target-type ip \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)
echo "Target Group ARN: $TARGET_GROUP_ARN"

# 1.1 Update Health Check for Target Group
aws elbv2 modify-target-group \
    --target-group-arn $TARGET_GROUP_ARN \
    --health-check-path "/health" \
    --health-check-port "8080" \
    --health-check-protocol HTTP

echo "Health check updated for Target Group ARN: $TARGET_GROUP_ARN"

# 2. Create the Load Balancer
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
    --name spa \
    --subnets ${SUBNETS[@]} \
    --security-groups $SECURITY_GROUP \
    --scheme internet-facing \
    --query 'LoadBalancers[0].LoadBalancerArn' \
    --output text)

echo "Load Balancer ARN: $LOAD_BALANCER_ARN"

# 3. Create the HTTP Listener
aws elbv2 create-listener \
    --load-balancer-arn $LOAD_BALANCER_ARN \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN

echo "HTTP Listener created for Load Balancer ARN: $LOAD_BALANCER_ARN"

# 4. Update ECS Service with Load Balancer details
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --load-balancers targetGroupArn=$TARGET_GROUP_ARN,containerName=$CONTAINER_NAME,containerPort=8080

echo "ECS Service updated with Target Group ARN: $TARGET_GROUP_ARN"

# # 5. Get ALB DNS Name
# ALB_DNS=$(aws elbv2 describe-load-balancers \
#     --names roboshop \
#     --query 'LoadBalancers[0].DNSName' \
#     --output text)

# echo "ALB DNS Name: $ALB_DNS"

# # 6. Create Route 53 DNS record for ALB (Use UPSERT)
# aws route53 change-resource-record-sets \
#   --hosted-zone-id $HOSTED_ZONE_ID \
#   --change-batch '{
#     "Changes": [{
#       "Action": "UPSERT",
#       "ResourceRecordSet": {
#         "Name": "'$DOMAIN_NAME'",
#         "Type": "CNAME",
#         "TTL": 1,
#         "ResourceRecords": [{
#           "Value": "'$ALB_DNS'"
#         }]
#       }
#     }]
#   }'

# echo "Route 53 CNAME record updated for $DOMAIN_NAME"

# # 7. Request ACM certificate and get CERTIFICATE_ARN dynamically
# CERTIFICATE_ARN=$(aws acm request-certificate \
#     --domain-name $DOMAIN_NAME \
#     --validation-method DNS \
#     --options CertificateTransparencyLoggingPreference=ENABLED \
#     --query 'CertificateArn' \
#     --output text)

# echo "ACM Certificate requested: $CERTIFICATE_ARN"

# # 8. Check ACM Certificate Status
# while true; do
#     STATUS=$(aws acm describe-certificate --certificate-arn $CERTIFICATE_ARN \
#         --query 'Certificate.Status' --output text)
#     if [ "$STATUS" == "ISSUED" ]; then
#         echo "ACM Certificate is ISSUED"
#         break
#     else
#         echo "Waiting for ACM Certificate to be ISSUED..."
#         sleep 30
#     fi
# done

# # 9. Get DNS validation record
# VALIDATION_RECORD=$(aws acm describe-certificate \
#     --certificate-arn $CERTIFICATE_ARN \
#     --query 'Certificate.DomainValidationOptions[0].ResourceRecord' \
#     --output json)

# VALIDATION_NAME=$(echo $VALIDATION_RECORD | jq -r '.Name')
# VALIDATION_VALUE=$(echo $VALIDATION_RECORD | jq -r '.Value')

# # Check if the values are null
# if [ -z "$VALIDATION_NAME" ] || [ -z "$VALIDATION_VALUE" ]; then
#     echo "Failed to retrieve DNS validation record. Exiting."
#     exit 1
# fi

# # 10. Add DNS validation record to Route 53 (Use UPSERT)
# aws route53 change-resource-record-sets \
#     --hosted-zone-id $HOSTED_ZONE_ID \
#     --change-batch '{
#       "Changes": [{
#         "Action": "UPSERT",
#         "ResourceRecordSet": {
#           "Name": "'$VALIDATION_NAME'",
#           "Type": "CNAME",
#           "TTL": 60,
#           "ResourceRecords": [{
#             "Value": "'$VALIDATION_VALUE'"
#           }]
#         }
#       }]
#     }'

# echo "DNS validation record added for $DOMAIN_NAME"

# # 11. Create HTTPS Listener with dynamic CERTIFICATE_ARN
# aws elbv2 create-listener \
#     --load-balancer-arn $LOAD_BALANCER_ARN \
#     --protocol HTTPS \
#     --port 443 \
#     --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN \
#     --certificates CertificateArn=$CERTIFICATE_ARN \
#     --ssl-policy ELBSecurityPolicy-2016-08

# echo "HTTPS Listener created for Load Balancer ARN: $LOAD_BALANCER_ARN"
