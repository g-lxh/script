#!/bin/bash

base_path=$(cd `dirname $0`;pwd)

curl -s http://10.0.0.28:31995/actuator/health | python -m json.tool
