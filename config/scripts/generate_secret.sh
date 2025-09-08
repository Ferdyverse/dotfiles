#!/usr/bin/env bash

length=${1:-30}
generate_length=$((length + 4))
echo $(openssl rand -base64 "$generate_length" | tr -d '+=/\n' | cut -c1-"$length")
