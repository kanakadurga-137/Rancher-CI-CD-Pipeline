#!/bin/bash
sed "s/tagVersion/$1/g" nginx.yml > node-app-pod.yml
