# List of users
users=("frontend" "mongodb" "catalogue")

# AWS region
region="us-east-1"

# Spot instance details
instance_type="t2.micro"
ami_id="ami-03265a0778a880afb"
security_group_id="sg-068a20157a2378db8"


# Route 53 details
hosted_zone_id="Z00815241ZW6NBO5CNYD8"
record_ttl=300
record_type="A"

# Iterate over the users
for user in "${users[@]}"; do
    # Create spot instance
    instance_id=$(aws ec2 request-spot-instances \
        --region "$region" \
        --instance-count 1 \
        --type "one-time" \
        --launch-specification "{
            \"InstanceType\": \"$instance_type\",
            \"ImageId\": \"$ami_id\",
            \"SecurityGroupIds\": [\"$security_group_id\"]
        }" | jq -r ".SpotInstanceRequests[0].InstanceId")



    # Wait for instance to be running
    aws ec2 wait instance-running --instance-ids "$instance_id" --region "$region"

    # Get instance IP address
    instance_ip=$(aws ec2 describe-instances \
        --instance-ids "$instance_id" \
        --query "Reservations[0].Instances[0].PublicIpAddress" \
        --region "$region" \
        --output text)

    # Check if instance IP is available
    if [[ -n "$instance_ip" ]]; then
        # Create Route 53 record
        record_name="$user.devops2023.online"

        aws route53 change-resource-record-sets \
            --region "$region" \
            --hosted-zone-id "$hosted_zone_id" \
            --change-batch "{
                \"Changes\": [
                    {
                        \"Action\": \"UPSERT\",
                        \"ResourceRecordSet\": {
                            \"Name\": \"$record_name\",
                            \"Type\": \"$record_type\",
                            \"TTL\": $record_ttl,
                            \"ResourceRecords\": [
                                {
                                    \"Value\": \"$instance_ip\"
                                }
                            ]
                        }
                    }
                ]
            }"

    fi
done