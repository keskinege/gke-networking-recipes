#!/bin/bash

# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit;
set -o nounset;
set -o pipefail;
set -o xtrace;

source ./test/helper.sh
test_name="ingress-cloudarmor"
context=$(get_context "${test_name}")

if [[ -z "${context}" ]]; then
    exit 1
fi

vip=$(wait_for_ingress_ip "cloudarmor-test" "${test_name}" "${context}")

check_http_status "${vip}/whereami" 200
check_http_status "${vip}" 404
check_http_status "${vip}/whereami" 502 "" "${test_name}" "${ZONE}"
check_http_status "${vip}" 404 "" "${test_name}" "${ZONE}"
