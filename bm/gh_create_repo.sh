description="$@"
gh repo create \
    --public \
    --remote origin \
    --description "$description" \
    --source . \
    --push
