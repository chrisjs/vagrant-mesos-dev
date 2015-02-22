#!/bin/bash
#
# Sample script to post to a Marathon instance, running a docker image
# that simply echos the date to a temp file, sleeps and loops.
#
# The IP used targets the default IP used in the Vagrant build, modify
# as needed.
#
# Author: Chris Schaefer
#
curl -X POST -H "Accept: application/json" -H "Content-Type: application/json" \
  10.0.0.10:8080/v2/apps -d '
{
    "id": "helloworld",
    "container": {
        "docker": {
            "image": "ubuntu"
        },
        "type": "DOCKER",
        "volumes": []
    },
    "cmd": "while true; do echo `date` >> /tmp/test; sleep 1; done",
    "cpus": 0.1,
    "mem": 32.0,
    "instances": 1
}'
