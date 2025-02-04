#!/usr/bin/env bash

set -e

TERRAFORM_VERSION=${TERRAFORM_VERSION:-latest}
PWD="$(pwd -P)"

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p "${TF_PLUGIN_CACHE_DIR}"

declare -a terraform=(docker run \
  --name terraform-cli \
  --interactive \
  --rm \
  --env TF_PLUGIN_CACHE_MAY_BREAK_DEPENDENCY_LOCK_FILE=1 \
  --env TF_PLUGIN_CACHE_DIR="/tmp/plugin-cache" \
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
  #--env AWS_CA_BUNDLE="/root/.aws/zscaler.pem"
  --workdir "$(PWD)" \
  --volume "$(PWD):$(PWD)" \
  --volume "${HOME}/.edgerc:/root/.edgerc:ro" \
  --volume "${HOME}/.gitconfig:/root/.gitconfig:ro" \
  --volume "${HOME}/.aws:/root/.aws:ro" \
  # workarround for ZSCALER http requests
  # sudo cp -p /opt/homebrew/etc/ca-certificates/cert.pem /etc/ssl/certs
  --volume "${HOME}/.ssh:/root/.ssh:ro" \
  --volume "/etc/ssl/certs:/etc/ssl/certs:ro" \
  --volume "$TF_PLUGIN_CACHE_DIR:/tmp/plugin-cache" \
  --log-driver none \
  hashicorp/terraform:"${TERRAFORM_VERSION}"
)

main() {
  if [ $# -eq 0 ]; then
    echo "No argument provided. Try: validate, init, plan, apply, destroy."
    exit 0
  fi

  export DOCKER_DEFAULT_PLATFORM="${DOCKER_DEFAULT_PLATFORM:-linux/amd64}"
  command="$1"
  shift 1
  case "${command}" in
    "validate")
      "${terraform[@]}" fmt
      [ -f .terraform/terraform.tfstate ] || "${terraform[@]}" init -upgrade -reconfigure
      tflint --chdir "$PWD"
      "${terraform[@]}" "${command}" "${@}"
      ;;
    "init")
      "${terraform[@]}" "${command}" -upgrade -reconfigure "${@}"
      ;;
    "plan")
      [ -f .terraform/terraform.tfstate ] || "${terraform[@]}" init -upgrade
      "${terraform[@]}" "${command}" -compact-warnings "${@}"
      ;;
    "apply")
      [ -f .terraform/terraform.tfstate ] || "${terraform[@]}" init -upgrade
      "${terraform[@]}" "${command}" -lock=false -auto-approve "${@}"
      ;;
    "destroy")
      [ -f .terraform/terraform.tfstate ] || "${terraform[@]}" init -upgrade
      "${terraform[@]}" "${command}" "${@}"
      ;;
    "state"|"show"|"output")
      [ -f .terraform/terraform.tfstate ] || "${terraform[@]}" init -upgrade
      "${terraform[@]}" "${command}" "${@}"
      ;;
    "version"|"console"|"fmt"|"force-unlock")
      "${terraform[@]}" "${command}" "${@}"
      ;;
    "clean")
      rm -rf "${PWD}"/.terraform
      ;;
    *)
      "${command}" "${@}"
      ;;
  esac
}

main "$@"
