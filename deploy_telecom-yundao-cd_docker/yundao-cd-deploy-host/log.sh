#!/bin/bash

base_path=$(cd `dirname $0`;pwd)

docker logs -f yundao-cd-deploy-host
