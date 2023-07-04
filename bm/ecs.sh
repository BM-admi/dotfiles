CLUSTER=${1:-demo-testing-app}
for task in $( aws ecs list-tasks --cluster "$CLUSTER" | jq -r ".taskArns[]" ); do
  tds=$( aws ecs describe-tasks --cluster "$CLUSTER" --tasks "$task" )
  for td in "${tds[@]}"; do
    echo "$td"
    aws ecs describe-task-definition --task-definition "$( echo "$td" | jq -r ".tasks[].taskDefinitionArn"| awk -F"/" '{print $2}' )"
  done
done
