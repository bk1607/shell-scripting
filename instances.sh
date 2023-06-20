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


done
