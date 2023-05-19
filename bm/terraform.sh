#!/usr/bin/env bash

set -e

TERRAFORM_VERSION=${TERRAFORM_VERSION:-latest}

declare -a terraform=(docker run \
  --name terraform-cli \
  --interactive \
  --rm \
  --workdir /tmp/workspace/terraform \
  --volume "$(pwd)":/tmp/workspace/terraform \
  --volume "$(cd .. && pwd)":/tmp/workspace/work \
  --volume "${HOME}/.terraform.d:/root/.terraform.d" \
  --volume "${HOME}/.edgerc:/root/.edgerc:ro" \
  --volume "${HOME}/.terraformrc:/root/.terraformrc:ro" \
  --volume "${HOME}/.gitconfig:/root/.gitconfig:ro" \
  --volume "${HOME}/.aws:/root/.aws:ro" \
  --volume "${HOME}/.ssh:/root/.ssh:ro" \
  --env SSH_AUTH_SOCK="${SSH_AUTH_SOCK}" \
  --env TF_IN_AUTOMATION=1 \
  --env TF_CLI_ARGS="${TF_CLI_ARGS}" \
  --env TF_DATA_DIR="${TF_DATA_DIR}" \
  --env TF_IGNORE="${TF_IGNORE}" \
  --env TF_INPUT="${TF_INPUT}" \
  --env TF_WORKSPACE="${TF_WORKSPACE}" \
  --env TF_LOG="${TF_LOG}" \
  --env TF_LOG_PATH="${TF_LOG_PATH}" \
  --env TF_REGISTRY_CLIENT_TIMEOUT="${TF_REGISTRY_CLIENT_TIMEOUT}" \
  --env TF_CLI_CONFIG_FILE="${TF_CLI_CONFIG_FILE}" \
  --env AWS_PROFILE="${AWS_PROFILE:-default}" \
  --env AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-eu-west-1}" \
  --log-driver none \
  hashicorp/terraform:"${TERRAFORM_VERSION}"
)

main() {
  command="$1"
  shift 1
  case "${command}" in
      "init")
          "${terraform[@]}" "${command}" -upgrade "${@}"
          ;;
      "plan")
          "${terraform[@]}" init -upgrade
          "${terraform[@]}" "${command}" -compact-warnings "${@}"
          ;;
      "apply")
          "${terraform[@]}" init -upgrade
          "${terraform[@]}" plan -compact-warnings
          "${terraform[@]}" "${command}" -auto-approve "${@}"
          ;;
      "destroy")
          "${terraform[@]}" init -upgrade
          "${terraform[@]}" plan -compact-warnings
          "${terraform[@]}" "${command}" "${@}"
          ;;
      *)
          "${terraform[@]}" "${command}" "${@}"
          ;;
  esac
}

main "$@"
