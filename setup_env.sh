#!/bin/bash
# This script reads environment variables from a .env file and exports them.
ENV_FILE=".env"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	echo "Error: This script must be sourced, not executed."
	echo "Usage: source setup_env.sh"
	exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
	echo "Error: $ENV_FILE not found in $(pwd)"
	exit 1
fi

while IFS= read -r line; do
	# Skip empty lines and comments
	[[ -z "$line" || "$line" =~ ^# ]] && continue
	# Export variable
	export ${line}
	# Optionally, you can print the variable being set
	# echo "Exported: $line"
done < "$ENV_FILE"


echo "Environment variables set successfully."
