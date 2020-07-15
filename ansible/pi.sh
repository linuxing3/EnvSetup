#!/usr/bin/env bash
set -euo pipefail

ansible-playbook -i hosts pi.yml
